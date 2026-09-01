module gmul3(
    input [7:0] Inp,
    output [7:0] Oup
    );  
 wire [7:0]A;
 
 gmul2 g(Inp,A);
 assign Oup=A^Inp;

endmodule  