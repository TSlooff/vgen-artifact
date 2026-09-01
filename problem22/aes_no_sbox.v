// This module implements the AES block cipher
module aes(
    input [127:0] Plaintext,
    input [127:0] Key,
    input clk,
    input reset,
    output ready,
    output [127:0] Ciphertext
    ); 
  // initialization
  reg [127:0] Sreg;
  reg [127:0] Kreg;
  wire [127:0] T,T1;
  wire [127:0] K;
  reg readyt;
  reg [7:0] count;
  wire [7:0] count_n;
  
  Round r (Sreg, Kreg, T);
  Finalround f (Sreg, Kreg, T1);  
  keyschedule k (Kreg, count, K);
  gmul2 g (count,count_n);
  
  
  always @(posedge clk) begin
    if (reset == 0) begin
      count = 1;
      Sreg = Plaintext;
      Kreg = Key;
    end
    else begin
      if (count == 8'h36) Sreg = T1;
      else Sreg=T;
      Kreg = K;
      count = count_n;
     if (count == 8'h6C) readyt <= 1'b1;
     else readyt <= 1'b0; 
    end
  end  
    
  assign ready =readyt;
  assign Ciphertext = Sreg ^ Kreg  ;
  
endmodule


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
 
module Finalround(
    input [127:0] Inp,
    input [127:0] Rkey,
    output [127:0] Oup
    ); 
    
  wire [127:0] A,B,C;
  
  assign A = Inp ^ Rkey;
  Slayer s(A,B);
  Shiftrow p(B,Oup);
 endmodule
 
 
  module Slayer(
    input [127:0] Inp,
    output [127:0] Oup
    );  
 
   sbox s0 (Inp [7:0] , Oup[7:0] );
   sbox s1 (Inp [15:8] , Oup[15:8] );
   sbox s2 (Inp [23:16] , Oup[23:16] );
   sbox s3 (Inp [31:24] , Oup[31:24] );
   sbox s4 (Inp [39:32] , Oup[39:32] );
   sbox s5 (Inp [47:40] , Oup[47:40] );
   sbox s6 (Inp [55:48] , Oup[55:48] );
   sbox s7 (Inp [63:56] , Oup[63:56] );   
   
   sbox s8 (Inp [71:64] , Oup[71:64] );
   sbox s9 (Inp [79:72] , Oup[79:72] );
   sbox sa (Inp [87:80] , Oup[87:80] );
   sbox sb (Inp [95:88] , Oup[95:88] );
   sbox sc (Inp [103:96] , Oup[103:96] );
   sbox sd (Inp [111:104] , Oup[111:104] );
   sbox se (Inp [119:112] , Oup[119:112] );
   sbox sf (Inp [127:120] , Oup[127:120]);    
          
    
 endmodule   

 
 
 
   
 module Shiftrow(
    input [127:0] Inp,
    output [127:0] Oup
    );  
 
assign Oup[127:120] = Inp[127:120];
assign Oup[95:88] = Inp[95:88];
assign Oup[63:56] = Inp[63:56];
assign Oup[31:24] = Inp[31:24];


assign Oup[119:112] = Inp[87:80];
assign Oup[87:80] = Inp[55:48];
assign Oup[55:48] = Inp[23:16];
assign Oup[23:16] = Inp[119:112];


assign Oup[111:104] = Inp[47:40];
assign Oup[79:72] = Inp[15:8];
assign Oup[47:40] = Inp[111:104];
assign Oup[15:8] = Inp[79:72];


assign Oup[103:96] = Inp[7:0];
assign Oup[71:64] = Inp[103:96];
assign Oup[39:32] = Inp[71:64];
assign Oup[7:0] = Inp[39:32];


 
 endmodule   
  

   
 module Mixcolumn(
    input [127:0] Inp,
    output [127:0] Oup
    );  
 
wire [31:0]a,b,c,d;
wire [31:0]w,x,y,z;
wire [7:0] f02,f03,f12,f13,f22,f23,f32,f33;
wire [7:0] i02,i03,i12,i13,i22,i23,i32,i33;
wire [7:0] j02,j03,j12,j13,j22,j23,j32,j33;
wire [7:0] h02,h03,h12,h13,h22,h23,h32,h33;


assign a=Inp[127:96];
assign b=Inp[95:64];
assign c=Inp[63:32];
assign d=Inp[31:0];



gmul2 g02(a[31:24], f02);
gmul3 g03(a[31:24], f03);

gmul2 g12(a[23:16], f12);
gmul3 g13(a[23:16], f13);

gmul2 g22(a[15:8], f22);
gmul3 g23(a[15:8], f23);

gmul2 g32(a[7:0], f32);
gmul3 g33(a[7:0], f33);

assign w[31:24] =      f02 ^      f13 ^ a[15:8] ^ a[7:0]; 
assign w[23:16] = a[31:24] ^      f12 ^     f23 ^ a[7:0]; 
assign w[15: 8] = a[31:24] ^ a[23:16] ^     f22 ^    f33;
assign w[7:  0] =      f03 ^ a[23:16] ^ a[15:8] ^    f32;

 
gmul2 e02(b[31:24], h02);
gmul3 e03(b[31:24], h03);

gmul2 e12(b[23:16], h12);
gmul3 e13(b[23:16], h13);

gmul2 e22(b[15:8], h22);
gmul3 e23(b[15:8], h23);

gmul2 e32(b[7:0], h32);
gmul3 e33(b[7:0], h33);

assign x[31:24] =      h02 ^      h13 ^ b[15:8] ^ b[7:0]; 
assign x[23:16] = b[31:24] ^      h12 ^     h23 ^ b[7:0]; 
assign x[15: 8] = b[31:24] ^ b[23:16] ^     h22 ^    h33;
assign x[7:  0] =      h03 ^ b[23:16] ^ b[15:8] ^    h32;

gmul2 u02(c[31:24], i02);
gmul3 u03(c[31:24], i03);

gmul2 u12(c[23:16], i12);
gmul3 u13(c[23:16], i13);

gmul2 u22(c[15:8], i22);
gmul3 u23(c[15:8], i23);

gmul2 u32(c[7:0], i32);
gmul3 u33(c[7:0], i33);

assign y[31:24] =      i02 ^      i13 ^ c[15:8] ^ c[7:0]; 
assign y[23:16] = c[31:24] ^      i12 ^     i23 ^ c[7:0]; 
assign y[15: 8] = c[31:24] ^ c[23:16] ^     i22 ^    i33;
assign y[7:  0] =      i03 ^ c[23:16] ^ c[15:8] ^    i32;

gmul2 v02(d[31:24], j02);
gmul3 v03(d[31:24], j03);

gmul2 v12(d[23:16], j12);
gmul3 v13(d[23:16], j13);

gmul2 v22(d[15:8], j22);
gmul3 v23(d[15:8], j23);

gmul2 v32(d[7:0], j32);
gmul3 v33(d[7:0], j33);

assign z[31:24] =      j02 ^      j13 ^ d[15:8] ^ d[7:0]; 
assign z[23:16] = d[31:24] ^      j12 ^     j23 ^ d[7:0]; 
assign z[15: 8] = d[31:24] ^ d[23:16] ^     j22 ^    j33;
assign z[7:  0] =      j03 ^ d[23:16] ^ d[15:8] ^    j32;

assign Oup={w,x,y,z};
 
 endmodule   
  
   
module gmul2(
    input [7:0] Inp,
    output [7:0] Oup
    );  
 
assign Oup = {Inp[6:4], Inp[3]^Inp[7],  Inp[2]^Inp[7], Inp[1], Inp[0]^Inp[7], Inp[7] };
 
endmodule 
  
module gmul3(
    input [7:0] Inp,
    output [7:0] Oup
    );  
 wire [7:0]A;
 
 gmul2 g(Inp,A);
 assign Oup=A^Inp;

 
 endmodule  
    
 
module keyschedule(
    input [127:0] In,
    input [7:0] RC,
    output [127:0] Oup
    ); 
   wire [31:0] A,B,C,D,E; 
    
  lcol l (In[31:0],RC,A);
  assign B=A^In[127:96];
  assign C=B^In[95:64];
  assign D=C^In[63:32];    
  assign E=D^In[31:0];
  
  assign Oup={B,C,D,E};
   
  endmodule
  
  
  module lcol(
    input [31:0] In,
    input [7:0] RC,
    output [31:0] Oup
    ); 
    
    wire [31:0] A,B ;    
    
    assign A= {In[23:0], In[31:24]};
    
    sbox ka (A[31:24],B[31:24]);
    sbox kb (A[23:16],B[23:16]);
    sbox kc (A[15:8],B[15:8]);
    sbox kd (A[7:0],B[7:0]);   
    
    assign Oup[31:24] = RC^ B[31:24];
    assign Oup[23:0] = B[23:0]; 
    
  
  
 
endmodule
