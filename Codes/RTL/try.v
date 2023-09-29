// Alarm
`timescale 1s/1s
module alarm
(
    input wire [3:0] delay, // 10 secs, freq = 1 hz t= 1/freq, delay = 10 * t = 10
    input clock,
    input reset,

    output reg beeb
);

reg [3:0] counter;

assign beeb = (counter == delay) ? 1'b1 : 1'b0 ;
// assign output = condition ? true : false;

always @(posedge clock, posedge reset) begin // negedge
    if(reset) counter = 0;
    else counter = counter + 1;

    case (cond)
        2'b00 : 
        2'b01 :
        2'b10 :
        2'b11 :  
    endcase


end

endmodule

module tb_alarm;

// drivers
reg [3:0] delay_tb;
reg reset, clock;

// output
wire beeb;

// alarm dut (delay, clock, reset, beeb);
alarm dut (.delay(delay_tb), .clock(clock), .reset(reset), .beeb(beeb));

// clock
initial begin
    clock = 0;
    forever #1 clock = !clock;
end

// resetting
initial begin
    reset = 1;
    #1;
    reset = 0;
end

// test
initial begin
    delay_tb = 10;
end

endmodule


module full
(
    input a,b,cin,
    output cout,s
);

wire d, d2, d3;

xor u1 (d, a, b);
xor u2 (s, d, cin);

and u3 (d2 , a, b);
and u4 (d3, d, cin);

or u5 (cout, d3, d2);

assign {cout, s} = a + b + cin;

// if inputs changed wait for 20ns
// y = 0 or x

endmodule