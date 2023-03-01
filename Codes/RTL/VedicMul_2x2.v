module VedicMul_2x2 (
    input wire [1:0] multiplicand,
    input wire [1:0] multiplier,

    output wire [3:0] result
);
wire s0, s1, c1, s2, c2;
wire a0b1, a1b0, a1b1;

assign s0   = multiplicand[0] & multiplier[0];
assign a0b1 = multiplicand[0] & multiplier[1];
assign a1b0 = multiplicand[1] & multiplier[0];
assign a1b1 = multiplicand[1] & multiplier[1];
halfAdder ha1(.a(a1b0), .b(a0b1), .sum(s1), .carr(c1));
halfAdder ha2(.a(c1), .b(a1b1), .sum(s2), .carr(c2));

assign result = {c2, s2, s1, s0};

endmodule