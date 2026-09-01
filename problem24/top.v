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