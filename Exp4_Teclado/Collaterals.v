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
module mux_4x1 #(parameter SIZE = 16) (Shifted_A, Q, A, B);

input wire [SIZE - 1:0] A; //input wire [15:0] A; 
input wire [1:0] B;

output reg [SIZE+1:0] Shifted_A; //output reg [17:0] Shifted_A; 
output reg [SIZE+1:0] Q; // Q y Shifted_A necesitan 1 bit mas que A por la suma y el desplazamiento respectivamente. 

always @(*) begin
	case(B)
		0: Q <= 0; 						// A *0
		1: Q <= A; 						// A *1
		2: Q <= A << 1'b1;			// A *2
		3: Q <= (A << 1'b1) + A;	// A *3

		default: Q <= 0;				// A *0
	endcase

	Shifted_A <= A << 2'b10;	// Desplazamiento adicional para adecuar la entrada 
end										// al siguiente mux_4x1 segun el algoritmo.

endmodule

//----------------------------------------------------------------------

module IMUL2 (result, A, B);
	output reg [31:0] result; // Resultado de 32bits ya que se multiplican 2 numeros de 16bits.
	input wire [15:0] A;
	input wire [15:0] B;

	wire [17:0] shifted_17A; // Los tamanos van aumentando debido a que A se desplaza 2 veces
	wire [19:0] shifted_19A; // hacia la izquierda por cada etapa de mux.
	wire [21:0] shifted_21A;
	wire [23:0] shifted_23A;
	wire [25:0] shifted_25A;
	wire [27:0] shifted_27A;
	wire [29:0] shifted_29A;

	wire [17:0] oMux1;
	wire [19:0] oMux2;
	wire [21:0] oMux3;
	wire [23:0] oMux4;
	wire [25:0] oMux5;
	wire [27:0] oMux6;
	wire [29:0] oMux7;
	wire [31:0] oMux8;

	mux_4x1 # (16) mux1(.Shifted_A(shifted_17A), .Q(oMux1), .A(A), .B(B[1:0]));
	mux_4x1 # (18) mux2(.Shifted_A(shifted_19A), .Q(oMux2), .A(shifted_17A), .B(B[3:2]));
	mux_4x1 # (20) mux3(.Shifted_A(shifted_21A), .Q(oMux3), .A(shifted_19A), .B(B[5:4]));
	mux_4x1 # (22) mux4(.Shifted_A(shifted_23A), .Q(oMux4), .A(shifted_21A), .B(B[7:6]));
	mux_4x1 # (24) mux5(.Shifted_A(shifted_25A), .Q(oMux5), .A(shifted_23A), .B(B[9:8]));
	mux_4x1 # (26) mux6(.Shifted_A(shifted_27A), .Q(oMux6), .A(shifted_25A), .B(B[11:10]));
	mux_4x1 # (28) mux7(.Shifted_A(shifted_29A), .Q(oMux7), .A(shifted_27A), .B(B[13:12]));
	mux_4x1 # (30) mux8(.Q(oMux8), .A(shifted_29A), .B(B[15:14]));

	// Se suman los resultados de todos los muxes segun el algoritmo.	
	always @(*)begin 
		result = oMux1 + oMux2 + oMux3 + oMux4 + oMux5 + oMux6 + oMux7 + oMux8;
	end

endmodule

//----------------------------------------------------------------------
/*
module teclado (DATA, CLOCK, /*Clk,Reset, tecla);
	
	input wire DATA, CLOCK, /*Clk, Reset;
	output reg [7:0] tecla;
	reg [31:0] timeCounter;
	reg [10:0] rBits;
	reg [3:0] nextState, currentState;
	reg timeCounterReset;
	reg [4:0] contadorBit;
	
	//Clock
	always @ ( negedge CLOCK  or posedge Reset) begin
		if (Reset) begin
			contadorBit<=0;
			tecla <= 0;
			rBits <= 0;
		end
		else begin
			if(contadorBit<=9) begin
			contadorBit <= contadorBit + 1;
			rBits[contadorBit] <= DATA;
			tecla <=0;
			end
			else begin
				contadorBit <=  4'b0;
				tecla <= rBits[9:1];
			end
		end
	end
endmodule
*/

//----------------------------------------------------------------------
// Módulo PS2 controller
module PS2_Controller 
(
	input wire Reset,
	input wire PS2_CLK,
	input wire PS2_DATA,
	output reg [7:0] XRedCounter,
	output reg [7:0] YRedCounter,
	output reg [2:0] ColorReg
);

`include "Defintions.v"

reg [7:0] ScanCode;
reg [8:0] rDataBuffer;
reg Done, Read;
reg [3:0] ClockCounter;
reg rFlagF0, rFlagNoError;

always @ (negedge PS2_CLK or posedge Reset) begin
	if (Reset) begin
		ClockCounter <= 0;
		Read <= 1;
		Done <= 0;
		end
	else begin
		if (Read == 1'b1 && PS2_DATA == 1'b0) begin
			Read <= 0;
			Done <= 0;
			end
		else if (Read == 1'b0) begin
			if (ClockCounter < 9) begin
				ClockCounter <= ClockCounter + 1;
				rDataBuffer <= {PS2_DATA, rDataBuffer[8:1]};
				Done <= 0;
				end
			else begin
				ClockCounter <= 1'b0;
				Done <= 1;
				ScanCode <= rDataBuffer[7:0];
				Read <= 1;
				if (^ScanCode == rDataBuffer[8])
					rFlagNoError <= 1'b0;
				else 
					rFlagNoError <= 1'b1;
				end
			
		end
	end
end

always @ (posedge Done or posedge Reset) begin
	if (Reset) begin
		XRedCounter <= 8'b0;
		YRedCounter <= 8'b0;
		rFlagF0 <= 1'b0;
		ColorReg <= 3'b1;
		end
	else begin
		if (rFlagF0) begin
			rFlagF0 <= 1'b0;
		end
		else
		case (ScanCode)
			`W: begin
				YRedCounter <= YRedCounter - 8'd32;
				XRedCounter <= XRedCounter;
				rFlagF0 <= rFlagF0;
				ColorReg <= ColorReg;
			end
			
			`S: begin
				YRedCounter <= YRedCounter + 8'd32;
				XRedCounter <= XRedCounter;	
				rFlagF0 <= rFlagF0;
				ColorReg <= ColorReg;
			end
			
			`A: begin
				YRedCounter <= YRedCounter;
				XRedCounter <= XRedCounter - 8'd32;	
				rFlagF0 <= rFlagF0;
				ColorReg <= ColorReg;
			end
			
			`D: begin
				YRedCounter <= YRedCounter;
				XRedCounter <= XRedCounter + 8'd32;
				rFlagF0 <= rFlagF0;
				ColorReg <= ColorReg;
			end
			
			8'hF0: begin	//Señal de finalizacion del PS2
				YRedCounter <= YRedCounter;
				XRedCounter <= XRedCounter;				
				rFlagF0 <= 1'b1;
				ColorReg <= ColorReg;
			end
			
			8'h29: begin	//29 = Barra Espaciadora
				ColorReg <= ColorReg + 3'b1;
				YRedCounter <= YRedCounter;
				XRedCounter <= XRedCounter;				
				rFlagF0 <= rFlagF0;
			end
			
			default: begin
				YRedCounter <= YRedCounter;
				XRedCounter <= XRedCounter;
				rFlagF0 <= rFlagF0;
				ColorReg <= ColorReg;
			end
		endcase
	end
end

endmodule 

