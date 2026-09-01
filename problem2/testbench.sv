module quark_tb();
	reg clk, reset;
  reg [135:0] s;
  wire [135:0] daout;
  	// assign s = 136'd208280;
  	assign s = 136'hD8DACA44414A099719C80AA3AF0656445B;
  	// assign s = 136'b1011;
  	quark dut(.clk(clk), .reset(reset),.s(s), .daout(daout));
	initial
	begin
        $dumpfile("dump.vcd");
        $dumpvars;
      clk = 0;
      reset = 0;
      #5;
      reset = 1;
      #5;
      repeat(5000) begin
            #10;
            clk = ~clk;
        end
    end     
endmodule
// expected output 9A03A9DEFBB9ED3867DAB18EC039276212
