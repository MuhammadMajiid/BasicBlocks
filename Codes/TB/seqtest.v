//  AUTHOR: Mohamed Maged Elkholy.
//  INFO.: Undergraduate ECE student, Alexandria university, Egypt.
//  AUTHOR'S EMAIL: majiidd17@icloud.com
//  Digital Design with FPGA "NajahNow" Diploma.
//  FILE NAME: seqtest.v
//  TYPE: TsetBench.
//  DATE: 11/9/2022
//  KEYWORDS: Sequence detector.
//  PURPOSE: An RTL modelling for a sequence detector for 00001.

`timescale 1ns/1ps
module seqtest;

//  regs to drive the inputs
reg reset_n;
reg clock;
reg data_in;

//  wires to show the output
wire found_flag;

//  DUT
seqdec U(reset_n, clock, data_in, found_flag);

//  monitoring
initial begin
    $monitor("At ", $time, ": Sequence Flag = %b   Data In = %b",
    found_flag, data_in);
end

//  clock
initial begin
    clock = 1'b0;
    forever #100 clock = ~clock;
end

//  reset
initial begin
    reset_n = 1'b0;
    #10 reset_n = 1'b1;
end

//  test
initial begin
    data_in = 1'b0;
    #200 data_in = 1'b1;
    #200 data_in = 1'b1;
    #200 data_in = 1'b1;
    #200 data_in = 1'b0;
    #200 data_in = 1'b1;
    #200 data_in = 1'b1;
    #200 data_in = 1'b0;
    #200 data_in = 1'b0;
    #200 data_in = 1'b1;
    #200 data_in = 1'b1;
    #200 data_in = 1'b0;
    #200 data_in = 1'b1;
    #200 data_in = 1'b1;
    #200 data_in = 1'b1;
    #200 data_in = 1'b0;
    #200 data_in = 1'b1;
    #200 data_in = 1'b0;
end

//  stop
initial begin
    #3500 $stop;
end

endmodule