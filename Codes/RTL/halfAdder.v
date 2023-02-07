module halfAdder (
    input wire a,
    input wire b,

    output wire sum,
    output wire carr
);

xor g0 (sum, a, b);
and g1 (carr, a, b);
    
endmodule