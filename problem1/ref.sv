// This module implements a 16-bit Linear Feedback Shift Register
module lfsr_16bit(
    input clk,
    input reset,
    output reg [15:0] Q
    ); 
// This module can be used for random number generation
// Inputs:
// clk: the clock
// reset: the reset
// Outputs:
// Q: the random number
  reg q_top;
always @(posedge clk)
begin
  if (reset == 1)
    begin
        Q <= 16'h1;
    end
    else
    begin
      q_top = Q[15] + Q[13] + Q[12] + Q[10] + 1;
      Q <= {Q[14:0], q_top};
    end
end
endmodule
