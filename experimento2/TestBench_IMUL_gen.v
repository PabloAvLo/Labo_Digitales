`include "IMUL_generate2.v"

module TestBench_IMUL_gen(oResult);

	reg [15:0] A = 4;
	reg [15:0] B = 5;
	output wire [31:0] oResult;
	reg clock;

	IMUL_generate2 mul(.oResult(oResult), .A(A), .B(B));

	always
	begin
		#5  clock =  ! clock;
	end

	initial begin

		clock = 0;
		// #100; // Poner tiempo para que se estabilice el simulador y le permita calcular el resultado
		$dumpfile("TestBench_IMUL_gen.vcd");
		$dumpvars(0,TestBench_IMUL_gen);
		$display("Probando IMUL con genvar");
		$display("A: ", A);
		$display("B: ", B);
		$display("Result:", oResult);
		#100 $finish;
	end

endmodule
