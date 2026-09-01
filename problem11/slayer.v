  module Slayer(
    input [63:0] Inp,
    output [63:0] Oup
    );  
 
   sbox s0 (Inp [3:0] , Oup[3:0] );
   sbox s1 (Inp [7:4] , Oup[7:4] );
   sbox s2 (Inp [11:8] , Oup[11:8] );
   sbox s3 (Inp [15:12] , Oup[15:12] );
   sbox s4 (Inp [19:16] , Oup[19:16] );
   sbox s5 (Inp [23:20] , Oup[23:20] );
   sbox s6 (Inp [27:24] , Oup[27:24] );
   sbox s7 (Inp [31:28] , Oup[31:28] );   
   
   sbox s8 (Inp [35:32] , Oup[35:32] );
   sbox s9 (Inp [39:36] , Oup[39:36] );
   sbox sa (Inp [43:40] , Oup[43:40] );
   sbox sb (Inp [47:44] , Oup[47:44] );
   sbox sc (Inp [51:48] , Oup[51:48] );
   sbox sd (Inp [55:52] , Oup[55:52] );
   sbox se (Inp [59:56] , Oup[59:56] );
   sbox sf (Inp [63:60] , Oup[63:60] );     
          
    
 endmodule   
 