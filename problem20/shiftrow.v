module Shiftrow(
    input [127:0] Inp,
    output [127:0] Oup
    );  
 
assign Oup[127:120] = Inp[127:120];
assign Oup[95:88] = Inp[95:88];
assign Oup[63:56] = Inp[63:56];
assign Oup[31:24] = Inp[31:24];


assign Oup[119:112] = Inp[87:80];
assign Oup[87:80] = Inp[55:48];
assign Oup[55:48] = Inp[23:16];
assign Oup[23:16] = Inp[119:112];


assign Oup[111:104] = Inp[47:40];
assign Oup[79:72] = Inp[15:8];
assign Oup[47:40] = Inp[111:104];
assign Oup[15:8] = Inp[79:72];


assign Oup[103:96] = Inp[7:0];
assign Oup[71:64] = Inp[103:96];
assign Oup[39:32] = Inp[71:64];
assign Oup[7:0] = Inp[39:32];


 
 endmodule   