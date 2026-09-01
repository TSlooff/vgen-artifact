  module rotate_61(
    input [79:0] In,
    output [79:0] R
    ); 
    
    
    assign R = {In[18:0], In[79:19]};
 
endmodule
