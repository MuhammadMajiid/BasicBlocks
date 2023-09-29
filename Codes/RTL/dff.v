module  dff
#(
    parameter RSTVAL = 1'b0
)
(
    input reset_n,
    input clock,
    input d,
    output q
);
reg q_r;

always @(posedge clock, negedge reset_n) begin
    if(~reset_n)
    begin
       q_r <= RSTVAL;
    end
    else
    begin
       q_r <= d; 
    end
end

assign q = q_r;

endmodule