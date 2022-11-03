//  AUTHOR: Mohamed Maged Elkholy.
//  INFO.: Undergraduate ECE student, Alexandria university, Egypt.
//  AUTHOR'S EMAIL: majiidd17@icloud.com
//  FILE NAME: Counter.v
//  TYPE: module.
//  DATE: 25/8/2022
//  KEYWORDS: Counter, Up-Down Counter, Parametrized.
//  PURPOSE: An RTL modelling for a Parameterized Up-Down Counter
`timescale 1ns/1ps
module Counter
(
  parameter integer BITS = 4
)
(
  input reset_n,
  input clock,
  input enable,
  input up,
  input down,
  output full_flag, empty_flag,
  output [(BITS - 1):0] count
);
//Internal
reg [(BITS - 1):0] count_reg;

localparam GOUP   = 2'b00,
           GODOWN = 2'b01;

always @(negedge ResetN, posedge Clock) 
begin
  if(~ResetN) begin
    case({up,down})
      GODOWN: 
      begin
        count_reg <= {BITS{1'b1}};
      end

      GOUP: 
      begin
        count_reg <= {BITS{1'b0}};
      end

      default:
      begin
        count_reg <= {BITS{1'b0}};
      end
    endcase
  end
  else begin
    if (enable) begin
      if(up) begin
      count_reg  <= count_reg + 1;
      end
      else if(Down) begin
          count_reg  <= count_reg - 1;
      end
      else begin
          count_reg  <= count_reg;
      end
    end
    else begin
      count_reg  <= count_reg;
    end
  end
end

//Output
assign count = count_reg;

//Flags
assign full_flag  = (&count_reg);
assign empty_flag = (~|count_reg);

endmodule