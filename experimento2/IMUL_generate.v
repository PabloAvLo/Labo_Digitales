`include "full_adder.v"

module IMUL_generate(oResult, A, B);

parameter integer NB = 8;

input wire [15:0] A;
input wire [15:0] B;
output [31:0] oResult;

wire [31:0] wCarry  [31:0]; // [i] cable [j]  define un cable con elementos dados por cable[i][j]
wire [31:0] wResult [31:0]; // Col-1 Filas-1

assign oResult[0] = A[0] & B[0];

genvar i, j; // Fila, columna
generate
for(i = 0; i< 27; i = i+1) begin// Cambiar i < 27 para 32 bits o i<
	assign wCarry[i][ 0 ] = 1'b0; // Poner en cero los carry-in de la primera columna
	if(i == 26) begin // Asignar los 5 bits mas significativos de oResult
			assign oResult[i+5] = wCarry [i][4];
			assign oResult[i+4] = wResult[i][3];
			assign oResult[i+3] = wResult[i][2];
			assign oResult[i+2] = wResult[i][1];
			assign oResult[i+1] = wResult[i][0];
	end
	if (i == 0) begin // Primera Fila de Adders
		full_adder fa00(.A(A[1]&B[0]), .B(A[0]&B[1]), .Ci(wCarry[0][0]), .R(oResult[1])   , .Co(wCarry[0][1]));
		full_adder fa01(.A(A[1]&B[1]), .B(A[2]&B[0]), .Ci(wCarry[0][1]), .R(wResult[0][1]), .Co(wCarry[0][2]));
		full_adder fa02(.A(A[2]&B[1]), .B(A[3]&B[0]), .Ci(wCarry[0][2]), .R(wResult[0][2]), .Co(wCarry[0][3]));
		full_adder fa03(.A(A[3]&B[1]), .B(1'b0)     , .Ci(wCarry[0][3]), .R(wResult[0][3]), .Co(wCarry[0][4]));

	end else begin
 			for(j = 0; j < 4; j = j+1) begin
				if(j == 0) assign oResult[i+1] = wResult[i][0];
				if(j == 3)           full_adder fai3  (.A(wCarry[i-1][j+1]),.B(A[j]&B[i+1]),       .Ci(wCarry[i][j]), .R(wResult[i][j]), .Co(wCarry[i][j+1]));// Adders de la ultima columna
					else   if(i < 15)full_adder faij  (.A(A[j]&B[i+1])     ,.B(wResult[i-1][j+1]), .Ci(wCarry[i][j]), .R(wResult[i][j]), .Co(wCarry[i][j+1])); // Adders de en medio
							else     full_adder faij2 (.A(1'b0)            ,.B(wResult[i-1][j+1]), .Ci(wCarry[i][j]), .R(wResult[i][j]), .Co(wCarry[i][j+1])); // Adders de en medio
			end // end for j
	end // end else i == 0
end // end for i
endgenerate
endmodule
