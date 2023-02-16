//  AUTHOR: Mohamed Maged Elkholy.
//  INFO.: Undergraduate ECE student, Alexandria university, Egypt.
//  AUTHOR'S EMAIL: majiidd17@icloud.com
//  Digital Design with FPGA "NajahNow" Diploma.
//  FILE NAME: clkdiv.v
//  TYPE: module.
//  DATE: 17/9/2022
//  KEYWORDS: Integer clock divider, 50% Duty Cycle, Parametrized.
//  PURPOSE: An RTL modelling for a Parameterized Integer(Even/Odd) Clock Divider with 50% duty cycle.

module clk_div 
#(
    parameter WIDTH = 3
)
(
    input wire reset_n,
    input wire clock,
    input wire [WIDTH - 1 : 0] div_ratio,

    output wire clk_new
);
reg [WIDTH - 1 : 0] even_counter;
reg [WIDTH - 1 : 0] pos_counter;
reg [WIDTH - 1 : 0] neg_counter;
wire [WIDTH - 1 : 0] temp;
wire type;
reg even_clk;

// Intialization
assign type <= div_ratio[0];
assign temp <= div_ratio >> 1;

//  logic for even N/2 with 50% duty cycle
always @(posedge clock, negedge reset_n) begin
  if (!reset_n) begin
    even_counter <= {WIDTH{1'b0}};
    even_clk     <= 1'b0;
  end
  else begin
    if (even_counter == (temp - 1'b1)) begin
      even_clk <= ~even_clk;
      even_counter <= {WIDTH{1'b0}};
    end
    else begin
      even_counter <= even_counter + 1'b1;
    end
  end
end

//  logic for odd N at positive edge
always @(posedge clock, negedge reset_n) begin
  if (!reset_n) pos_counter <= {WIDTH{1'b0}};
  else begin
    if (pos_counter == (div_ratio - 1'b1)) begin
      pos_counter <= {WIDTH{1'b0}};
    end
    else begin
      pos_counter <= pos_counter + 1'b1;
    end
  end
end

//  logic for odd N at negative edge
always @(negedge clock, negedge reset_n) begin
  if (!reset_n) neg_counter <= {WIDTH{1'b0}};
  else begin
    if (neg_counter == (div_ratio - 1'b1)) begin
      neg_counter <= {WIDTH{1'b0}};
    end
    else begin
      neg_counter <= neg_counter + 1'b1;
    end
  end
end

//  Output logic
assign clk_new = type? ((pos_counter > (div_ratio>>1)) | (neg_counter > (div_ratio>>1))) : even_clk;

endmodule