 module keyschedule(
    input [79:0] In,
    input [4:0] RC,
    output [79:0] Oup
    ); 
   wire [79:0] R; 
    
  rotate_61 r (In, R);  
    
  assign Oup[75:20] = R[75:20];
  assign Oup[14: 0] = R[14: 0];
  
  sbox k (R[79:76], Oup[79:76]);
  assign  Oup[19:15] = R[19:15] ^ RC;
  endmodule
