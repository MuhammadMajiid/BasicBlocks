`timescale 1ns/1ps
module DebouncePB
//-------------Parameter--------------\\
#(
    parameter CNT_VAL = 500_000; // clk ticks to ensure signal is steady.
    // NOTE: Most switches reach a stable logic level within 10ms of the actuation.
)
//-------------Ports--------------\\
(
    input  logic push_btn,
    input  logic clk,
    input  logic arst_n,
    output logic pb_stbl
);
//-------------Internals--------------\\
localparam CNT_SZ  = $clog2(CNT_VAL);
logic [CNT_SZ:0] cnt;
logic cnt_clr, cnt_full;
logic ff_stg1, ff_stg2;

//-------------Flags--------------\\
assign cnt_clr  = ff_stg1 ^ ff_stg2;
assign cnt_full = cnt[CNT_SZ];

//-------------Stablizing logic--------------\\
always_ff @(posedge clk, negedge arst_n) begin
    if (!arst_n) begin
        ff_stg1   <= 1'b0;
        ff_stg2   <= 1'b0;
        pb_stbl   <= 1'b0;
    end
    else begin
        ff_stg1 <= push_btn;
        ff_stg2 <= ff_stg1;
        if (cnt_full) pb_stbl <= ff_stg2;
    end
end

//-------------Counter logic--------------\\
always_ff @(posedge clk, negedge arst_n) begin
    if (!arst_n || cnt_clr || cnt_full) cnt   <= '{1'b0};
    else                                cnt   <= cnt + 1'b1;
end

endmodule