module full_adder(
    input wire a,
    input wire b,
    input wire c,

    output wire sum,
    output wire carr
);
wire sum_mid;

halfAdder u1 (
    .a(a),
    .b(b),

    .sum(sum_mid),
    .carr(carr_mid_1)
);

halfAdder u2 (
    .a(sum_mid),
    .b(c),

    .sum(sum),
    .carr(carr_mid_2)
);

or u3 (carr, carr_mid_1, carr_mid_2);

endmodule