// This test bench can be used for both Vedic 2x2 / 4x4 multiplier

`timescale 1ns/1ps
module vedic_tb;

//2x2 tb
// reg [1:0] multiplicand, multiplier;
// wire [3:0] result;
// VedicMul_2x2 dut (.multiplicand(multiplicand), .multiplier(multiplier), .result(result)); 
// reg [3:0] mulTmp;


// 4x4 tb
reg [3:0] multiplicand, multiplier;
wire [7:0] result;
VedicMul_4x4 dut (.multiplicand(multiplicand), .multiplier(multiplier), .result(result));
reg [7:0] mulTmp;

integer i;
initial begin
    for ( i=0 ; i<10 ; i=i+1 ) begin
        multiplicand = $urandom();
        multiplier = $urandom();
        mulTmp = (multiplicand * multiplier);
        #10;
        if (result != mulTmp) begin
            $display($time, "  @ iteration %d  the multiplication is wrong my output [%d] expected output [%d] ",
            i,result,mulTmp);
        end
        else begin
            $display($time, "  @ iteration %d  Nicely done! my output [%d] expected output [%d] ",
            i,result,mulTmp);
        end
    end
end

endmodule