module Slayer(
    input [127:0] Inp,
    output [127:0] Oup
    );  
 
   sbox s0 (Inp [7:0] , Oup[7:0] );
   sbox s1 (Inp [15:8] , Oup[15:8] );
   sbox s2 (Inp [23:16] , Oup[23:16] );
   sbox s3 (Inp [31:24] , Oup[31:24] );
   sbox s4 (Inp [39:32] , Oup[39:32] );
   sbox s5 (Inp [47:40] , Oup[47:40] );
   sbox s6 (Inp [55:48] , Oup[55:48] );
   sbox s7 (Inp [63:56] , Oup[63:56] );   
   
   sbox s8 (Inp [71:64] , Oup[71:64] );
   sbox s9 (Inp [79:72] , Oup[79:72] );
   sbox sa (Inp [87:80] , Oup[87:80] );
   sbox sb (Inp [95:88] , Oup[95:88] );
   sbox sc (Inp [103:96] , Oup[103:96] );
   sbox sd (Inp [111:104] , Oup[111:104] );
   sbox se (Inp [119:112] , Oup[119:112] );
   sbox sf (Inp [127:120] , Oup[127:120]);    
          
    
 endmodule  