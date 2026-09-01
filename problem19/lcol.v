module lcol(
    input [31:0] In,
    input [7:0] RC,
    output [31:0] Oup
    ); 
    
    wire [31:0] A,B ;    
    
    assign A= {In[23:0], In[31:24]};
    
    sbox ka (A[31:24],B[31:24]);
    sbox kb (A[23:16],B[23:16]);
    sbox kc (A[15:8],B[15:8]);
    sbox kd (A[7:0],B[7:0]);   
    
    assign Oup[31:24] = RC^ B[31:24];
    assign Oup[23:0] = B[23:0]; 
    
  
  
 
endmodule