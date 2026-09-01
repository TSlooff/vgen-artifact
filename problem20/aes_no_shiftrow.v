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
 
 module sbox(
    input  [7:0] In,
    output [7:0] S
    ); 
  wire [7:0] n2626_o;
  reg [7:0] n1098_data; // mem_rd
  assign S =  n1098_data;
  always @(In) begin
    case( In )
         8'h00: n1098_data = 8'h63;
  8'h01: n1098_data = 8'h7c;
  8'h02: n1098_data = 8'h77;
  8'h03: n1098_data = 8'h7b;
  8'h04: n1098_data = 8'hf2;
  8'h05: n1098_data = 8'h6b;
  8'h06: n1098_data = 8'h6f;
  8'h07: n1098_data = 8'hc5;
  8'h08: n1098_data = 8'h30;
  8'h09: n1098_data = 8'h01;
  8'h0a: n1098_data = 8'h67;
  8'h0b: n1098_data = 8'h2b;
  8'h0c: n1098_data = 8'hfe;
  8'h0d: n1098_data = 8'hd7;
  8'h0e: n1098_data = 8'hab;
  8'h0f: n1098_data = 8'h76;
  8'h10: n1098_data = 8'hca;
  8'h11: n1098_data = 8'h82;
  8'h12: n1098_data = 8'hc9;
  8'h13: n1098_data = 8'h7d;
  8'h14: n1098_data = 8'hfa;
  8'h15: n1098_data = 8'h59;
  8'h16: n1098_data = 8'h47;
  8'h17: n1098_data = 8'hf0;
  8'h18: n1098_data = 8'had;
  8'h19: n1098_data = 8'hd4;
  8'h1a: n1098_data = 8'ha2;
  8'h1b: n1098_data = 8'haf;
  8'h1c: n1098_data = 8'h9c;
  8'h1d: n1098_data = 8'ha4;
  8'h1e: n1098_data = 8'h72;
  8'h1f: n1098_data = 8'hc0;
  8'h20: n1098_data = 8'hb7;
  8'h21: n1098_data = 8'hfd;
  8'h22: n1098_data = 8'h93;
  8'h23: n1098_data = 8'h26;
  8'h24: n1098_data = 8'h36;
  8'h25: n1098_data = 8'h3f;
  8'h26: n1098_data = 8'hf7;
  8'h27: n1098_data = 8'hcc;
  8'h28: n1098_data = 8'h34;
  8'h29: n1098_data = 8'ha5;
  8'h2a: n1098_data = 8'he5;
  8'h2b: n1098_data = 8'hf1;
  8'h2c: n1098_data = 8'h71;
  8'h2d: n1098_data = 8'hd8;
  8'h2e: n1098_data = 8'h31;
  8'h2f: n1098_data = 8'h15;
  8'h30: n1098_data = 8'h04;
  8'h31: n1098_data = 8'hc7;
  8'h32: n1098_data = 8'h23;
  8'h33: n1098_data = 8'hc3;
  8'h34: n1098_data = 8'h18;
  8'h35: n1098_data = 8'h96;
  8'h36: n1098_data = 8'h05;
  8'h37: n1098_data = 8'h9a;
  8'h38: n1098_data = 8'h07;
  8'h39: n1098_data = 8'h12;
  8'h3a: n1098_data = 8'h80;
  8'h3b: n1098_data = 8'he2;
  8'h3c: n1098_data = 8'heb;
  8'h3d: n1098_data = 8'h27;
  8'h3e: n1098_data = 8'hb2;
  8'h3f: n1098_data = 8'h75;
  8'h40: n1098_data = 8'h09;
  8'h41: n1098_data = 8'h83;
  8'h42: n1098_data = 8'h2c;
  8'h43: n1098_data = 8'h1a;
  8'h44: n1098_data = 8'h1b;
  8'h45: n1098_data = 8'h6e;
  8'h46: n1098_data = 8'h5a;
  8'h47: n1098_data = 8'ha0;
  8'h48: n1098_data = 8'h52;
  8'h49: n1098_data = 8'h3b;
  8'h4a: n1098_data = 8'hd6;
  8'h4b: n1098_data = 8'hb3;
  8'h4c: n1098_data = 8'h29;
  8'h4d: n1098_data = 8'he3;
  8'h4e: n1098_data = 8'h2f;
  8'h4f: n1098_data = 8'h84;
  8'h50: n1098_data = 8'h53;
  8'h51: n1098_data = 8'hd1;
  8'h52: n1098_data = 8'h00;
  8'h53: n1098_data = 8'hed;
  8'h54: n1098_data = 8'h20;
  8'h55: n1098_data = 8'hfc;
  8'h56: n1098_data = 8'hb1;
  8'h57: n1098_data = 8'h5b;
  8'h58: n1098_data = 8'h6a;
  8'h59: n1098_data = 8'hcb;
  8'h5a: n1098_data = 8'hbe;
  8'h5b: n1098_data = 8'h39;
  8'h5c: n1098_data = 8'h4a;
  8'h5d: n1098_data = 8'h4c;
  8'h5e: n1098_data = 8'h58;
  8'h5f: n1098_data = 8'hcf;
  8'h60: n1098_data = 8'hd0;
  8'h61: n1098_data = 8'hef;
  8'h62: n1098_data = 8'haa;
  8'h63: n1098_data = 8'hfb;
  8'h64: n1098_data = 8'h43;
  8'h65: n1098_data = 8'h4d;
  8'h66: n1098_data = 8'h33;
  8'h67: n1098_data = 8'h85;
  8'h68: n1098_data = 8'h45;
  8'h69: n1098_data = 8'hf9;
  8'h6a: n1098_data = 8'h02;
  8'h6b: n1098_data = 8'h7f;
  8'h6c: n1098_data = 8'h50;
  8'h6d: n1098_data = 8'h3c;
  8'h6e: n1098_data = 8'h9f;
  8'h6f: n1098_data = 8'ha8;
  8'h70: n1098_data = 8'h51;
  8'h71: n1098_data = 8'ha3;
  8'h72: n1098_data = 8'h40;
  8'h73: n1098_data = 8'h8f;
  8'h74: n1098_data = 8'h92;
  8'h75: n1098_data = 8'h9d;
  8'h76: n1098_data = 8'h38;
  8'h77: n1098_data = 8'hf5;
  8'h78: n1098_data = 8'hbc;
  8'h79: n1098_data = 8'hb6;
  8'h7a: n1098_data = 8'hda;
  8'h7b: n1098_data = 8'h21;
  8'h7c: n1098_data = 8'h10;
  8'h7d: n1098_data = 8'hff;
  8'h7e: n1098_data = 8'hf3;
  8'h7f: n1098_data = 8'hd2;
  8'h80: n1098_data = 8'hcd;
  8'h81: n1098_data = 8'h0c;
  8'h82: n1098_data = 8'h13;
  8'h83: n1098_data = 8'hec;
  8'h84: n1098_data = 8'h5f;
  8'h85: n1098_data = 8'h97;
  8'h86: n1098_data = 8'h44;
  8'h87: n1098_data = 8'h17;
  8'h88: n1098_data = 8'hc4;
  8'h89: n1098_data = 8'ha7;
  8'h8a: n1098_data = 8'h7e;
  8'h8b: n1098_data = 8'h3d;
  8'h8c: n1098_data = 8'h64;
  8'h8d: n1098_data = 8'h5d;
  8'h8e: n1098_data = 8'h19;
  8'h8f: n1098_data = 8'h73;
  8'h90: n1098_data = 8'h60;
  8'h91: n1098_data = 8'h81;
  8'h92: n1098_data = 8'h4f;
  8'h93: n1098_data = 8'hdc;
  8'h94: n1098_data = 8'h22;
  8'h95: n1098_data = 8'h2a;
  8'h96: n1098_data = 8'h90;
  8'h97: n1098_data = 8'h88;
  8'h98: n1098_data = 8'h46;
  8'h99: n1098_data = 8'hee;
  8'h9a: n1098_data = 8'hb8;
  8'h9b: n1098_data = 8'h14;
  8'h9c: n1098_data = 8'hde;
  8'h9d: n1098_data = 8'h5e;
  8'h9e: n1098_data = 8'h0b;
  8'h9f: n1098_data = 8'hdb;
  8'ha0: n1098_data = 8'he0;
  8'ha1: n1098_data = 8'h32;
  8'ha2: n1098_data = 8'h3a;
  8'ha3: n1098_data = 8'h0a;
  8'ha4: n1098_data = 8'h49;
  8'ha5: n1098_data = 8'h06;
  8'ha6: n1098_data = 8'h24;
  8'ha7: n1098_data = 8'h5c;
  8'ha8: n1098_data = 8'hc2;
  8'ha9: n1098_data = 8'hd3;
  8'haa: n1098_data = 8'hac;
  8'hab: n1098_data = 8'h62;
  8'hac: n1098_data = 8'h91;
  8'had: n1098_data = 8'h95;
  8'hae: n1098_data = 8'he4;
  8'haf: n1098_data = 8'h79;
  8'hb0: n1098_data = 8'he7;
  8'hb1: n1098_data = 8'hc8;
  8'hb2: n1098_data = 8'h37;
  8'hb3: n1098_data = 8'h6d;
  8'hb4: n1098_data = 8'h8d;
  8'hb5: n1098_data = 8'hd5;
  8'hb6: n1098_data = 8'h4e;
  8'hb7: n1098_data = 8'ha9;
  8'hb8: n1098_data = 8'h6c;
  8'hb9: n1098_data = 8'h56;
  8'hba: n1098_data = 8'hf4;
  8'hbb: n1098_data = 8'hea;
  8'hbc: n1098_data = 8'h65;
  8'hbd: n1098_data = 8'h7a;
  8'hbe: n1098_data = 8'hae;
  8'hbf: n1098_data = 8'h08;
  8'hc0: n1098_data = 8'hba;
  8'hc1: n1098_data = 8'h78;
  8'hc2: n1098_data = 8'h25;
  8'hc3: n1098_data = 8'h2e;
  8'hc4: n1098_data = 8'h1c;
  8'hc5: n1098_data = 8'ha6;
  8'hc6: n1098_data = 8'hb4;
  8'hc7: n1098_data = 8'hc6;
  8'hc8: n1098_data = 8'he8;
  8'hc9: n1098_data = 8'hdd;
  8'hca: n1098_data = 8'h74;
  8'hcb: n1098_data = 8'h1f;
  8'hcc: n1098_data = 8'h4b;
  8'hcd: n1098_data = 8'hbd;
  8'hce: n1098_data = 8'h8b;
  8'hcf: n1098_data = 8'h8a;
  8'hd0: n1098_data = 8'h70;
  8'hd1: n1098_data = 8'h3e;
  8'hd2: n1098_data = 8'hb5;
  8'hd3: n1098_data = 8'h66;
  8'hd4: n1098_data = 8'h48;
  8'hd5: n1098_data = 8'h03;
  8'hd6: n1098_data = 8'hf6;
  8'hd7: n1098_data = 8'h0e;
  8'hd8: n1098_data = 8'h61;
  8'hd9: n1098_data = 8'h35;
  8'hda: n1098_data = 8'h57;
  8'hdb: n1098_data = 8'hb9;
  8'hdc: n1098_data = 8'h86;
  8'hdd: n1098_data = 8'hc1;
  8'hde: n1098_data = 8'h1d;
  8'hdf: n1098_data = 8'h9e;
  8'he0: n1098_data = 8'he1;
  8'he1: n1098_data = 8'hf8;
  8'he2: n1098_data = 8'h98;
  8'he3: n1098_data = 8'h11;
  8'he4: n1098_data = 8'h69;
  8'he5: n1098_data = 8'hd9;
  8'he6: n1098_data = 8'h8e;
  8'he7: n1098_data = 8'h94;
  8'he8: n1098_data = 8'h9b;
  8'he9: n1098_data = 8'h1e;
  8'hea: n1098_data = 8'h87;
  8'heb: n1098_data = 8'he9;
  8'hec: n1098_data = 8'hce;
  8'hed: n1098_data = 8'h55;
  8'hee: n1098_data = 8'h28;
  8'hef: n1098_data = 8'hdf;
  8'hf0: n1098_data = 8'h8c;
  8'hf1: n1098_data = 8'ha1;
  8'hf2: n1098_data = 8'h89;
  8'hf3: n1098_data = 8'h0d;
  8'hf4: n1098_data = 8'hbf;
  8'hf5: n1098_data = 8'he6;
  8'hf6: n1098_data = 8'h42;
  8'hf7: n1098_data = 8'h68;
  8'hf8: n1098_data = 8'h41;
  8'hf9: n1098_data = 8'h99;
  8'hfa: n1098_data = 8'h2d;
  8'hfb: n1098_data = 8'h0f;
  8'hfc: n1098_data = 8'hb0;
  8'hfd: n1098_data = 8'h54;
  8'hfe: n1098_data = 8'hbb;
  8'hff: n1098_data = 8'h16;            
    endcase
end
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
