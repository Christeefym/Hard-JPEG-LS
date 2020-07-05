![test](https://img.shields.io/badge/test-passing-green.svg)
![docs](https://img.shields.io/badge/docs-passing-green.svg)
![platform](https://img.shields.io/badge/platform-Quartus|Vivado-blue.svg)

JPEG-LS image encoder for FPGAs
===========================
基于**FPGA**的流式的**JPEG-LS**图象编码器



# 特点

* 使用**JPEG-LS**近无损模式，**NEAR=2**，对于照片一般有**6倍**的压缩率。
* 仅支持**8bit**深度的灰度图片。
* 宽度取值范围为[4,4095]，高度取值范围为[1,65535]。
* 完全使用**SystemVerilog**实现，便于移植和仿真。

# 背景知识

**JPEG-LS** 是一种近无损的图像压缩算法，在损失值**NEAR=2**时，可以保证压缩后的像素误差<=2，并对照片获得约6倍的压缩率。使用**JPEG-LS**压缩的图像在添加文件头后往往存储在.jls文件中。

# 使用方法

[**jls_encoder.sv**](https://github.com/WangXuan95/Hard-JPEG-LS/blob/master/RTL/jls_encoder.sv) 中的 **jls_encoder** 是顶层模块，它的接口描述如下表。

| 信号名称 | 全称 | 方向 | 宽度 | 描述 |
| :---: | :---: | :---: | :---: | :--- |
| rst | 完全复位 | input | 1bit | 当rst=1时，模块完全复位，正常操作时rst=0 |
| clk | 时钟 | input | 1 | 需要提供一个时钟信号 |
| inew | 准备输入的待压缩的新图片 | input | 1bit | 当需要输入一个新的图片时，inew需要保持至少368个时钟周期的高电平 |
| iwidth | 准备输入的待压缩的新图片的宽度 | input | 12bit | inew=1时，iwidth需要保持有效，指示了待压缩的新图片的宽度 |
| iheight | 准备输入的待压缩的新图片的宽度 | input | 16bit | inew=1时，iheight需要保持有效，指示了待压缩的新图片的高度 |
| ivalid | 输入像素有效 | input | 1bit | ivalid=1时，一个像素被输入 |
| idata  | 输入像素    | input | 8bit | ivalid=1时，idata是输入的像素 |
| ovalid | 输出有效    | output | 1bit | ovalid=1时，odata有效，odata是压缩后的JPEG-LS流的一个字节 |
| olast | 输出流结束 | output | 1bit | olast=1时，说明一个JPEG-LS图片已经完全输出完，此时的odata是该JPEG-LS流的最后一个字节 |
| oerror | 输出流错误 | output | 1bit | olast=1的同时，如果oerror=1，说明输入的图片不完整，输出流错误地过早结束 |
| odata | 输出字节 | output | 8bit | ovalid=1时，odata是输出字节 |

**jls_encoder 模块** 操作的流程是：
1. 令rst=0，在clk上提供一个稳定的时钟信号。
2. 保持inew=1至少368周期，同时在iwidth和iheight信号上输入图片的宽度和高度，inew=1时必须保持iwidth和iheight有效。然后再令inew=0。
3. 从左到右，从上到下的输入一个图片的所有像素。当ivalid=1时，idata作为一个像素被输入。
4. 输入结束后，跳到第2步开始输入下一个图片。

ivalid和idata可以断断续续的有效，或者连续的有效，这意味着**jls_encoder**输入像素的方式极其灵活。如果要获得最高的压缩性能，如**图1**，在inew=0后立刻令ivalid=1并输入第一个字节，然后连续保持ivalid=1，连续输入所有像素后立刻令inew=1以准备输入下一个图片。

| ![输入图](https://github.com/WangXuan95/Hard-JPEG-LS/blob/master/doc/input_wave.png) |
| :----: |
| **图1** : **jls_encoder** 输入波形图（最高的压缩性能） |

输出的波形图如**图2**。输入图片的同时，**jls_encoder**会输出压缩好的**JPEG-LS流**，该流构成了完整的.jls文件的内容（包括文件头部）。ovalid=1时，odata是一个有效输出字节。在每个图片的最后一个字节，olast=1以指示一个图片结束，如果oerror=1，说明输入的图片不完整，产生了一个错误。注意：出现错误后不需要采取任何复位措施。

| ![输出图](https://github.com/WangXuan95/Hard-JPEG-LS/blob/master/doc/output_wave.png) |
| :----: |
| **图2** : **jls_encoder** 输出波形图 |


# 仿真

* [**images**](https://github.com/WangXuan95/Hard-JPEG-LS/blob/master/images) 是仿真的输入目录，该目录中提供了16个输入图片实例（为PGM格式，可以使用photoshop查看）。
* [**result**](https://github.com/WangXuan95/Hard-JPEG-LS/blob/master/images) 是仿真的输出目录，该目录用于存放输出的.jls图片。
* 请修改仿真的顶层文件 [**tb.sv**](https://github.com/WangXuan95/Hard-JPEG-LS/blob/master/RTL/tb.sv) 。将第5行修改为你的计算机上的输入目录，将第6行修改为你的计算机上的输出目录。
* 使用 [**tb.sv**](https://github.com/WangXuan95/Hard-JPEG-LS/blob/master/RTL/tb.sv) 和 [**jls_encoder.sv**](https://github.com/WangXuan95/Hard-JPEG-LS/blob/master/RTL/jls_encoder.sv) 进行仿真。该仿真会自动读取 [**images**](https://github.com/WangXuan95/Hard-JPEG-LS/blob/master/images) 目录中的图片，使用 [**jls_encoder.sv**](https://github.com/WangXuan95/Hard-JPEG-LS/blob/master/RTL/jls_encoder.sv) 压缩后产生多个.jls图片的内容，并依次输出到 [**result**](https://github.com/WangXuan95/Hard-JPEG-LS/blob/master/images) 目录中。
* 你可以使用[**该网站**](https://filext.com/file-extension/JLS)查看压缩后的图片。


# 资源占用

下表展示了**jls_encoder模块**的资源消耗：

| **FPGA 型号**                 |  LUT  | LUT(%) | FF    | FF(%)  | Logic   | Logic(%) | BRAM    | BRAM(%) |
| :-----------:                 | :---: | :---:  | :---: | :----: | :----:  | :----:   | :----:  | :----:  |
| **Xilinx Artix-7 XC7A35T**    | 2702  | 13%    | 1077  | 3%     | -       | -        | 81kbit | 4.5%     |
| **Altera Cyclone IV EP4CE22** | 5280  | -      | 1108 | -      | 5323   | 24%      | 159kbit | 26%     |

# 性能

在 **Xilinx Artix-7 xc7a35ticsg324-1L** 上，**jls_encoder** 在 **22MHz** 下刚好时序收敛，在最高性能的操作模式下，能达到如下性能：

* 输入吞吐率 ： 22MBps
* 640x480p ： 71fps
* 800*600p : 45fps
* 1280*720p : 23fps
* 1920*1080p : 10fps
