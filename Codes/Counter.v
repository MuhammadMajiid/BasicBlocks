//  This module is created by Mohamed Maged
//  ECE student, Alexandria University
//  An RTL for a Parameterized Up-Down Counter

module Counter
(
    parameter integer BITS = 4
)
(
    input Up, Down, ResetN, Clock, Enable

    output FullFlag, EmptyFlag,
    output [(BITS - 1):0] Count
);
//Internal
reg [(BITS - 1):0] CountReg;

localparam GoUp   = 2'b10,
           GoDown = 2'b01;

always @(negedge ResetN, posedge Clock) begin
    if(~ResetN) begin
       case({Up,Down})
           GoDown : begin
             CountReg <= {BITS{1'b1}};
           end
           GoUp : begin
             CountReg <= {BITS{1'b0}};
           end
           default : begin
             CountReg <= {BITS{1'b0}};
           end
       endcase
    end
    else begin
        if (Enable) begin
            if(Up) begin
            CountReg  <= CountReg + 1;
            end
            else if(Down) begin
                CountReg  <= CountReg - 1;
            end
            else begin
                CountReg  <= CountReg;
            end
        end
        else begin
          CountReg  <= CountReg;
        end
    end
end

//Output
assign Count = CountReg;

//Flags
assign FullFlag  = (&CountReg);     //Reduction and outputs logic 1 only when the CountReg equals ones
assign EmptyFlag = (~|CountReg);    //Reduction nor outputs logic 1 only when the CountReg equals zeros

endmodule