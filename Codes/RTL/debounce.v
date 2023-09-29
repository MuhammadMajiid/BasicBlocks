//-----------------instance name: U13-----------------\\
`timescale 1ns/1ps
module debounce 
//-----------------Parameters-----------------\\
#(
    parameter CNT_VAL = 500_000 // clk ticks to ensure signal is steady.
    // NOTE: Most switches reach a stable logic level within 10ms or 20ms of the actuation.
    // Debouncing time claculation : DT = 10ms / (1/clk) ticks
    // assumed clk 50MHz

)
//-----------------Ports-----------------\\
(
    input clk,              // clk1_50
    input  wire key_in,     // key1
    input  wire rst_n,      // key0
    output reg  key_out     // key1_stable
);

//-----------------Internal declarations-----------------\\
localparam CNT_SZ  = $clog2(CNT_VAL);
reg [CNT_SZ:0] cnt;
reg  ff_stg1, ff_stg2;
wire slow_clk;

//-----------------Freq. Divider Instnace-----------------\\
freq_divider #(50_000_000, 4) fd (
    .clk_freq1(clk),
    .rst_n_key1(rst_n),

    .freq_2(slow_clk)
);

//-----------------Debouncing logic-----------------\\
always @(posedge slow_clk) begin
    if (!rst_n) begin
        ff_stg1   <= 1'b0;
        ff_stg2   <= 1'b0;
        key_out   <= 1'b0;
    end
    else begin
        ff_stg1 <= key_in;
        ff_stg2 <= ff_stg1;
        key_out <= (ff_stg1 & (!ff_stg2));
    end
end

endmodule