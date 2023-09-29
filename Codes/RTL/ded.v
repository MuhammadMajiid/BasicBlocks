// Dual-Edge Detector
// both implementations are general edge detectors, outputs logic-1 @rising/falling edges

`timescale 1ns/1ps
// `define fsm

module ded(out, in, clk, rst_n); // Dual-Edge Detector

input clk;
input wire in, rst_n;
output out;

`ifdef fsm

// This implementation uses FSM methodology

reg out;
reg [2:0] state;

localparam st0 = 3'b000,
st1 = 3'b001,
st2 = 3'b011,
st3 = 3'b010,
st4 = 3'b110;

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        out    <= 1'b0;
        state  <= st0;
    end
    else begin
        out <= 1'b0;
        case (state)
           st0 : begin 
                if (in) state <= st1;
                else    state <= st2;
           end
           st1 : begin
                if (in) state <= st1;
                else    state <= st3;
           end
           st2 : begin
                if (in) state <= st4;
                else    state <= st2;
           end
           st3 : begin
                out <= 1'b1;
                if (in) state <= st4;
                else    state <= st2;
           end
           st4 : begin
                out <= 1'b1;
                if (in) state <= st1;
                else    state <= st3;
           end
            default: state  <= st0;
        endcase
    end
end

`else

// This implementation is more optimized

reg cell0, cell1;

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        cell0  <= 1'b0;
        cell1  <= 1'b0;
    end
    else begin
        cell0 <= in;
        cell1 <= cell0;
    end
end

assign out = cell0 ^ cell1;

`endif


endmodule //Dual-Edge Detector 

// module tb_ded;

// wire out;
// reg in, clk, rst_n;

// ded dedtb(out, in, clk, rst_n);

// initial begin
//     clk = 1'b0;
//     in = 1'b0;
//     rst_n = 1'b1;
// end

// initial begin
//     forever #10 clk = ~clk;
// end

// integer i;
// initial begin
//     #10;
//     rst_n = 1'b0;
//     #10;
//     rst_n = 1'b1;
//     for (i=0; i<20; i=i+1) begin
//         in = {$random};
//         #20;
//     end
// end
    
// endmodule