module dual_ngray_cntr  // style #2
#(
    parameter WIDTH = 4
)
(
    input wire clk,
    input wire rst_n,
    input wire inc,
    input wire en,      // full for write ptr module or empty for read ptr module

    output wire [WIDTH-2:0] binaddr,
    output reg  [WIDTH-1:0] grptr
);

reg  [WIDTH-1:0] bin_reg;
wire [WIDTH-1:0] bnext, gnext;
wire inc_en;

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) {grptr, bin_reg} <= {WIDTH{1'b0}};
    else        {grptr, bin_reg} <= {gnext, bnext};
end

assign inc_en = (inc && (!en));
assign bnext = bin_reg + inc_en;
assign gnext = (bnext >> 1) ^ bnext; // bin2gray
assign binaddr = bin_reg[WIDTH-2:0];

endmodule