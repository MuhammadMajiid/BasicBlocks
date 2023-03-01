`timescale 1ns/1ps
module CLAdder_tb ;

logic [7:0] in_1_tb;
logic [7:0] in_2_tb;
logic       carry_in_tb;

logic [7:0] sum_tb;
logic       carry_out_tb;

CLA_Adder #(8) claTest (
    .in_1(in_1_tb),
    .in_2(in_2_tb),
    .carry_in(carry_in_tb),

    .sum(sum_tb),
    .carry_out(carry_out_tb)
);

logic [7:0] sumTmp;
integer i;
initial begin
    carry_in_tb = 1'b0;
    for ( i=0 ; i<10 ; i++ ) begin
        in_1_tb = $urandom();
        in_2_tb = $urandom();
        sumTmp = (in_1_tb + in_2_tb);
        #10;
        if (sum_tb != sumTmp) begin
            $display($time, "  @ iteration %d  the addition is wrong my output [%d] expected output [%d] ",
            i,sum_tb,sumTmp);
        end
        else begin
            $display($time, "  @ iteration %d  Nicely done! my output [%d] expected output [%d] ",
            i,sum_tb,sumTmp);
        end
    end
end

endmodule