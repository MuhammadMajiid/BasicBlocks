//  AUTHOR: Mohamed Maged Elkholy.
//  INFO.: Undergraduate ECE student, Alexandria university, Egypt.
//  AUTHOR'S EMAIL: majiidd17@icloud.com
//  Digital Design with FPGA "NajahNow" Diploma.
//  FILE NAME: seqdec.v
//  TYPE: module.
//  DATE: 11/9/2022
//  KEYWORDS: Sequence detector.
//  PURPOSE: An RTL modelling for a sequence detector for 1101.

module seqdec (
    input reset_n,
    input clock,
    input data_in,

    output reg found_flag
);

//  Enternals
reg [2:0] state;

//  Encoding for the FSM states
localparam IDLE = 3'b000,
           ONE1 = 3'b001,
           ONE2 = 3'b011,
           ZERO = 3'b010,
           ONE3 = 3'b110;

//  Active low Asynchronous Reset logic
always @(negedge reset_n) begin
    found_flag <= 1'b0;
    state      <= IDLE;
end

//  FSM logic
always @(posedge clock) begin
    case (state)
        IDLE : 
        begin
           if(data_in)
           begin
              state = ONE1;
           end
           else
           begin
              state = IDLE;
           end
        end

        ONE1 :  //  1
        begin
            if(data_in)
            begin
                state = ONE2;
            end
            else
            begin
                state = IDLE;
            end
        end

        ONE2 :  //  11
        begin
            if(~data_in)
            begin
                state = ZERO;
            end
            else
            begin
                state = ONE2;
            end
        end

        ZERO :  //  110
        begin
            if(data_in)
            begin
                state = ONE3;
            end
            else
            begin
                state = IDLE;
            end
        end

        ONE3   :  //  1101
        begin
            if(data_in)
            begin
                state = ONE2;
            end
            else
            begin
                state = IDLE;
            end
        end

        default: begin
            state = IDLE;
        end
    endcase 
end

//  output logic
always @(*) begin
    assign found_flag = ((&state[2:1]) && (~state[0]));
    //  Equaivalent to state == 3'b110
end

endmodule