   module Player(
    input [63:0] Inp,
    output [63:0] Oup
    );  
 

 assign Oup[0] =Inp[0]; 
 assign Oup[16]=Inp[1]; 
 assign Oup[32]=Inp[2]; 
 assign Oup[48]=Inp[3]; 
 assign Oup[ 1]=Inp[4]; 
 assign Oup[17]=Inp[5]; 
 assign Oup[33]=Inp[6]; 
 assign Oup[49]=Inp[7]; 
 assign Oup[ 2]=Inp[8]; 
 assign Oup[18]=Inp[9]; 
 assign Oup[34]=Inp[10]; 
 assign Oup[50]=Inp[11]; 
 assign Oup[ 3]=Inp[12]; 
 assign Oup[19]=Inp[13]; 
 assign Oup[35]=Inp[14]; 
 assign Oup[51]=Inp[15]; 
 assign Oup[ 4]=Inp[16]; 
 assign Oup[20]=Inp[17]; 
 assign Oup[36]=Inp[18]; 
 assign Oup[52]=Inp[19]; 
 assign Oup[ 5]=Inp[20]; 
 assign Oup[21]=Inp[21]; 
 assign Oup[37]=Inp[22]; 
 assign Oup[53]=Inp[23]; 
 assign Oup[ 6]=Inp[24]; 
 assign Oup[22]=Inp[25]; 
 assign Oup[38]=Inp[26]; 
 assign Oup[54]=Inp[27]; 
 assign Oup[ 7]=Inp[28]; 
 assign Oup[23]=Inp[29]; 
 assign Oup[39]=Inp[30]; 
 assign Oup[55]=Inp[31]; 
 assign Oup[ 8]=Inp[32]; 
 assign Oup[24]=Inp[33]; 
 assign Oup[40]=Inp[34]; 
 assign Oup[56]=Inp[35]; 
 assign Oup[ 9]=Inp[36]; 
 assign Oup[25]=Inp[37]; 
 assign Oup[41]=Inp[38]; 
 assign Oup[57]=Inp[39]; 
 assign Oup[10]=Inp[40]; 
 assign Oup[26]=Inp[41]; 
 assign Oup[42]=Inp[42]; 
 assign Oup[58]=Inp[43]; 
 assign Oup[11]=Inp[44]; 
 assign Oup[27]=Inp[45]; 
 assign Oup[43]=Inp[46]; 
 assign Oup[59]=Inp[47]; 
 assign Oup[12]=Inp[48]; 
 assign Oup[28]=Inp[49]; 
 assign Oup[44]=Inp[50]; 
 assign Oup[60]=Inp[51]; 
 assign Oup[13]=Inp[52]; 
 assign Oup[29]=Inp[53]; 
 assign Oup[45]=Inp[54]; 
 assign Oup[61]=Inp[55]; 
 assign Oup[14]=Inp[56]; 
 assign Oup[30]=Inp[57]; 
 assign Oup[46]=Inp[58]; 
 assign Oup[62]=Inp[59]; 
 assign Oup[15]=Inp[60]; 
 assign Oup[31]=Inp[61]; 
 assign Oup[47]=Inp[62]; 
 assign Oup[63]=Inp[63]; 
  endmodule   
  