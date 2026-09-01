module gmul2(
    input [7:0] Inp,
    output [7:0] Oup
    );  
 
assign Oup = {Inp[6:4], Inp[3]^Inp[7],  Inp[2]^Inp[7], Inp[1], Inp[0]^Inp[7], Inp[7] };
 
endmodule 