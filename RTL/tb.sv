`timescale 1ns/1ns

`define IN_FILE  "E:/JPEG-LS/images/test9.pgm"
`define OUT_FILE "E:/JPEG-LS/result/hwresult9.jls"
`define OUT_ENABLE 1

module tb_jls_encoder();

localparam MAXLEN_LEVEL = 12;
localparam MIN_WIDTH    = 4;
localparam MAX_WIDTH    = (1<<MAXLEN_LEVEL) - 1;

function automatic void fclose_safe(ref int fp);
    if(fp!=0)
        $fclose(fp);
    fp = 0;
endfunction

function automatic int open_pgm_file(ref logic [31:0] width, ref logic [31:0] height);
    int linelen = 0;
    automatic int fp = 0;
    automatic int depth = 0;
    automatic logic [256*8-1:0] line;
    {width, height} = '0;
    fp = $fopen(`IN_FILE, "rb");
    if(fp==0)
        return 0;
    linelen = $fgets(line, fp);
    if(line[8*(linelen-2)+:16]!=16'h5035) begin
        $write("*** error: must be P5\n");
        fclose_safe(fp);
        return 0;
    end
    $fgets(line, fp);
    $sscanf(line, "%d%d", width, height);
    $fgets(line, fp);
    $sscanf(line, "%d", depth);
    $write("image info: width=%5d  height=%5d  depth=%5d\n", width, height, depth);
    if(depth!=255) begin
        $write("*** error: images depth must be 255\n");
        fclose_safe(fp);
        return 0;
    end
    if(width<MIN_WIDTH || (width>MAX_WIDTH)) begin
        $write("*** error: images width must in range %d-%d\n", MIN_WIDTH, MAX_WIDTH);
        fclose_safe(fp);
        return 0;
    end
    if(height==0) begin
        $write("*** error: images height must >0\n",);
        fclose_safe(fp);
        return 0;
    end
    return fp;
endfunction





int fpin=0, fpout=0;
reg [31:0] width=0, height=0;

reg        clk = 1'b0;
always #10 clk = ~clk;  //50MHz
reg        rst = 1'b1;
reg        ivalid = 1'b0;
reg [ 7:0] idata  = '0;
reg [31:0] cnt    = 0;

always @ (posedge clk) begin
    rst <= 1'b1;
    {ivalid,idata} <= '0;
    if(cnt==0) begin
        fpin = open_pgm_file(width, height);
        if(`OUT_ENABLE)
            fpout = $fopen(`OUT_FILE, "wb");
        if(fpin==0)
            $stop;
        cnt <= cnt + 1;
    end else if(cnt<400) begin
        cnt <= cnt + 1;
    end else if(cnt<400+width*height) begin
        if($feof(fpin)) begin
            $write("*** error: input image length=%dB, expect %dB\n", cnt-400, width*height);
            fclose_safe(fpin);
            $stop;
        end else begin
            automatic int rbyte;
            rbyte = $fgetc(fpin);
            rst    <= 1'b0;
            ivalid <= 1'b1;
            idata  <= rbyte;
        end
        cnt <= cnt + 1;
    end else if(cnt==400+width*height) begin
        fclose_safe(fpin);
        cnt <= cnt + 1;
    end else if(cnt<500+width*height) begin
        cnt <= cnt + 1;
    end else begin
        fclose_safe(fpin);
        fclose_safe(fpout);
        $stop;
    end
end

wire          ovalid;
wire   [7:0]  odata;

jls_encoder #(
    .MAXLEN_LEVEL ( MAXLEN_LEVEL            )
) jls_encoder_dut (
    .rst          ( rst                     ),
    .clk          ( clk                     ),
    .width        ( width[MAXLEN_LEVEL-1:0] ),
    .height       ( height[15:0]            ),
    .ivalid       ( ivalid                  ),
    .idata        ( idata                   ),
    /*
    .pvalid       ( pvalid                  ),
    .pones        ( pones                   ),
    .pcnts        ( pcnts                   ),
    .pdata        ( pdata                   ),
    
    .bvalid       ( bvalid                  ),
    .bcnts        ( bcnts                   ),
    .bdata        ( bdata                   ),
    */
    .ovalid       ( ovalid                  ),
    .odata        ( odata                   )
);

always @ (posedge clk)
    if(ovalid)
        $fwrite(fpout, "%c", odata);

endmodule
