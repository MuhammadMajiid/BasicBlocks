module VedicMul_4x4 (
    input wire [3:0] multiplicand,
    input wire [3:0] multiplier,

    output wire [7:0] result
);
wire [3:0] ved_mid0, ved_mid1, ved_mid2, ved_mid3, mid_stage1, mid_stage2, mid_stage3;
wire ca0;
wire [7:0] final_dest;

VedicMul_2x2 u0 (.multiplicand(multiplicand[1:0]), .multiplier(multiplier[1:0]), .result(ved_mid0));
VedicMul_2x2 u1 (.multiplicand(multiplicand[1:0]), .multiplier(multiplier[3:2]), .result(ved_mid1));
VedicMul_2x2 u2 (.multiplicand(multiplicand[3:2]), .multiplier(multiplier[1:0]), .result(ved_mid2));
VedicMul_2x2 u3 (.multiplicand(multiplicand[3:2]), .multiplier(multiplier[3:2]), .result(ved_mid3));

CLAA #(4) add0 (.in_1(ved_mid1), .in_2(ved_mid2), .carry_in(1'b0), .sum(mid_stage1), .carry_out(ca0));
CLAA #(4) add1 (.in_1(mid_stage1), .in_2({2'b00, ved_mid0[3:2]}), .carry_in(1'b0), .sum(mid_stage2));
CLAA #(4) add2 (.in_1(ved_mid3), .in_2({ca0, 1'b0, mid_stage2[3:2]}), .carry_in(1'b0), .sum(mid_stage3));
assign final_dest[7:0] = {mid_stage3[3:0], mid_stage2[1:0], ved_mid0[1:0]};

assign result = final_dest;

endmodule