`timescale 1ns/1ns

// bubble numbers that insert between pixels
`define NUM_BUBBLES 0

`define NEAR 1

// the input and output file names' format
`define FILE_NAME_FORMAT  "test%03d"

// input file (uncompressed .pgm file) directory
`define INPUT_PGM_DIR     "E:\\FPGAcommon\\Hard-JPEG-LS\\images"

// output file (compressed .jls file) directory
`define OUTPUT_JLS_DIR    "E:\\FPGAcommon\\Hard-JPEG-LS\\images_jls"


module tb_jls_encoder();

// -------------------------------------------------------------------------------------------------------------------
//   generate clock and reset
// -------------------------------------------------------------------------------------------------------------------
reg      rstn = 1'b0;
reg       clk = 1'b0;
always #50 clk = ~clk;  // 10MHz
initial begin repeat(4) @(posedge clk); rstn<=1'b1; end


// -------------------------------------------------------------------------------------------------------------------
//   signals for jls_encoder_i module
// -------------------------------------------------------------------------------------------------------------------
reg        i_sof = '0;
reg [13:0] i_w = '0;
reg [13:0] i_h = '0;
reg        i_e = '0;
reg [ 7:0] i_x = '0;
wire       o_e;
wire[15:0] o_data;
wire       o_last;


// -------------------------------------------------------------------------------------------------------------------
//   function: load image to array from PGM file
//   arguments:
//        fname: input .pgm file name
//        img  : image array
//        w   : image width
//        h   : image height
//   return:
//        0  : success
//        -1 : failed
// -------------------------------------------------------------------------------------------------------------------
function automatic int load_img(input logic [256*8:1] fname, ref logic [7:0] img [], ref int w, ref int h);
    int linelen, depth=0, scanf_num;
    logic [256*8-1:0] line;
    int fp = $fopen(fname, "rb");
    if(fp==0) begin
        //$display("*** error: could not open file.");
        return -1;
    end
    linelen = $fgets(line, fp);
    if(line[8*(linelen-2)+:16] != 16'h5035) begin
        $display("*** error: the first line must be P5");
        $fclose(fp);
        return -1;
    end
    scanf_num = $fgets(line, fp);
    scanf_num = $sscanf(line, "%d%d", w, h);
    if(scanf_num == 1) begin
        scanf_num = $fgets(line, fp);
        scanf_num = $sscanf(line, "%d", h);
    end
    scanf_num = $fgets(line, fp);
    scanf_num = $sscanf(line, "%d", depth);
    if(depth!=255) begin
        $display("*** error: images depth must be 255");
        $fclose(fp);
        return -1;
    end
    img = new[h*w];
    for(int i=0; i<h; i++)
        for(int j=0; j<w; j++)
            img[i*w+j] = $fgetc(fp);
    $fclose(fp);
    return 0;
endfunction


// -------------------------------------------------------------------------------------------------------------------
//   task: feed image pixels to jls_encoder_i module
//   arguments:
//         img : input image array
//         w   : image width
//         h   : image height
//         num_bubbles : bubble numbers that insert between pixels
// -------------------------------------------------------------------------------------------------------------------
task automatic feed_img(input logic [7:0] img [], input int w, input int h, input int num_bubbles);
    repeat(13) begin
        @(posedge clk)
        i_sof <= 1'b1;
        i_w <= w - 1;
        i_h <= h - 1;
        {i_e, i_x} <= '0;
    end
    repeat(num_bubbles) @(posedge clk) {i_sof, i_w, i_h, i_e, i_x} <= '0;
    foreach(img[i]) begin
        @(posedge clk)
        {i_sof, i_w, i_h} <= '0;
        i_e <= 1'b1;
        i_x <= img[i];
        repeat(num_bubbles) @(posedge clk) {i_sof, i_w, i_h, i_e, i_x} <= '0;
    end
    repeat(16) @(posedge clk) {i_sof, i_w, i_h, i_e, i_x} <= '0;
endtask


// -------------------------------------------------------------------------------------------------------------------
//   jls_encoder_i module
// -------------------------------------------------------------------------------------------------------------------
jls_encoder #(
    .NEAR     ( `NEAR     )
) jls_encoder_i (
    .rstn     ( rstn      ),
    .clk      ( clk       ),
    .i_sof    ( i_sof     ),
    .i_w      ( i_w       ),
    .i_h      ( i_h       ),
    .i_e      ( i_e       ),
    .i_x      ( i_x       ),
    .o_e      ( o_e       ),
    .o_data   ( o_data    ),
    .o_last   ( o_last    )
);


// file number
int file_no;


// -------------------------------------------------------------------------------------------------------------------
//  read image, feed to jls_encoder_i module 
// -------------------------------------------------------------------------------------------------------------------
initial begin
    logic [256*8:1] input_file_name;
    logic [256*8:1] input_file_format;
    $sformat(input_file_format , "%s\\%s.pgm",  `INPUT_PGM_DIR, `FILE_NAME_FORMAT);
    
    while(~rstn) @ (posedge clk);

    for(file_no=0; file_no<1000; file_no++) begin
        int w, h;
        logic [7:0] img [];

        $sformat(input_file_name, input_file_format , file_no);

        if( load_img(input_file_name, img, w, h) )         // file open failed
            continue;
        
        $display("%s (%5dx%5d)", input_file_name, w, h);

        if( w < 5 || w > 16384 || h < 1 || h > 16383 )     // image size not supported
            $display("  *** image size not supported ***");
        else
            feed_img(img, w, h, `NUM_BUBBLES);
        
        img.delete();
    end
    
    repeat(100) @(posedge clk);

    $stop;
end


// -------------------------------------------------------------------------------------------------------------------
//  write output stream to .jls file 
// -------------------------------------------------------------------------------------------------------------------
logic [256*8:1] output_file_format;
initial $sformat(output_file_format, "%s\\%s.jls", `OUTPUT_JLS_DIR, `FILE_NAME_FORMAT);
logic [256*8:1] output_file_name;
int opened = 0;
int jls_file = 0;

always @ (posedge clk)
    if(o_e) begin
        // the first data of an output stream, open a new file.
        if(opened == 0) begin
            opened = 1;
            $sformat(output_file_name, output_file_format, file_no);
            jls_file = $fopen(output_file_name , "wb");
        end
        
        // write data to file.
        if(opened != 0 && jls_file != 0)
            $fwrite(jls_file, "%c%c", o_data[15:8], o_data[7:0]);
        
        // if it is the last data of an output stream, close the file.
        if(o_last) begin
            opened = 0;
            $fclose(jls_file);
        end
    end

endmodule
