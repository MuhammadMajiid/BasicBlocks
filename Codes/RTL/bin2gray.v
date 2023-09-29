module bin2gray
#(
    parameter WIDTH = 4
)
(
    input wire [WIDTH-1:0] bin_in,
    output wire [WIDTH-1:0] gray_out
);

// genvar i;
// generate
//     for (i=0; i<(WIDTH-1); i=i+1) begin
//         assign gray_out[i] = bin_in[i] ^ bin_in[i+1];
//     end
// endgenerate

// assign gray_out[WIDTH-1] = bin_in[WIDTH-1];

assign gray_out = (bin_in >> 1) ^ bin_in;

endmodule