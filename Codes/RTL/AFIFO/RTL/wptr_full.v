module wptr_full 
#(
    parameter WIDTH = 4
) 
(
    input wclk,
    input wire wrst_n,
    input wire winc,
    input wire  [WIDTH-1:0] wq2_rptr,

    output wire [WIDTH-2:0] waddr,
    output wire [WIDTH-1:0] wptr,
    output wire wfull
);

reg  w_full_w; // write full  wire
wire wfull_val;

dual_ngray_cntr #(WIDTH) w_unit (
    .clk(wclk),
    .rst_n(wrst_n),
    .inc(winc),
    .en(w_full_w),

    .binaddr(waddr),
    .grptr(wptr)
);

//------------------------------------------------------------------
// Simplified version of the three necessary full-tests:
// assign wfull_val=((wgnext[ADDRSIZE] !=wq2_rptr[ADDRSIZE] ) &&
// (wgnext[ADDRSIZE-1] !=wq2_rptr[ADDRSIZE-1]) &&
// (wgnext[ADDRSIZE-2:0]==wq2_rptr[ADDRSIZE-2:0]));
//------------------------------------------------------------------

// Full flag logic
assign wfull_val = (wptr == {~wq2_rptr[WIDTH-1:WIDTH-2], wq2_rptr[WIDTH-3:0]});
always @(posedge wclk, negedge wrst_n) begin
    if (!wrst_n) w_full_w <= 1'b0;
    else         w_full_w <= wfull_val;
end
assign wfull = wfull_val;

endmodule