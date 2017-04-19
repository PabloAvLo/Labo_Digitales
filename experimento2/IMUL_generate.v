`include "full_adder.v"

module IMUL_generate(oResult, A, B);

parameter integer NB = 32;

input wire [15:0] A;
input wire [15:0] B;
output [31:0] oResult;
	 // i    j
wire [NB-3:0][NB-6:0] wCi, wR;
wire [NB-6:0] wCo;


assign oResult[0] = A[0] & B[0];


genvar i,j;
generate

for(i = 0; i< NB-3; i = i+1) begin // begin 1

	for(j = 0; j<NB-5; j = j+1) begin // begin 2
		// Primera Fila de adders
	 		if(i == 0 && j == 0) begin // begin 3
				full_adder adder00(.A(A[i+1] & B[j]), .B(A[i-j] & B[j+1]), .Ci(1'b0), .R(oResult[i+1]), .Co(wCi[1][0]));
			end // end 3
			  else begin // begin 4
			 	if(j== 0 && (i>0 && i<3)) begin // begin 5
			 		full_adder adder012(.A(A[i+1] & B[j]), .B(A[i-j] & B[j+1]), .Ci(wCi[i-1][j]), .R(wR[i][j]), .Co(wCi[i+1][j]));
				end else begin // end 5 begin 6
					if(j == 0 && i == 3) begin // begin 7
			 			full_adder adder03(.A(A[i+1] & B[j]), .B(1'b0), .Ci(wCi[i-1][j]), .R(wR[i][j]), .Co(wCo[j]));
						// Caso especial Diagonal i = j
			 		end else begin // end 7 begin 8
						if(i == j && j>0 ) begin // begin 9
							full_adder adder04(.A(A[i-j]& B[j+1]), .B(wR[i][j-1]), .Ci(1'b0), .R(oResult[i+1]), .Co(wCi[i+1][j]));
						end else begin // end 9 begin 10
								if(i == j+3 && j>0 && j < NB-6) begin //begin 11
									full_adder adder05(.A(wCo[j-1]), .B(A[i-j]& B[j+1]), .Ci(wCi[i-1][j]), .R(wR[i][j]), .Co(wCo[j]));
								end else begin // end 11 begin 12
										if(j == NB - 6 && i == NB-3) begin // begin 13
												full_adder adder06(.A(wCo[j-1]), .B(A[i-j]& B[j+1]), .Ci(wCi[i-1][j]), .R(oResult[i+1]), .Co(oResult[i+2]));
										end else begin // end 13 begin 14
												if(j == NB - 6 && i < NB - 3 && i > NB-6) begin // begin 15
													full_adder adder07(.A(A[i-j] & B[j+1]), .B(wR[i][j-1]), .Ci(wCi[i-1][j]), .R(oResult[i+1]), .Co(wCi[i+1][j]));
													end else begin // end 15 begin 16
														if(i == j && j == NB - 6 )
															full_adder adder08(.A(A[i-j] & B[j+1]), .B(wR[i][j-1]), .Ci(1'b0), .R(oResult[i+1]), .Co(wCi[i+1][j]));
												 		else
															full_adder adder09(.A(A[i-j] & B[j+1]), .B(wR[i][j-1]), .Ci(wCi[i-1][j]), .R(wR[i][j]), .Co(wCi[i+1][j]));
													end // end 16
											  end // end 14
									    end // end 12
						           end // end 10
					          end // end 8
				         end // end 6
			        end // end 4
	           end // end 2
	      end // end 1
endgenerate
endmodule
