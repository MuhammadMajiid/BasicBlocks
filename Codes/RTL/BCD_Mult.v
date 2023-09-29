//-----------------------------------------------------------------------------\\
//----------------------------BCD Multiplier-----------------------------------\\
//-----------------------------------------------------------------------------\\

`timescale 1ns/1ps

//-----------------------------------------------------------------------------\\
//-------------------------------Half Adder------------------------------------\\
//-----------------------------------------------------------------------------\\

module half_adder (
    input wire a,
    input wire b,

    output wire sum,
    output wire carr
);

xor g0 (sum, a, b);
and g1 (carr, a, b);
    
endmodule

//-----------------------------------------------------------------------------\\
//-------------------------Carry Look Ahead Adder------------------------------\\
//-----------------------------------------------------------------------------\\

module cla_adder 
#(
    parameter integer SIZE = 4
)
(
    input  wire [(SIZE-1):0] in_1,
    input  wire [(SIZE-1):0] in_2,
    input  wire       carry_in,

    output wire [(SIZE-1):0] sum,
    output wire       carry_out
);

wire [(SIZE-1):0] p;
wire [(SIZE-1):0] g;
wire [SIZE:0] cmid;

assign p         = (in_1 ^ in_2);
assign g         = (in_1 & in_2);
assign cmid      = cla(p, g, carry_in);
assign sum       = (p ^ cmid[(SIZE-1):0]);
assign carry_out = cmid[SIZE];

function [SIZE:0] cla;
    input [(SIZE-1):0] p_arg;
    input [(SIZE-1):0] g_arg;
    input       c_arg;
    integer i;
    begin

        cla[0] = c_arg;

        for ( i=0 ; i<SIZE ; i=i+1 )
        begin
            cla[i+1] = g_arg[i] ^ (p_arg[i] & cla[i]);
        end
    end
endfunction

endmodule

//-----------------------------------------------------------------------------\\
//----------------------------Vedic Mult. 2x2----------------------------------\\
//-----------------------------------------------------------------------------\\

module ved2x2 (
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
half_adder ha1(.a(a1b0), .b(a0b1), .sum(s1), .carr(c1));
half_adder ha2(.a(c1), .b(a1b1), .sum(s2), .carr(c2));

assign result = {c2, s2, s1, s0};

endmodule

//-----------------------------------------------------------------------------\\
//----------------------------Vedic Mult. 4x4----------------------------------\\
//-----------------------------------------------------------------------------\\

module ved4x4 (
    input wire [3:0] multiplicand,
    input wire [3:0] multiplier,

    output wire [7:0] result
);
wire [3:0] ved_mid0, ved_mid1, ved_mid2, ved_mid3, mid_stage1, mid_stage2, mid_stage3;
wire ca0;
wire [7:0] final_dest;

ved2x2 u0 (.multiplicand(multiplicand[1:0]), .multiplier(multiplier[1:0]), .result(ved_mid0));
ved2x2 u1 (.multiplicand(multiplicand[1:0]), .multiplier(multiplier[3:2]), .result(ved_mid1));
ved2x2 u2 (.multiplicand(multiplicand[3:2]), .multiplier(multiplier[1:0]), .result(ved_mid2));
ved2x2 u3 (.multiplicand(multiplicand[3:2]), .multiplier(multiplier[3:2]), .result(ved_mid3));

cla_adder #(4) add0 (.in_1(ved_mid1), .in_2(ved_mid2), .carry_in(1'b0), .sum(mid_stage1), .carry_out(ca0));
cla_adder #(4) add1 (.in_1(mid_stage1), .in_2({2'b00, ved_mid0[3:2]}), .carry_in(1'b0), .sum(mid_stage2), .carry_out());
cla_adder #(4) add2 (.in_1(ved_mid3), .in_2({ca0, 1'b0, mid_stage2[3:2]}), .carry_in(1'b0), .sum(mid_stage3), .carry_out());
assign final_dest[7:0] = {mid_stage3[3:0], mid_stage2[1:0], ved_mid0[1:0]};

assign result = final_dest;

endmodule

//-----------------------------------------------------------------------------\\
//----------------------------Vedic Mult. 8x8----------------------------------\\
//-----------------------------------------------------------------------------\\

module ved8x8
(
    input wire [7:0] multiplicand,
    input wire [7:0] multiplier,

    output wire [15:0] result
);
wire [7:0] ved_mid0, ved_mid1, ved_mid2, ved_mid3;
wire [7:0] mid_stage1, mid_stage3, mid_stage4;
wire ca1;

ved4x4 u0 (.multiplicand(multiplicand[3:0]), .multiplier(multiplier[3:0]), .result(ved_mid0));
ved4x4 u1 (.multiplicand(multiplicand[7:4]), .multiplier(multiplier[3:0]), .result(ved_mid1));
ved4x4 u2 (.multiplicand(multiplicand[3:0]), .multiplier(multiplier[7:4]), .result(ved_mid2));
ved4x4 u3 (.multiplicand(multiplicand[7:4]), .multiplier(multiplier[7:4]), .result(ved_mid3));

cla_adder #(8) add1 (.in_1(ved_mid1), .in_2(ved_mid2), .carry_in(1'b0), .sum(mid_stage1), .carry_out(ca1));
cla_adder #(8) add2 (.in_1(mid_stage1), .in_2({4'b0000, ved_mid0[7:4]}), .carry_in(1'b0), .sum(mid_stage3), .carry_out());
cla_adder #(8) add3 (.in_1(ved_mid3), .in_2({4'b0000, mid_stage3[7:4]}), .carry_in(ca1), .sum(mid_stage4), .carry_out());

assign result = {mid_stage4, mid_stage3[3:0], ved_mid0[3:0]};

endmodule

//-----------------------------------------------------------------------------\\
//------------------------------BCD to Binary----------------------------------\\
//-----------------------------------------------------------------------------\\

module bcd2bin (
    input wire [7:0] a, b,

    output wire [7:0] a_bin, b_bin
);

wire [3:0] a_units, b_units, a_tens, b_tens;
wire [7:0] res_a, res_b;

assign a_units = a[3:0];
assign a_tens  = a[7:4];
assign b_units = b[3:0];
assign b_tens  = b[7:4];

// assign a_bin = (a_tens * 4'd10) + a_units;
// assign b_bin = (b_tens * 4'd10) + b_units;

ved4x4 a0 (.multiplicand(a_tens), .multiplier(4'd10), .result(res_a));
ved4x4 b0 (.multiplicand(b_tens), .multiplier(4'd10), .result(res_b));
cla_adder #(8) add0 (.in_1(res_a), .in_2({4'b0000,a_units}), .carry_in(1'b0), .sum(a_bin),.carry_out());
cla_adder #(8) add1 (.in_1(res_b), .in_2({4'b0000,b_units}), .carry_in(1'b0), .sum(b_bin),.carry_out());

endmodule

//-----------------------------------------------------------------------------\\
//-------------------------------Top Module------------------------------------\\
//-----------------------------------------------------------------------------\\

module top (
    input clock,
    input wire a_rst,
    input wire [7:0] a, b,
    input wire load,

    output wire [15:0] result
);
reg  [7:0]  a_reg, b_reg;
wire [7:0]  a_bin_w, b_bin_w;
wire [15:0] res_bin;

bcd2bin g1 (
    .a(a),
    .b(b),

    .a_bin(a_bin_w),
    .b_bin(b_bin_w)
);

always @(posedge clock, posedge a_rst) begin
    if (a_rst) begin
        a_reg    <= 8'd0;
        b_reg    <= 8'd0;
    end
    else begin
        if (load) begin
            a_reg    <= a_bin_w;
            b_reg    <= b_bin_w;
        end
    end
end

ved8x8 g2 (
    .multiplicand(a_reg),
    .multiplier(b_reg),

    .result(res_bin)
);

bin2bcd g3 (
    .clock(clock),
    .a_rst(a_rst),
    .load(load),
    .bin(res_bin),

    .bcd(result)
);

endmodule

//-----------------------------------------------------------------------------\\
//------------------------------Binary to BCD----------------------------------\\
//-----------------------------------------------------------------------------\\

module bin2bcd 
(
    input              clock,
    input  wire        a_rst,
    input  wire [15:0] bin,
    input  wire        load,
    output reg  [15:0] bcd
);

reg [($clog2(16)-1):0] counter;
reg state;

always @(posedge clock, posedge a_rst) begin
    if (a_rst) begin
        bcd      = 16'd0;
        counter  = 0;
        state    = 1'b0;
    end
    else begin
        case (state)
           1'b0 : begin
                bcd      = 16'd0;
                counter  = 0;
                if (load) state    = 1'b1;
                else      state    = 1'b0;
           end
           
           1'b1 : begin
            if (counter == 16'd16) begin
                state    = 1'b0;
            end
            else begin
                if (bcd[3:0]   > 4) bcd[3:0]    = bcd[3:0]   + 3;
                if (bcd[7:4]   > 4) bcd[7:4]    = bcd[7:4]   + 3;
                if (bcd[11:8]  > 4) bcd[11:8]   = bcd[11:8]  + 3;
                if (bcd[15:12] > 4) bcd[15:12]  = bcd[15:12] + 3;
                bcd      = {bcd[14:0],bin[15-counter]};
                state    = 1'b1;
                counter  = counter + 1;
            end
           end
            default: state    = 1'b0;
        endcase
    end
end

// integer i;
	
// always @(*) begin
//     bcd=0;		 	
//     for (i=0;i<16;i=i+1) begin
//         if (bcd[3:0]   >= 5) bcd[3:0]   = bcd[3:0]   + 3;
//         if (bcd[7:4]   >= 5) bcd[7:4]   = bcd[7:4]   + 3;
// 	    if (bcd[11:8]  >= 5) bcd[11:8]  = bcd[11:8]  + 3;
//         if (bcd[15:12] >= 5) bcd[15:12] = bcd[15:12] + 3;
//         bcd = {bcd[14:0],bin[15-i]};
//     end
// end

endmodule

//-----------------------------------------------------------------------------\\
//-------------------------------Test Bench------------------------------------\\
//-----------------------------------------------------------------------------\\

module tb_bcd_mul8x8;

reg clock;
reg a_rst;
reg [7:0] a, b;
reg load;

wire [15:0] result;

// instance
top dut (
    .clock(clock),
    .a_rst(a_rst),
    .a(a),
    .b(b),
    .load(load),
    .result(result)
);

// clock
initial begin
    clock = 1'b0;
    forever #10 clock = !clock;
end

// reset
initial begin
    a_rst = 1'b1;
    load  = 1'b0;
    #5;
    a_rst = 1'b0;
    load = 1'b1;
end

// test 
initial begin
    a = 8'b0110_0011; // 63
    b = 8'b0000_0010; // 02
end

// monitoring
initial begin
    $monitor($time, "   Result = %b = (%d%d%d%d)    a = %b = (%d%d)   b = %b = (%d%d)", 
    result,result[15:12], result[11:8], result[7:4], result[3:0], a, a[7:4], a[3:0], b, b[7:4], b[3:0]);
end
    
endmodule