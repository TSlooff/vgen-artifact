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
      counter <= 0;
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
