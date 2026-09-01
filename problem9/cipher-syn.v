/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06-SP5
// Date      : Mon May 20 19:10:32 2024
/////////////////////////////////////////////////////////////


module keyschedule ( In, RC, Oup );
  input [79:0] In;
  input [4:0] RC;
  output [79:0] Oup;
  wire   In_18, In_17, In_16, In_15, n20, n21, n22, n23, n24, n25, n26, n27,
         n28, n29, n30, n31, n32, n33, n34, n35, n36;
  assign In_18 = In[18];
  assign In_17 = In[17];
  assign In_16 = In[16];
  assign In_15 = In[15];
  assign Oup[75] = In[14];
  assign Oup[74] = In[13];
  assign Oup[73] = In[12];
  assign Oup[72] = In[11];
  assign Oup[71] = In[10];
  assign Oup[70] = In[9];
  assign Oup[69] = In[8];
  assign Oup[68] = In[7];
  assign Oup[67] = In[6];
  assign Oup[66] = In[5];
  assign Oup[65] = In[4];
  assign Oup[64] = In[3];
  assign Oup[63] = In[2];
  assign Oup[62] = In[1];
  assign Oup[61] = In[0];
  assign Oup[60] = In[79];
  assign Oup[59] = In[78];
  assign Oup[58] = In[77];
  assign Oup[57] = In[76];
  assign Oup[56] = In[75];
  assign Oup[55] = In[74];
  assign Oup[54] = In[73];
  assign Oup[53] = In[72];
  assign Oup[52] = In[71];
  assign Oup[51] = In[70];
  assign Oup[50] = In[69];
  assign Oup[49] = In[68];
  assign Oup[48] = In[67];
  assign Oup[47] = In[66];
  assign Oup[46] = In[65];
  assign Oup[45] = In[64];
  assign Oup[44] = In[63];
  assign Oup[43] = In[62];
  assign Oup[42] = In[61];
  assign Oup[41] = In[60];
  assign Oup[40] = In[59];
  assign Oup[39] = In[58];
  assign Oup[38] = In[57];
  assign Oup[37] = In[56];
  assign Oup[36] = In[55];
  assign Oup[35] = In[54];
  assign Oup[34] = In[53];
  assign Oup[33] = In[52];
  assign Oup[32] = In[51];
  assign Oup[31] = In[50];
  assign Oup[30] = In[49];
  assign Oup[29] = In[48];
  assign Oup[28] = In[47];
  assign Oup[27] = In[46];
  assign Oup[26] = In[45];
  assign Oup[25] = In[44];
  assign Oup[24] = In[43];
  assign Oup[23] = In[42];
  assign Oup[22] = In[41];
  assign Oup[21] = In[40];
  assign Oup[20] = In[39];
  assign Oup[14] = In[33];
  assign Oup[13] = In[32];
  assign Oup[12] = In[31];
  assign Oup[11] = In[30];
  assign Oup[10] = In[29];
  assign Oup[9] = In[28];
  assign Oup[8] = In[27];
  assign Oup[7] = In[26];
  assign Oup[6] = In[25];
  assign Oup[5] = In[24];
  assign Oup[4] = In[23];
  assign Oup[3] = In[22];
  assign Oup[2] = In[21];
  assign Oup[1] = In[20];
  assign Oup[0] = In[19];

  OAI21_X1 U29 ( .A1(In_18), .A2(n20), .B(n21), .ZN(Oup[79]) );
  INV_X1 U30 ( .I(n22), .ZN(n21) );
  OAI21_X1 U31 ( .A1(n23), .A2(In_17), .B(n24), .ZN(n22) );
  AOI22_X1 U32 ( .A1(In_16), .A2(In_15), .B1(n20), .B2(In_18), .ZN(n23) );
  OR2_X1 U33 ( .A1(In_16), .A2(In_15), .Z(n20) );
  OAI21_X1 U34 ( .A1(n25), .A2(n26), .B(n27), .ZN(Oup[78]) );
  AOI22_X1 U35 ( .A1(n28), .A2(n29), .B1(In_15), .B2(n30), .ZN(n27) );
  OAI21_X1 U36 ( .A1(In_17), .A2(In_16), .B(n24), .ZN(n30) );
  NAND3_X1 U37 ( .A1(In_16), .A2(n25), .A3(In_17), .ZN(n24) );
  NAND2_X1 U38 ( .A1(In_18), .A2(n31), .ZN(n29) );
  OAI22_X1 U39 ( .A1(n32), .A2(n25), .B1(n33), .B2(n31), .ZN(Oup[77]) );
  AOI21_X1 U40 ( .A1(n34), .A2(n25), .B(n28), .ZN(n33) );
  NOR2_X1 U41 ( .A1(In_15), .A2(In_17), .ZN(n28) );
  INV_X1 U42 ( .I(n35), .ZN(n32) );
  OAI21_X1 U43 ( .A1(In_16), .A2(In_17), .B(n34), .ZN(n35) );
  NAND2_X1 U44 ( .A1(In_15), .A2(In_17), .ZN(n34) );
  XNOR2_X1 U45 ( .A1(n26), .A2(n36), .ZN(Oup[76]) );
  XNOR2_X1 U46 ( .A1(n25), .A2(In_15), .ZN(n36) );
  INV_X1 U47 ( .I(In_18), .ZN(n25) );
  NAND2_X1 U48 ( .A1(In_17), .A2(n31), .ZN(n26) );
  INV_X1 U49 ( .I(In_16), .ZN(n31) );
  XOR2_X1 U50 ( .A1(RC[4]), .A2(In[38]), .Z(Oup[19]) );
  XOR2_X1 U51 ( .A1(RC[3]), .A2(In[37]), .Z(Oup[18]) );
  XOR2_X1 U52 ( .A1(RC[2]), .A2(In[36]), .Z(Oup[17]) );
  XOR2_X1 U53 ( .A1(RC[1]), .A2(In[35]), .Z(Oup[16]) );
  XOR2_X1 U54 ( .A1(RC[0]), .A2(In[34]), .Z(Oup[15]) );
endmodule

