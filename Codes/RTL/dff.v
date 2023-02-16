//  AUTHOR: Mohamed Maged Elkholy.
//  INFO.: Undergraduate ECE student, Alexandria university, Egypt.
//  AUTHOR'S EMAIL: majiidd17@icloud.com
//  Digital Design with FPGA "NajahNow" Diploma.
//  FILE NAME: fbshifter.v
//  TYPE: module.
//  DATE: 9/9/2022
//  KEYWORDS: D-FlipFlop.
//  PURPOSE: An RTL modelling for a D-flipflop.

module  dff
#(
    parameter RSTVAL = 1'b0
)
(
    input reset_n,
    input clock,
    input d,
    output q
);
reg q_r;

always @(posedge clock, negedge reset_n) begin
    if(~reset_n)
    begin
       q_r <= RSTVAL;
    end
    else
    begin
       q_r <= d; 
    end
end

assign q = q_r;

endmodule