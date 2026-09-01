// This module implements the Present block cipher
module present(
    input [63:0] Plaintext,
    input [79:0] Key,
    input clk,
    input reset,
    output ready,
    output [63:0] Ciphertext
    ); 
  // initialization
  reg [63:0] Sreg;
  reg [79:0] Kreg;
  wire [63:0] T;
  wire [79:0] K;
  reg readyt;
  reg [5:0] count;
  wire [5:0] count_n;
  
  Round r (Sreg, Kreg[79:16], T);
  keyschedule k (Kreg, count[4:0], K);
  
  
  always @(posedge clk) begin
    if (reset == 0) begin
      count = 1;
      Sreg = Plaintext;
      Kreg = Key;
    end
    else begin
      Sreg = T;
      Kreg = K;
      count = count_n;
     if (count == 6'h20) readyt <= 1'b1;
     else readyt <= 1'b0; 
    end
  end  
    
  assign ready =readyt;
  assign count_n = count+1;
  assign Ciphertext = Sreg ^ Kreg[79:16] ;
  
endmodule
