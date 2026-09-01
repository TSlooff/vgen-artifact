module h(input [0:67] X, input [0:67] Y, input [0:9] L, output daout);
  	assign daout = L[0] + X[1] + Y[2] + X[4] + Y[10] + X[25] + X[31] + Y[43] + X[56] + Y[59] + Y[3]*X[55] + X[46]*X[55] + X[55]*Y[59] + Y[3]*X[25]*X[46] + Y[3]*X[46]*X[55] + Y[3]*X[46]*Y[59] + L[0]*X[25]*X[46]*Y[59] + L[0]*X[25];
endmodule
