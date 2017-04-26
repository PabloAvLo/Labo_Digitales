full_adder:
	iverilog TestBench_Full_Adder.v -o Test_Full_Adder
	vvp Test_Full_Adder
	rm TestBench_Full_Adder.vcd
	rm Test_Full_Adder

IMUL_generate:
	iverilog TestBench_IMUL_gen.v -o Test_IMUL_gen
	vvp Test_IMUL_gen
	gtkwave TestBench_IMUL_gen.vcd
	rm TestBench_IMUL_gen.vcd
	rm Test_IMUL_gen
