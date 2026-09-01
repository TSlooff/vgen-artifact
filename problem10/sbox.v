module sbox(
    input  [3:0] In,
    output [3:0] S
    ); 
  wire [3:0] n2626_o;
  reg [3:0] n1098_data; // mem_rd
  assign S =  n1098_data;
  always @(In) begin
    case( In )
        4'b0000: n1098_data = 4'b1100;
        4'b0001: n1098_data = 4'b0101;
        4'b0010: n1098_data = 4'b0110;
        4'b0011: n1098_data = 4'b1011;
        4'b0100: n1098_data = 4'b1001;
        4'b0101: n1098_data = 4'b0000;
        4'b0110: n1098_data = 4'b1010;
        4'b0111: n1098_data = 4'b1101;    
        4'b1000: n1098_data = 4'b0011;
        4'b1001: n1098_data = 4'b1110;
        4'b1010: n1098_data = 4'b1111;
        4'b1011: n1098_data = 4'b1000;
        4'b1100: n1098_data = 4'b0100;
        4'b1101: n1098_data = 4'b0111;
        4'b1110: n1098_data = 4'b0001;
        4'b1111: n1098_data = 4'b0010;               
    endcase
end
endmodule
