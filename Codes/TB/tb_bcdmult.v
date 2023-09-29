`timescale 1ns/1ps
module tb_bcdmul;

reg clock;
reg a_rst;
reg load;
reg [7:0] a, b;
wire [15:0] result;

bcd_mult8 dut (.clock(clock), .a_rst(a_rst), .load(load), .a(a), .b(b), .result(result));

initial begin
    clock = 1'b0;
    forever #10 clock = !clock;   
end

initial begin
    a_rst = 1'b0;
    load  = 1'b0;
    #10;
    a_rst = !a_rst;
    #10;
    a_rst = !a_rst;
    load  = !load;
    #400;
    load  = !load;
end

initial begin
    a = 8'b0001_0010; // 12
    b = 8'b0110_0011; // 63
    //  out = 0000_0111_0101_0110 = 0756
end
    
endmodule