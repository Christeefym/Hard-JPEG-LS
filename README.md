![test](https://img.shields.io/badge/test-passing-green.svg)
![docs](https://img.shields.io/badge/docs-passing-green.svg)
![platform](https://img.shields.io/badge/platform-Quartus|Vivado-blue.svg)

FPGA-based JPEG-LS image encoder
===========================
基于 **FPGA** 的流式的 **JPEG-LS** 图象压缩器

> 本库于 2021.7 重大更新，目前已支持**无损模式**（**NEAR=0**）和**有损模式**（**NEAR=1~7 可调**）。



# 特点

* 用于压缩 **8bit** 的灰度图像。
* 可选**无损模式**，即 NEAR=0 。
* 可选**有损模式**，NEAR=1~7 可调。
* 图像宽度取值范围为[5,16384]，高度取值范围为[1,16384]。
* 极简流式输入输出。
* 完全使用 **SystemVerilog** 实现，便于移植和仿真。



# 背景知识

**JPEG-LS** （简称**JLS**）是一种无损/有损的图像压缩算法，其无损模式的压缩率相当优异，优于 Lossless-JPEG、Lossless-JPEG2000、Lossless-JPEG-XR、FELICES 等。**JPEG-LS** 用压缩前后的像素的最大差值（**NEAR**值）来控制失真，无损模式下 **NEAR=0**；有损模式下**NEAR>0**，**NEAR** 越大，失真越大，压缩率也越大。**JPEG-LS** 压缩图像的文件后缀是 .**jls** 。



# 使用方法

[**RTL/jls_encoder.sv**](https://github.com/WangXuan95/Hard-JPEG-LS/blob/master/RTL/jls_encoder.sv) 是用户可以调用的 JPEG-LS 压缩模块，它输入图像原始像素，输出 JPEG-LS 压缩流。

## 参数

**jls_encoder** 只有一个参数：

```verilog
parameter logic [2:0] NEAR
```

决定了 **NEAR** 值，取值为 3'd0 时，工作在无损模式；取值为  3'd1~3'd7 时，工作在有损模式。

## 信号

**jls_encoder** 的输入输出信号描述如下表。

| 信号名称 | 全称 | 方向 | 宽度 | 描述 |
| :---: | :---: | :---: | :---: | :--- |
| rstn | 同步复位 | input | 1bit | 当时钟上升沿时若 rstn=0，模块复位，正常使用时 rstn=1 |
| clk | 时钟 | input | 1bit | 时钟，所有信号都应该于 clk 上升沿对齐。 |
| i_sof | 图像开始 | input | 1bit | 当需要输入一个新的图像时，保持至少368个时钟周期的 i_sof=1 |
| i_w | 图像宽度-1 | input | 14bit | 例如图像宽度为 1920，则 i_w 应该置为 14‘d1919。需要在 i_sof=1 时保持有效。 |
| i_h | 图像高度-1 | input | 14bit | 例如图像宽度为 1080，则 i_h 应该置为 14‘d1079。需要在 i_sof=1 时保持有效。 |
| i_e | 输入像素有效 | input | 1bit | 当 i_e=1 时，一个像素需要被输入到 i_x 上。 |
| i_x | 输入像素    | input | 8bit | 像素取值范围为 8'd0 ~ 8'd255 。 |
| o_e | 输出有效    | output | 1bit | 当 o_e=1 时，输出流数据产生在 o_data 上。 |
| o_data | 输出流数据 | output | 16bit | 大端序，o_data[15:8] 在先；o_data[7:0] 在后。 |
| o_last | 输出流末尾 | output | 1bit | 当 o_e=1 时若 o_last=1 ，说明这是一张图象的输出流的最后一个数据。 |

> 注：i_w 不能小于 14'd4 。

## 输入图片

**jls_encoder 模块**的操作的流程是：

1. **复位**（可选）：令 rstn=0 至少 **1 个周期**进行复位，之后正常工作时都保持 rstn=1。实际上也可以不复位（即让 rstn 恒为1）。
2. **开始**：保持 i_sof=1 **至少 368 个周期**，同时在 i_w 和 i_h 信号上输入图像的宽度和高度，i_sof=1 期间 i_w 和 i_h 要一直保持有效。
3. **输入**：控制 i_e 和 i_x，从左到右，从上到下地输入该图像的所有像素。当 i_e=1 时，i_x 作为一个像素被输入。
4. **图像间空闲**：所有像素输入结束后，需要空闲**至少 16 个周期**不做任何动作（即 i_sof=0，i_e=0）。然后才能跳到第2步，开始下一个图像。

i_sof=1 和 i_e=1 之间；以及 i_e=1 各自之间可以插入任意个空闲气泡（即， i_sof=0，i_e=0），这意味着我们可以断断续续地输入像素（当然，不插入任何气泡才能达到最高性能）。

下图展示了压缩 2 张图像的输入时序图（//代表省略若干周期，X代表don't care）。其中图像 1 在输入第一个像素后插入了 1 个气泡；而图像 2 在 i_sof=1 后插入了 1 个气泡。注意**图像间空闲**必须至少 **16 个周期**。

               __    __//  __    __    __    __   //_    __    //    __    __//  __    __    __    //    __
    clk    \__/  \__/  //_/  \__/  \__/  \__/  \__// \__/  \__///\__/  \__/  //_/  \__/  \__/  \__///\__/  \_
                _______//________                 //           //     _______//________            //
    i_sof  ____/       //        \________________//___________//____/       //        \___________//________
                _______//________                 //           //     _______//________            //
    i_w    XXXXX_______//________XXXXXXXXXXXXXXXXX//XXXXXXXXXXX//XXXXX_______//________XXXXXXXXXXXX//XXXXXXXX
                _______//________                 //           //     _______//________            //
    i_h    XXXXX_______//________XXXXXXXXXXXXXXXXX//XXXXXXXXXXX//XXXXX_______//________XXXXXXXXXXXX//XXXXXXXX
                       //         _____       ____//_____      //            //               _____//____
    i_e    ____________//________/     \_____/    //     \_____//____________//______________/     //    \___
                       //         _____       ____//_____      //            //               _____//____
    i_x    XXXXXXXXXXXX//XXXXXXXXX_____XXXXXXX____//_____XXXXXX//XXXXXXXXXXXX//XXXXXXXXXXXXXXX_____//____XXXX
    
    阶段：      |    开始图像1     |        输入图像1       | 图像间空闲  |    开始图像2      |       输入图像2       

## 输出压缩流

在输入过程中，**jls_encoder** 同时会输出压缩好的 **JPEG-LS流**，该流构成了完整的 .jls 文件的内容（包括文件头部和尾部）。o_e=1 时，o_data 是一个有效输出数据。其中，o_data 遵循大端序，即 o_data[15:8] 在流中的位置靠前，o_data[7:0] 在流中的位置靠后。在每个图像的输出流遇到最后一个数据时，o_last=1 指示一张图像的压缩流结束。



# 仿真

本库提供一个仿真（testbench）代码，可以将指定文件夹里的 .pgm 格式的未压缩图像批量送入 **jls_encoder** 进行压缩，然后将 **jls_encoder** 的输出结果保存到 .jls 文件里。

## 仿真相关文件

* [**RTL/tb_jls_encoder.sv**](https://github.com/WangXuan95/Hard-JPEG-LS/blob/master/RTL/tb_jls_encoder.sv) 是仿真代码。它调用 [**RTL/jls_encoder.sv**](https://github.com/WangXuan95/Hard-JPEG-LS/blob/master/RTL/jls_encoder.sv)  进行仿真。
* **images** 是仿真的输入文件夹，包含一些 .pgm 格式的 8bit 灰度图。 .pgm 格式存储的是未压缩的原始像素，可以使用 photoshop 等软件或[该网页](https://filext.com/file-extension/PGM)来查看。
* **images_jls** 是仿真的输出文件夹，用于存放仿真输出的 .jls 压缩图像。

## 仿真步骤

以 Vivado 为例，进行行为仿真。步骤如下：

- 建立 Vivado 工程，将 [**RTL/tb_jls_encoder.sv**](https://github.com/WangXuan95/Hard-JPEG-LS/blob/master/RTL/tb_jls_encoder.sv) 和 [**RTL/jls_encoder.sv**](https://github.com/WangXuan95/Hard-JPEG-LS/blob/master/RTL/jls_encoder.sv)  加入工程。以 tb_jls_encoder 模块为仿真顶层。
- 将 [**RTL/tb_jls_encoder.sv**](https://github.com/WangXuan95/Hard-JPEG-LS/blob/master/RTL/tb_jls_encoder.sv) 里的宏名 **INPUT_PGM_DIR** 改成你的计算机里的 **images** 文件夹（即输入文件夹）的路径。注意！Windows下的目录分隔符为\\（单反斜杠），但因为 Verilog 字符串需要转义，所以这里的分隔符是\\\\（双反斜杠）。
- 将 [**RTL/tb_jls_encoder.sv**](https://github.com/WangXuan95/Hard-JPEG-LS/blob/master/RTL/tb_jls_encoder.sv) 里的宏名 **OUTPUT_JLS_DIR** 改成你的电脑里 **images_jls** 文件夹（即输出文件夹）的路径。
- 运行仿真，运行时间可以设置的很长（比如1000s），压缩完所有图像后它会遇到 $stop; 而停止。
- 仿真结束，**images_jls** 文件夹里出现压缩后的 .jls 文件。

.pgm 文件有一个简单的文件头格式， [**RTL/tb_jls_encoder.sv**](https://github.com/WangXuan95/Hard-JPEG-LS/blob/master/RTL/tb_jls_encoder.sv) 里的 load_img 函数解析该格式，读出图像的宽和高，并把它的所有像素放在 img 数组里。总之，你可以不关注 .pgm 的格式，重点关注仿真波形，关注如何操作 **jls_encoder** 的时序。

你还可以用以下方式来进行更全面的仿真：

- 修改 [**RTL/tb_jls_encoder.sv**](https://github.com/WangXuan95/Hard-JPEG-LS/blob/master/RTL/tb_jls_encoder.sv) 里的宏名 **NEAR** 。
- 修改 [**RTL/tb_jls_encoder.sv**](https://github.com/WangXuan95/Hard-JPEG-LS/blob/master/RTL/tb_jls_encoder.sv) 里的宏名 **BUBBLE_CONTROL** 来决定相邻像素间插入多少个气泡：
  - **BUBBLE_CONTROL=0** 时，不插入任何气泡。
  - **BUBBLE_CONTROL>0** 时，插入 **BUBBLE_CONTROL **个气泡。
  - **BUBBLE_CONTROL<0** 时，每次插入随机的 **0~(-BUBBLE_CONTROL)** 个气泡
- 你可以往 **images** 文件夹中放入更多的 .pgm 文件来压缩，文件名必须形如 testXXX.pgm （XXX 是三个数字）。

> 在不同 NEAR 值和 BUBBLE_CONTROL 值下，本库已经经过了几百张照片的结果对比验证，充分保证无bug。（这部分自动化验证代码就没放上来了）

## 结果查看

因为 **JPEG-LS** 比较小众和专业，大多数图片查看软件无法查看 .jls 文件。可以用我提供的解压器 [**decoder.exe**](https://github.com/WangXuan95/Hard-JPEG-LS/blob/master/decoder.exe) 来把它解压回 .pgm 文件再查看。用 CMD 运行命令：

```powershell
.\decoder.exe <JLS_FILE_NAME> <PGM_FILE_NAME>
```

例如：

```powershell
.\decoder.exe images_jls\test000.jls tmp.pgm
```

> 注：decoder.exe 编译自 UBC 提供的 C 语言源码： http://www.stat.columbia.edu/~jakulin/jpeg-ls/mirror.htm

或者也可以直接用[该网站](https://filext.com/file-extension/JLS)直接查看 .jls 文件。



# FPGA 部署

在 Xilinx Artix-7 xc7a35tcsg324-2 上，综合和实现的结果如下。

|    LUT     |    FF    |              BRAM              | 最高时钟频率 |
| :--------: | :------: | :----------------------------: | :----------: |
| 2347 (11%) | 932 (2%) | 9个RAMB18 (9%)，等效于 144Kbit |    35 MHz    |

35MHz 下，图像压缩的性能为 35 Mpixel/s ，对 1920x1080 图像的压缩帧率是 16.8fps 。
