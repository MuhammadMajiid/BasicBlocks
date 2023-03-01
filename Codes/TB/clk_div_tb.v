//  AUTHOR: Mohamed Maged Elkholy.
//  INFO.: Undergraduate ECE student, Alexandria university, Egypt.
//  AUTHOR'S EMAIL: majiidd17@icloud.com
//  Digital Design with FPGA "NajahNow" Diploma.
//  FILE NAME: clk_div_tb.v
//  TYPE: TestBench.
//  DATE: 17/9/2022

`timescale 1ns/1ps
module clk_div_tb;
parameter WIDTH = 3;

//  regs to drive the input
reg reset_n;
reg clock;
reg [WIDTH - 1 : 0] div_ratio;

//  wires to show the output
wire clk_new;

//  design instance
clk_div #(.WIDTH(3)) DUT(
    .reset_n(reset_n),
    .clock(clock),
    .div_ratio(div_ratio),
    .clk_new(clk_new)
);

//  reset 
initial 
begin
    reset_n = 1'b0;
    #10 reset_n = 1'b1;
end

//  clock 27MHz for spartan 6 board
initial 
begin
    clock = 1'b0;
    forever #37.037 clock = ~clock;
end

/*
//  test for EVEN 50% duty cycle, width = 3 bits and the div_ratio = 4
initial
begin
    div_ratio = 'd4;
    #666.666;
end
*/

//  test for ODD 50% duty cycle, width = 3 bits and the div_ratio = 7
initial begin
    div_ratio = 'd7;
    #1555.554;
end

//  stop
initial
begin
    #2500 $stop;
end

endmodule