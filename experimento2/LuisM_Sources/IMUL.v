`include "full_adder.v"

module IMUL (oResult, A, B);
	input wire [3:0] A;
	input wire [3:0] B;
	output [7:0] oResult;
	wire Ci_00, Ci_01, Ci_02, Ci_03, Ci_10, Ci_11, Ci_12, Ci_13, Ci_20, Ci_21, Ci_22;
	wire r01, r02, r03, r11, r12, r13; 


	//r[0]
	assign oResult[0] = A[0] & B[0];

	//r[1]
	full_adder adder00 (.A(A[0] & B[1]), .B(A[1] & B[0]), 
						.Ci(1'b0), .R(oResult[1]), .Co(Ci_00)); 
	
	//r[2]
	full_adder adder01 (.A(A[2] & B[0]), .B(A[1] & B[1]), 
						.Ci(Ci_00), .R(r01), .Co(Ci_01)); 
	full_adder adder10 (.A(A[0] & B[2]), .B(r01), .Ci(1'b0),
						 .R(oResult[2]), .Co(Ci_10)); 
	
	//r[3]
	full_adder adder02 (.A(A[3] & B[0]), .B(A[2] & B[1]), 
						.Ci(Ci_01), .R(r02), .Co(Ci_02));
	full_adder adder11 (.A(A[1] & B[2]), .B(r02), .Ci(Ci_10), 
						.R(r11), .Co(Ci_11));
	full_adder adder20 (.A(A[0] & B[3]), .B(r11), .Ci(1'b0), 
						.R(oResult[3]), .Co(Ci_20));

	//r[4]
	full_adder adder03 (.A(1'b0), .B(A[3] & B[1]), .Ci(Ci_02), 
						.R(r03), .Co(Ci_03));
	full_adder adder12 (.A(A[2] & B[2]), .B(r03), .Ci(Ci_11), 
						.R(r12), .Co(Ci_12));
	full_adder adder21 (.A(A[1] & B[3]), .B(r12), .Ci(Ci_20), 
						.R(oResult[4]), .Co(Ci_21));

	//r[5]
	full_adder adder13 (.A(A[3] & B[2]), .B(Ci_03), .Ci(Ci_12), 
						.R(r13), .Co(Ci_13)); 
	full_adder adder22 (.A(A[2] & B[3]), .B(r13), .Ci(Ci_21), 
						.R(oResult[5]), .Co(Ci_22)); 

	//r[6]
	full_adder adder23 (.A(A[3] & B[3]), .B(Ci_13), .Ci(Ci_22), 
						.R(oResult[6]), .Co(oResult[7]));


endmodule