module Keyschedule(
    input [127:0] In,
    input [7:0] RC,
    output [127:0] Oup
    ); 
   wire [31:0] A,B,C,D,E; 
    
  lcol l (In[31:0],RC,A);
  assign B=A^In[127:96];
  assign C=B^In[95:64];
  assign D=C^In[63:32];    
  assign E=D^In[31:0];
  
  assign Oup={B,C,D,E};
   
  endmodule