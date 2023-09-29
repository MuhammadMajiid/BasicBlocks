`timescale 1ns/1ps
module bcd2bin (
    input wire [7:0] a,
    // input wire [7:0] b,

    output wire [7:0] a_bin
    // output wire [7:0] b_bin
);

wire [3:0] a_units, b_units, a_tens, b_tens;
wire [7:0] res_a, res_b;

assign a_units = a[3:0];
assign a_tens  = a[7:4];
// assign b_units = b[3:0];
// assign b_tens  = b[7:4];

assign a_bin = (a_tens * 4'd10) + a_units;
// assign b_bin = (b_tens * 4'd10) + b_units;

// ved4x4 a0 (.multiplicand(a_tens), .multiplier(4'd10), .result(res_a));
// ved4x4 b0 (.multiplicand(b_tens), .multiplier(4'd10), .result(res_b));
// cla_adder #(8) add0 (.in_1(res_a), .in_2({4'b0000,a_units}), .carry_in(1'b0), .sum(a_bin),.carry_out());
// cla_adder #(8) add1 (.in_1(res_b), .in_2({4'b0000,b_units}), .carry_in(1'b0), .sum(b_bin),.carry_out());

endmodule

module tb_bcd2bin;


reg [7:0] a;

wire [7:0] a_bin;

// instance
bcd2bin dut (
    .a(a),
    .a_bin(a_bin)
);

// test 
initial begin
    a = 8'b0110_0011; // 63
end

// monitoring
initial begin
    $monitor($time, "   bcd = %b = (%d%d)    bin = %b = (%d)", 
    a, a[7:4], a[3:0], a_bin, a_bin);
end
    
endmodule