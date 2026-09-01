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
always @(posedge clk or posedge reset)
begin
  if (reset)
    begin
        Q <= 16'h1;
    end
    else
    begin
      Q <= {Q[14:0], Q[15] ^ Q[13] ^ Q[12] ^ Q[10] ^ 1'b1};
    end
end
endmodule
