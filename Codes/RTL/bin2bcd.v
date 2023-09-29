`timescale 1ns/1ps
module bin2bcd 
(
    input              clock,
    input  wire        a_rst,
    input  wire [15:0] bin,
    input  wire        load,
    output reg  [15:0] bcd
);

reg [($clog2(16)-1):0] counter;
reg state;

always @(posedge clock, posedge a_rst) begin
    if (a_rst) begin
        bcd      = 16'd0;
        counter  = 0;
        state    = 1'b0;
    end
    else begin
        case (state)
           1'b0 : begin
                bcd      = 16'd0;
                counter  = 0;
                if (load) state    = 1'b1;
                else      state    = 1'b0;
           end
           
           1'b1 : begin
            if (counter == 16'd16) begin
                state    = 1'b0;
            end
            else begin
                if (bcd[3:0]   > 4) bcd[3:0]    = bcd[3:0]   + 3;
                if (bcd[7:4]   > 4) bcd[7:4]    = bcd[7:4]   + 3;
                if (bcd[11:8]  > 4) bcd[11:8]   = bcd[11:8]  + 3;
                if (bcd[15:12] > 4) bcd[15:12]  = bcd[15:12] + 3;
                bcd      = {bcd[14:0],bin[15-counter]};
                state    = 1'b1;
                counter  = counter + 1;
            end
           end
            default: state    = 1'b0;
        endcase
    end
end

endmodule

module tb_bin2bcd;


reg [15:0] bin;
reg clock;
reg a_rst;
reg load;
wire [15:0] bcd;

// instance
bin2bcd dut (
    .clock(clock),
    .a_rst(a_rst),
    .load(load),
    .bin(bin),
    .bcd(bcd)
);

// clock
initial begin
    clock = 1'b0;
    forever #10 clock = !clock;
end

// reset
initial begin
    a_rst = 1'b1;
    load  = 1'b0;
    #5;
    a_rst = 1'b0;
    load = 1'b1;
    #10;
    load = 1'b0;
end

// test 
initial begin
    bin = 16'h2649; // 9801 max limit
end

// monitoring
initial begin
    $monitor($time, "   bcd = %b = (%d%d%d%d)    bin = %b = (%d)", 
    bcd,bcd[15:12], bcd[11:8], bcd[7:4], bcd[3:0], bin, bin/*, bin[15:12], bin[11:8], bin[7:4], bin[3:0]*/);
end
    
endmodule