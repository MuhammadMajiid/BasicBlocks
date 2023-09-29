module n_fulladdr
#(
    parameter integer SIZE = 4
)
(
    input  wire [(SIZE-1):0] in_1,
    input  wire [(SIZE-1):0] in_2,
    input  wire      carry_in,

    output wire [(SIZE-1):0] sum,
    output wire         carry_out
);
wire [SIZE:0] c_mid;

assign c_mid[0] = carry_in;
assign c_mid[SIZE] = carry_out;

genvar i;
generate
    for (i=0; i<SIZE; i=i+1) begin
        full_adder ui(
            .a(in_1[i]),
            .b(in_2[i]),
            .c(c_mid[i]),

            .sum(sum[i]),
            .carr(c_mid[i+1])
        );
    end
endgenerate

endmodule