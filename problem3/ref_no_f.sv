module quark(input clk, input reset, input [0:135] s, output [0:135]daout);
  // initialization
  reg [0:67] X, Y;
  reg [0:9] L;
  wire f_t;
  wire h_t;
  wire g_t;
  wire p_t;
  int counter;
  
  h hello(.X(X), .Y(Y), .L(L), .daout(h_t));
  g there(.Y(Y), .daout(g_t));
  f general(.X(X), .daout(f_t));
  p kenobi(.L(L), .daout(p_t));
  
  always @(posedge clk) begin
    if (reset == 0) begin
      counter = 0;
    end
    if (counter == 0) begin
      X = s[0:67];
      Y = s[68:135];
      L = 10'b1111111111;
      counter <= 1;
    end
    if (counter > 0 && counter < 545) begin
        X = {X[1:67], Y[0] ^ f_t ^ h_t};
        Y = {Y[1:67], g_t ^ h_t};
        L = {L[1:9], p_t};
        counter <= counter + 1;
    end
   end
  assign daout = {X,Y};
endmodule

module h(input [0:67] X, input [0:67] Y, input [0:9] L, output daout);
  	assign daout = L[0] + X[1] + Y[2] + X[4] + Y[10] + X[25] + X[31] + Y[43] + X[56] + Y[59] + Y[3]*X[55] + X[46]*X[55] + X[55]*Y[59] + Y[3]*X[25]*X[46] + Y[3]*X[46]*X[55] + Y[3]*X[46]*Y[59] + L[0]*X[25]*X[46]*Y[59] + L[0]*X[25];
endmodule

module g(input [0:67] Y, output daout);
  	assign daout = Y[0] + Y[7] + Y[16] + Y[20] + Y[30] + Y[35] + Y[37] + Y[42] + Y[49] + Y[51] + Y[54] + Y[54]*Y[58] + Y[35]*Y[37] + Y[7]*Y[15] + Y[42]*Y[51]*Y[54] + Y[20]*Y[30]*Y[35] + Y[7]*Y[30]*Y[42]*Y[58] + Y[35]*Y[37]*Y[51]*Y[54] + Y[15]*Y[20]*Y[54]*Y[58] + Y[37]*Y[42]*Y[51]*Y[54]*Y[58] + Y[7]*Y[15]*Y[20]*Y[30]*Y[35] + Y[20]*Y[30]*Y[35]*Y[37]*Y[42]*Y[51];
endmodule

module p(input [0:9] L, output daout);
  	assign daout = L[0] + L[3];
endmodule

