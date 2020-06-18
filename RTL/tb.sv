`timescale 1ns/1ns

`define START_INDEX 1
`define FINAL_INDEX 11
`define IN_FILE_FORMAT   "E:/JPEG-LS/images/test%04d.pgm"
`define OUT_FILE_FORMAT  "E:/JPEG-LS/result/result%04d.jls"
`define OUT_ENABLE 1

module tb_jls_encoder();

localparam MAXLEN_LEVEL = 12;
localparam MIN_WIDTH    = 4;
localparam MAX_WIDTH    = (1<<MAXLEN_LEVEL) - 1;

int           file_in_index=`START_INDEX, file_out_index=`START_INDEX;
reg [256*8:1] fname_in, fname_out;

int         fpin=0 , fpout=0;
reg [31:0]  width=0, height=0;

reg         clk = 1'b0;
always #10  clk = ~clk;  //50MHz
reg         rst = 1'b1;
reg         inew   = 1'b0;
reg         ivalid = 1'b0;
reg  [ 7:0] idata  = '0;
wire        ovalid, olast, oerror;
wire [ 7:0] odata;

function automatic void fclose_safe(ref int fp);
    if(fp!=0)
        $fclose(fp);
    fp = 0;
endfunction

function automatic int open_pgm_file(input logic [256*8:1] fname, ref logic [31:0] width, ref logic [31:0] height);
    int linelen = 0;
    automatic int input_image_fp = 0;
    automatic int depth = 0;
    automatic logic [256*8-1:0] line;
    {width, height} = '0;
    input_image_fp = $fopen(fname, "rb");
    if(input_image_fp==0) begin
        $write("*** error: could not open %s\n", fname);
        return 0;
    end
    linelen = $fgets(line, input_image_fp);
    if(line[8*(linelen-2)+:16]!=16'h5035) begin
        $write("*** error: must be P5\n");
        fclose_safe(input_image_fp);
        return 0;
    end
    $fgets(line, input_image_fp);
    $sscanf(line, "%d%d", width, height);
    $fgets(line, input_image_fp);
    $sscanf(line, "%d", depth);
    $write("image info: width=%5d  height=%5d  depth=%5d\n", width, height, depth);
    if(depth!=255) begin
        $write("*** error: images depth must be 255\n");
        fclose_safe(input_image_fp);
        return 0;
    end
    if(width<MIN_WIDTH || (width>MAX_WIDTH)) begin
        $write("*** error: images width must in range %d-%d\n", MIN_WIDTH, MAX_WIDTH);
        fclose_safe(input_image_fp);
        return 0;
    end
    if(height==0) begin
        $write("*** error: images height must >0\n",);
        fclose_safe(input_image_fp);
        return 0;
    end
    return input_image_fp;
endfunction

task automatic delay(input int cycles);
    for(int ii=0; ii<cycles; ii++) begin
        @(posedge clk) begin
            rst <= 1'b0;
            inew   <= 1'b0;
            ivalid <= 1'b0;
            idata  <= '0;
        end
    end
endtask

task automatic feed_image_and_close(input int input_image_fp);
    for(int ii=0; ii<368; ii++) begin
        @(posedge clk) begin
            rst <= 1'b0;
            inew   <= 1'b1;
            ivalid <= 1'b0;
            idata  <= '0;
        end
    end
    for(int ii=0; ii<10; ii++) begin
        @(posedge clk) begin
            rst <= 1'b0;
            inew   <= 1'b0;
            ivalid <= 1'b0;
            idata  <= '0;
        end
    end
    while(!$feof(input_image_fp)) begin
        @(posedge clk) begin
            automatic int rbyte;
            rbyte = $fgetc(input_image_fp);
            if($feof(input_image_fp)) begin
                inew   <= 1'b0;
                ivalid <= 1'b0;
                idata  <= '0;
            end else begin
                inew   <= 1'b0;
                ivalid <= 1'b1;
                idata  <= rbyte;
            end
        end
        @(posedge clk) begin
            inew   <= 1'b0;
            ivalid <= 1'b0;
            idata  <= '0;
        end
    end
    fclose_safe(fpin);
endtask

initial begin
    @(posedge clk) rst <= 1'b1;
    for(file_in_index=`START_INDEX; file_in_index<=`FINAL_INDEX; file_in_index++) begin
        $sformat(fname_in, `IN_FILE_FORMAT, file_in_index);
        fpin = open_pgm_file(fname_in, width, height);
        if(fpin==0) begin
            delay(300);
            $stop;
        end else
            feed_image_and_close(fpin);
    end
    delay(300);
    $stop;
end

always @ (posedge clk)
    if(`OUT_ENABLE && ovalid) begin
        if(fpout==0) begin
            $sformat(fname_out, `OUT_FILE_FORMAT, file_out_index);
            file_out_index++;
            fpout = $fopen(fname_out , "wb");
        end
        $fwrite(fpout, "%c", odata);
        if(olast) begin
            if(oerror) $fwrite(fpout, "\nerror!\n");
            fclose_safe(fpout);
        end
    end

jls_encoder #(
    .MAXLEN_LEVEL ( MAXLEN_LEVEL            )
) jls_encoder_dut (
    .rst          ( rst                     ),
    .clk          ( clk                     ),
    .inew         ( inew                    ),
    .iwidth       ( width[MAXLEN_LEVEL-1:0] ),
    .iheight      ( height[15:0]            ),
    .ivalid       ( ivalid                  ),
    .idata        ( idata                   ),
    .ovalid       ( ovalid                  ),
    .olast        ( olast                   ),
    .oerror       ( oerror                  ),
    .odata        ( odata                   )
);

endmodule
