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