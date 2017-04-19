`include "full_adder.v"

module IMUL_generate2(oResult, A, B);

parameter integer NB = 32;

integer Max_Filas = (NB/2)-1;
integer Max_Col = NB - 2;
input wire [15:0] A;
input wire [15:0] B;
output [31:0] oResult;

wire[2:0] wCarry[2:0];


genvar i, j;
generate

assign oResult[0] = A[0] & B[0];


for(i = 0; i< 15; i = i+1) begin
	for(j = 0; i < 30; j = j+1) begin
		if(i == 0) begin
			full_adder fa1(); // A, B, Ci, R, Co
		end

	end

end


endgenerate
endmodule
