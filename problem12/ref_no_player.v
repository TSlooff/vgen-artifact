// This module implements the Present block cipher
module present(
    input [63:0] Plaintext,
    input [79:0] Key,
    input clk,
    input reset,
    output ready,
    output [63:0] Ciphertext
    ); 
  // initialization
  reg [63:0] Sreg;
  reg [79:0] Kreg;
  wire [63:0] T;
  wire [79:0] K;
  reg readyt;
  reg [5:0] count;
  wire [5:0] count_n;
  
  Round r (Sreg, Kreg[79:16], T);
  keyschedule k (Kreg, count[4:0], K);
  
  
  always @(posedge clk) begin
    if (reset == 0) begin
      count = 1;
      Sreg = Plaintext;
      Kreg = Key;
    end
    else begin
      Sreg = T;
      Kreg = K;
      count = count_n;
     if (count == 6'h20) readyt <= 1'b1;
     else readyt <= 1'b0; 
    end
  end  
    
  assign ready =readyt;
  assign count_n = count+1;
  assign Ciphertext = Sreg ^ Kreg[79:16] ;
  
endmodule


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
 
  module Slayer(
    input [63:0] Inp,
    output [63:0] Oup
    );  
 
   sbox s0 (Inp [3:0] , Oup[3:0] );
   sbox s1 (Inp [7:4] , Oup[7:4] );
   sbox s2 (Inp [11:8] , Oup[11:8] );
   sbox s3 (Inp [15:12] , Oup[15:12] );
   sbox s4 (Inp [19:16] , Oup[19:16] );
   sbox s5 (Inp [23:20] , Oup[23:20] );
   sbox s6 (Inp [27:24] , Oup[27:24] );
   sbox s7 (Inp [31:28] , Oup[31:28] );   
   
   sbox s8 (Inp [35:32] , Oup[35:32] );
   sbox s9 (Inp [39:36] , Oup[39:36] );
   sbox sa (Inp [43:40] , Oup[43:40] );
   sbox sb (Inp [47:44] , Oup[47:44] );
   sbox sc (Inp [51:48] , Oup[51:48] );
   sbox sd (Inp [55:52] , Oup[55:52] );
   sbox se (Inp [59:56] , Oup[59:56] );
   sbox sf (Inp [63:60] , Oup[63:60] );     
          
    
 endmodule   
 
 module sbox(
    input  [3:0] In,
    output [3:0] S
    ); 
  wire [3:0] n2626_o;
  reg [3:0] n1098_data; // mem_rd
  assign S =  n1098_data;
  always @(In) begin
    case( In )
        4'b0000: n1098_data = 4'b1100;
        4'b0001: n1098_data = 4'b0101;
        4'b0010: n1098_data = 4'b0110;
        4'b0011: n1098_data = 4'b1011;
        4'b0100: n1098_data = 4'b1001;
        4'b0101: n1098_data = 4'b0000;
        4'b0110: n1098_data = 4'b1010;
        4'b0111: n1098_data = 4'b1101;    
        4'b1000: n1098_data = 4'b0011;
        4'b1001: n1098_data = 4'b1110;
        4'b1010: n1098_data = 4'b1111;
        4'b1011: n1098_data = 4'b1000;
        4'b1100: n1098_data = 4'b0100;
        4'b1101: n1098_data = 4'b0111;
        4'b1110: n1098_data = 4'b0001;
        4'b1111: n1098_data = 4'b0010;               
    endcase
end
endmodule

 
 
 
   
    
  
  module addroundkey (
    input      [63:0] idat1,
    input      [63:0] idat2,
    output     [63:0] odat);
   assign odat = idat1 ^ idat2;
 endmodule 
 
 
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
  
  
  module rotate_61(
    input [79:0] In,
    output [79:0] R
    ); 
    
    
    assign R = {In[18:0], In[79:19]};
 
endmodule
