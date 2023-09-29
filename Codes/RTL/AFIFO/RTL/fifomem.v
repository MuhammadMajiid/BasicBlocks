module fifomem
#(
    parameter WIDTH      = 4,
    parameter DATA_WIDTH = 8,
    parameter MEM_DEPTH  = 2**(WIDTH-1)
)(
    input wclk,
    input wire winc,
    input wire wfull,
    input wire [DATA_WIDTH-1:0] wdata,
    input wire [WIDTH-2:0] waddr,

    output wire [WIDTH-2:0] raddr,
    output wire [DATA_WIDTH-1:0] rdata
);

wire wclk_en;    
reg [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];

always @(posedge wclk) begin
    if (wclk_en) mem[waddr] <= wdata;
end

assign wclk_en = (winc && (!wfull));
assign rdata   = mem[raddr];

endmodule