`timescale 1ns / 1ps

//------------------------------------------------
module UPCOUNTER_POSEDGE # (parameter SIZE=16)
(
input wire Clock, Reset,
input wire [SIZE-1:0] Initial,
input wire Enable,
output reg [SIZE-1:0] Q
);


  always @(posedge Clock )
  begin
      if (Reset)
        Q = Initial;
      else
		begin
		if (Enable)
			Q = Q + 1;

		end
  end

endmodule
//----------------------------------------------------
module FFD_POSEDGE_SYNCRONOUS_RESET # ( parameter SIZE=8 )
(
	input wire				Clock,
	input wire				Reset,
	input wire				Enable,
	input wire [SIZE-1:0]	D,
	output reg [SIZE-1:0]	Q
);


always @ (posedge Clock)
begin
	if ( Reset )
		Q <= 0;
	else
	begin
		if (Enable)
			Q <= D;
	end

end//always

endmodule


//----------------------------------------------------------------------

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

//----------------------------------------------------------------------

module full_adder (A, B, Ci, R, Co);

input wire A, B, Ci;
output wire R, Co;

assign {Co, R} = A + B + Ci;

endmodule

//----------------------------------------------------------------------

module mux_4x1 (Shifted_A, Q, A, B);

input wire [6:0] A;
input wire [1:0] B;

output reg [5:0] Shifted_A; //revisar el tamano
output reg [7:0] Q;

always @(*) begin
	case(B)
		0: Q <= 0;
		1: Q <= A;
		2: Q <= A << 1'b1;
		3: Q <= (A << 1'b1) + A;

		default: Q <= 0;
	endcase

	Shifted_A <= A << 1'b1;
end

endmodule

//----------------------------------------------------------------------

module IMUL2 (result, A, B);
	output reg [7:0] result;
	input wire [3:0]A;
	input wire [3:0]B;

	wire [5:0] shifted_4A;
	wire [7:0] oMux1;
	wire [7:0] oMux2;

	mux_4x1 mux1(.Shifted_A(shifted_4A), .Q(oMux1), .A(A), .B(B[1:0]));
	mux_4x1 mux2(.Shifted_A(), .Q(oMux2), .A(shifted_4A), .B(B[3:2]));

	always @(*)begin
		result = oMux1 + oMux2;
	end

endmodule

// -------------------------------------------------------------------
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
