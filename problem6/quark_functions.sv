module h(input [0:67] X, input [0:67] Y, input [0:9] L, output daout);
  	assign daout = L[0] + X[1] + Y[2] + X[4] + Y[10] + X[25] + X[31] + Y[43] + X[56] + Y[59] + Y[3]*X[55] + X[46]*X[55] + X[55]*Y[59] + Y[3]*X[25]*X[46] + Y[3]*X[46]*X[55] + Y[3]*X[46]*Y[59] + L[0]*X[25]*X[46]*Y[59] + L[0]*X[25];
endmodule

module g(input [0:67] Y, output daout);
  	assign daout = Y[0] + Y[7] + Y[16] + Y[20] + Y[30] + Y[35] + Y[37] + Y[42] + Y[49] + Y[51] + Y[54] + Y[54]*Y[58] + Y[35]*Y[37] + Y[7]*Y[15] + Y[42]*Y[51]*Y[54] + Y[20]*Y[30]*Y[35] + Y[7]*Y[30]*Y[42]*Y[58] + Y[35]*Y[37]*Y[51]*Y[54] + Y[15]*Y[20]*Y[54]*Y[58] + Y[37]*Y[42]*Y[51]*Y[54]*Y[58] + Y[7]*Y[15]*Y[20]*Y[30]*Y[35] + Y[20]*Y[30]*Y[35]*Y[37]*Y[42]*Y[51];
endmodule

module f(input [0:67] X, output daout);
  	assign daout = X[0] + X[9] + X[14] + X[21] + X[28] + X[33] + X[37] + X[45] + X[50] + X[52] + X[55] + X[55]*X[59] + X[33]*X[37] + X[9]*X[15] + X[45]*X[52]*X[55] + X[21]*X[28]*X[33] + X[9]*X[28]*X[45]*X[59] + X[33]*X[37]*X[52]*X[55] + X[15]*X[21]*X[55]*X[59] + X[37]*X[45]*X[52]*X[55]*X[59] + X[9]*X[15]*X[21]*X[28]*X[33] + X[21]*X[28]*X[33]*X[37]*X[45]*X[52];
endmodule

module p(input [0:9] L, output daout);
  	assign daout = L[0] + L[3];
endmodule