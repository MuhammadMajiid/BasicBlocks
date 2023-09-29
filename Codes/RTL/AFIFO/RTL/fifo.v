module fifo 
#(
    parameter WIDTH = 4,
    parameter DATA_WIDTH = 8,
    parameter MEM_DEPTH  = 2**(WIDTH-1)
) (
    input wire wclk, rclk,
    input wire wrst_n, rrst_n,
    input wire winc, rinc,
    input wire  [DATA_WIDTH-1:0] wdata,

    output wire [DATA_WIDTH-1:0] rdata,
    output wire wfull, rempty
);

wire wfull_w;
wire [WIDTH-2:0] waddr_w, raddr_w;
wire [WIDTH-1:0] wq2_rptr_w, rq2_wptr_w, rptr_w, wptr_w;

fifomem #(.WIDTH(WIDTH), .DATA_WIDTH(DATA_WIDTH), .MEM_DEPTH(MEM_DEPTH)) unit_1 (
    .wclk(wclk),
    .winc(winc),
    .wfull(wfull_w),
    .wdata(wdata),
    .waddr(waddr_w),
    .raddr(raddr_w),

    .rdata(rdata)
);

sync #(.WIDTH(WIDTH)) to_w_unit (
    .clk(wclk),
    .rst_n(wrst_n),
    .in(rptr_w),

    .out_synced(wq2_rptr_w)
);

sync #(.WIDTH(WIDTH)) to_r_unit (
    .clk(rclk),
    .rst_n(rrst_n),
    .in(wptr_w),

    .out_synced(rq2_wptr_w)
);

wptr_full #(.WIDTH(WIDTH)) unit_2 (
    .wclk(wclk),
    .wrst_n(wrst_n),
    .winc(winc),
    .wq2_rptr(wq2_rptr_w),

    .waddr(waddr_w),
    .wptr(wptr_w),
    .wfull(wfull_w)
);

rptr_empty #(.WIDTH(WIDTH)) unit_3 (
    .rclk(rclk),
    .rrst_n(rrst_n),
    .rinc(rinc),
    .rq2_wptr(rq2_wptr_w),

    .raddr(raddr_w),
    .rptr(rptr_w),
    .rempty(rempty)
);

assign wfull = wfull_w;
    
endmodule