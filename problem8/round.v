module Round(
    input [63:0] Inp,
    input [63:0] Rkey,
    output [63:0] Oup
    ); 
    
  wire [63:0] A,B;
  
  assign A = Inp ^ Rkey;
  Slayer s(A,B);
  Player p(B,Oup);
 endmodule
 