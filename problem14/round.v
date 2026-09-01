module Round(
    input [127:0] Inp,
    input [127:0] Rkey,
    output [127:0] Oup
    ); 
    
  wire [127:0] A,B,C;
  
  assign A = Inp ^ Rkey;
  Slayer s(A,B);
  Shiftrow p(B,C);
  Mixcolumn m(C,Oup);
 endmodule