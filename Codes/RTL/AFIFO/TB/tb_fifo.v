`timescale 1ns/1ps
module tb_fifo;

parameter WIDTH      = 4;
parameter DATA_WIDTH = 8;
parameter MEM_DEPTH  = WIDTH << 1;

reg wclk_tb, rclk_tb, wrst_n_tb, rrst_n_tb, winc_tb, rinc_tb;
reg  [DATA_WIDTH-1:0] wdata_tb;
wire [DATA_WIDTH-1:0] rdata_tb;
wire wfull_tb, rempty_tb;

fifo #(.DATA_WIDTH(DATA_WIDTH), .MEM_DEPTH(MEM_DEPTH), .WIDTH(WIDTH)) dut (
    .wclk(wclk_tb),
    .rclk(rclk_tb),
    .wrst_n(wrst_n_tb),
    .rrst_n(rrst_n_tb),
    .winc(winc_tb),
    .rinc(rinc_tb),
    .wdata(wdata_tb),

    .rdata(rdata_tb),
    .wfull(wfull_tb),
    .rempty(rempty_tb)
);

// Dump
initial begin
    $dumpfile("fifo.vcd");
    $dumpvars;
end

// Monitor
initial begin
    $monitor($time, ":  Write Data = %0h,     Read Data = %0h,    Full = %0b,   Empty = %0b", wdata_tb, rdata_tb, wfull_tb, rempty_tb);
end

// Init
initial begin
    wclk_tb   = 1'b0;
    rclk_tb   = 1'b0;
    wrst_n_tb = 1'b0;
    rrst_n_tb = 1'b0;
    winc_tb   = 1'b0;
    rinc_tb   = 1'b0;
    wdata_tb  = 'h00;

    #400 $stop;
end

// Write Clock Generator 50MHz
initial begin
    forever #10 wclk_tb = !wclk_tb;
end

// Read Clock Generator 25MHz
initial begin
    forever #20 rclk_tb = !rclk_tb;
end
integer i;
// Test Vectors
initial begin
    @(negedge wclk_tb);
        wrst_n_tb = 1'b1;
        wdata_tb  = 'ha7;
    @(negedge rclk_tb);
        rrst_n_tb = 1'b1;

    // Empty corner case
    @(negedge rclk_tb);
        rinc_tb = 1'b1;     // rempty should be set
        if(rempty_tb != 1'b1) $display("empty is not working");
    @(negedge rclk_tb);
        rinc_tb = 1'b0;

    // Filling the fifo memory
    for ( i=0 ; i<MEM_DEPTH ; i=i+1 ) begin
        rinc_tb = 1'b0;
        @(negedge wclk_tb);
            wdata_tb = $random;
            winc_tb  = 1'b1;
    end

    // Full Corner case
    @(negedge wclk_tb);
        winc_tb = 1'b1;
        if(wfull_tb != 1'b1) $display("full is not working");

end

endmodule