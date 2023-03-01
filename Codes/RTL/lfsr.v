//  AUTHOR: Mohamed Maged Elkholy.
//  INFO.: Undergraduate ECE student, Alexandria university, Egypt.
//  AUTHOR'S EMAIL: majiidd17@icloud.com
//  Digital Design with FPGA "NajahNow" Diploma.
//  FILE NAME: lfsr.v
//  TYPE: module.
//  DATE: 11/9/2022
//  KEYWORDS: Shift, Rotate, Linear feedback.
//  PURPOSE: An RTL modelling for a linear feedback shift register.

module lfsr (
    input clock,
    input reset_n,

    output reg [3:0] data_out,
    output reg valid_flag
);
wire data_xr;
wire [3:0] data_mid;
reg [3:0] data_shft;
reg [2:0] count;
reg state;

//  states encoding
localparam MIXUP    = 1'b0,
           SHIFTOUT = 1'b1;

//  Asynchronous Active low reset
always @(negedge reset_n) begin
    //  according to the seed
    count      <= 3'b000;
    state      <= MIXUP;
    data_shft  <= 4'b0000;
    data_out   <= 4'b0000;
    valid_flag <= 1'b0;
end

assign data_xr = data_mid[0] ^ data_mid[3];

//  D-filpflop instances with parameters according to the desired seed
dff #(.RSTVAL(1'b1)) gate0(reset_n, clock, data_xr, data_mid[0]);
dff #(.RSTVAL(1'b1)) gate1(reset_n, clock, data_mid[0], data_mid[1]);
dff #(.RSTVAL(1'b0)) gate2(reset_n, clock, data_mid[1], data_mid[2]);
dff #(.RSTVAL(1'b1)) gate3(reset_n, clock, data_mid[2], data_mid[3]);

//  output logic
always @(posedge clock) begin
    case (state)
       MIXUP : 
       begin
        if (count[2] & count[1] & (~count[0])) begin
            //  equivalent to count == 110 = 6
            count <= 3'b000;
            state <= SHIFTOUT;
        end
        else
        begin
           count <= count + 1'b1; 
        end
       end

       SHIFTOUT : 
       begin
        if (count[2] && ((~count[1]) & (~count[0]))) begin
            //  equivalent to count == 100 = 4
            count <= 3'b000;
            state <= MIXUP;
        end
        else
        begin
           data_shft[count] <= {data_shft,data_mid[3]};
           count <= count + 1'b1;
           state <= SHIFTOUT;
        end
       end

        default: begin
            count <= 3'b000;
            state <= MIXUP;
        end
    endcase
end

//  output logic
always @(*) begin
    assign valid_flag = ((count[2] & ((~count[1]) & (~count[0]))) && (state));
    //  if count == 4 and state = 1
    if(valid_flag)
    begin
        data_out = data_shft;
    end
    else
    begin
        data_out = 4'b0000;
    end
end

endmodule