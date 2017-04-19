`include "full_adder.v"

module IMUL_generate2(oResult, A, B);

parameter integer NB = 32;

integer Max_Filas = (NB/2)-1;
integer Max_Col = NB - 2;
input wire [15:0] A;
input wire [15:0] B;
output [31:0] oResult;

wire wCarry[3:0][15:0];
wire wResult[3:0][15:0];



genvar i, j;
generate

assign oResult[0] = A[0] & B[0];


for(i = 0; i< 15; i = i+1) begin
	for(j = 0; i < 30; j = j+1) begin

		assign wCarry[j][ 0 ] = 0;

		if(i == 0) begin
			full_adder fa00(.A(A[1]&B[0]), .B(A[0]&B[1]), .Ci(1'b0), .R(oResult[1]), .Co(wCarry[0][0])); // A, B, Ci, R, Co
			full_adder fa01(.A(A[1]&B[1]), .B(A[2]&B[0]), .Ci(wCarry[0][0]), .R(wResult[0][1]), .Co(wCarry[0][1])); // A, B, Ci, R, Co
			full_adder fa02(.A(A[2]&B[1]), .B(A[3]&B[0]), .Ci(wCarry[0][1]), .R(wResult[0][2]), .Co(wCarry[0][2])); // A, B, Ci, R, Co
			full_adder fa03(.A(A[3]&B[1]), .B(1'b0), .Ci(wCarry[0][2]), .R(wResult[0][3]), .Co(wCarry[0][3])); // A, B, Ci, R, Co

		end

	end

end


endgenerate
endmodule
