`include "IMUL_generate.v"

module TestBench_IMUL_gen(oResult);

	reg [15:0] A = 4;
	reg [15:0] B = 5;
	output wire [31:0] oResult;
	reg clock;

	IMUL_generate mul(.oResult(oResult), .A(A), .B(B));

	always
	begin
		#5  clock =  ! clock;
	end

	initial begin

		clock = 0;
		$dumpfile("TestBench_IMUL_gen.vcd");
		$dumpvars(0,TestBench_IMUL_gen);
		$display("Probando IMUL con genvar");
		$display("A: ", A);
		$display("B: ", B);
		#100 $display("Result:", oResult);
		$finish;
	end

endmodule
