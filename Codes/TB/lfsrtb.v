//  AUTHOR: Mohamed Maged Elkholy.
//  INFO.: Undergraduate ECE student, Alexandria university, Egypt.
//  AUTHOR'S EMAIL: majiidd17@icloud.com
//  Digital Design with FPGA "NajahNow" Diploma.
//  FILE NAME: lfsrtb.v
//  TYPE: TestBench.
//  DATE: 11/9/2022
//  KEYWORDS: Shift, Rotate, Linear feedback.
//  PURPOSE: An RTL modelling for a linear feedback shift register.

`timescale 1ns/1ps
module lfsrtb;

// regs to drive inputs
reg clock;
reg reset_n;

//  wires to show the outputs
wire [3:0] data_out;
wire valid_flag;

//  design instance
lfsr DUT(clock, reset_n, data_out);

//  monitoring
initial begin
    $monitor("At ", $time, ": Data Out = %b   Valid Data = %b",
    data_out, valid_flag);
end

//  clock 10MHz
initial begin
    clock = 1'b0;
    forever #100 clock = ~clock;
end

//  reset
initial begin
    reset_n = 1'b0;
    #10 reset_n = 1'b1;
end

//  stop
initial begin
    #2200 $stop;
end

endmodule