// lfsr testbench which generates waveform
module lfsr_16bit_tb();
reg clk, reset;
wire [15:0] Q;
lfsr_16bit dut(.clk(clk), .reset(reset),.Q(Q));
initial
begin
    $dumpfile("dump.vcd");
  	$dumpvars(1);
  	reset=1;
    clk=0;
  	#10;
    clk=1;
    #10;
  	reset=0;
    repeat(131070) begin
    	clk = ~clk;
        #10;
  	end
end     
endmodule
