module rptr_empty
#(
    parameter WIDTH = 4
)
(
    input rclk,
    input wire rrst_n,
    input wire rinc,
    input wire  [WIDTH-1:0] rq2_wptr,

    output wire [WIDTH-2:0] raddr,
    output wire [WIDTH-1:0] rptr,
    output wire rempty
);

reg  r_empty_w; // read empty wire
wire rempty_val;

dual_ngray_cntr #(WIDTH) r_unit (
    .clk(rclk),
    .rst_n(rrst_n),
    .inc(rinc),
    .en(r_empty_w),

    .binaddr(raddr),
    .grptr(rptr)
);

// Empty flag logic
assign rempty_val = (rptr == rq2_wptr);
always @(posedge rclk, negedge rrst_n) begin
    if (!rrst_n) r_empty_w <= 1'b1;
    else         r_empty_w <= rempty_val;
end
assign rempty = r_empty_w;

endmodule