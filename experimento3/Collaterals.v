`timescale 1ns / 1ps
//`include "Module_LCD_Control.v"

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
//Implementacion del modulo IMUL basandonos en un array multiplier
module IMUL (oResult, A, B);
	input wire [3:0] A;
	input wire [3:0] B;
	output [7:0] oResult; //la salida no puede ser mayor a 8 bits ya que las entradas son de 4

	//cables para los acarreos 
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
//Esta es la implementacion de un sumador completo
//va a ser de suma importancia para la implementacion de las operaciones IMUL
//y la operacion subsecuente utilizando genvar
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

module Module_LCD_Control (Clock, Reset, LCD_E, LCD_RS, 
							LCD_RW, SF_DATA);

input wire Clock;
input wire Reset;
output reg LCD_E;
output reg LCD_RS; //0=Command, 1=Data
//output reg oLCD_StrataFlashControl;
output reg LCD_RW;
reg [7:0]CMD; 
output reg[3:0] SF_DATA;

reg [7:0] rCurrentState, rNextState;
reg [7:0] rCurrentStateWrite, rNextStateWrite;
reg [7:0] rCurrentStateTM, rNextStateTM;
reg [31:0] rTimeCount;
reg rTimeCountReset;
reg wWriteDone;
reg initDone;
reg txInit;


//----------------------------------------------
//Next State and delay logic
always @ ( posedge Clock ) begin
	if (Reset) begin
		rCurrentState <= `IDLE;
		rTimeCount <= 32'b0; 
	end
	else begin
		if (rTimeCountReset) begin
			rTimeCountReset <= 1'b0;
			rTimeCount <= 32'b0;
		end else
			rTimeCount <= rTimeCount + 32'b1;
	rCurrentState <= rNextState; 
	end
end

//----------------------------------------------
//Current state and output logic
always @ (*) begin
	case(rCurrentState)
	//------------------------------------------
	//Init State Machine
	//------------------------------------------
	`IDLE:
	begin
		LCD_E = 1'b0;
		LCD_RW = 1'b0;
		LCD_RS = 1'b0;
		SF_DATA = 4'b0;
		initDone = 1'b0;
		if (~Reset) begin
			rTimeCountReset = 1'b1;
			rNextState = `FIFTEENMS; 
		end else
			rNextState = `IDLE;
	end	
	//------------------------------------------
	`FIFTEENMS:
	begin
		LCD_E = 1'b1;
		LCD_RW = 1'b0;
		LCD_RS = 1'b0;
		SF_DATA = 4'b0;
		initDone = 1'b0;
		if (rTimeCount < 800000)
			rNextState = `FIFTEENMS;
		else begin
			rTimeCountReset = 1'b1;
			rNextState = `ONE;
	end end
	//------------------------------------------
	`ONE:
	begin
		LCD_E = 1;
		LCD_RW = 1'b0;
		LCD_RS = 1'b0;
		SF_DATA = 4'b0011;
		initDone = 1'b0;
		if (rTimeCount < 20)
			rNextState = `ONE;
		else begin
			rTimeCountReset = 1'b1;
			rNextState = `TWO;
		end
	end
	//------------------------------------------
	`TWO:
	begin
		LCD_E = 0;
		LCD_RW = 1'b0;
		LCD_RS = 1'b0;
		SF_DATA = 4'b0011;
		initDone = 1'b0;
		if (rTimeCount < 230000)
			rNextState = `TWO;
		else begin
			rTimeCountReset = 1'b1;
			rNextState = `THREE;
		end
	end
	//------------------------------------------
	`THREE:
	begin
		LCD_E = 1'b1;
		LCD_RW = 1'b0;
		LCD_RS = 1'b0;
		SF_DATA = 4'b0011;
		initDone = 1'b0;
		if (rTimeCount < 20)
			rNextState = `THREE;
		else begin
			rTimeCountReset = 1'b1;
			rNextState = `FOUR;
		end	
	end
	//------------------------------------------
	`FOUR:
	begin
		LCD_E = 1'b0;
		LCD_RW = 1'b0;
		LCD_RS = 1'b0;
		SF_DATA = 4'b0011;
		initDone = 1'b0;
		if (rTimeCount < 5500)
			rNextState = `FOUR;
		else begin
			rTimeCountReset = 1'b1;
			rNextState = `FIVE;
		end		
	end
	//------------------------------------------
	`FIVE:
	begin
		LCD_E = 1'b1;
		LCD_RW = 1'b0;
		LCD_RS = 1'b0;
		SF_DATA = 4'b0011;
		initDone = 1'b0;
		if (rTimeCount < 20)
			rNextState = `FIVE;
		else begin
			rTimeCountReset = 1'b1;
			rNextState = `SIX;
		end	
	end
	//------------------------------------------
	`SIX:
	begin
		LCD_E = 1'b0;
		LCD_RW = 1'b0;
		LCD_RS = 1'b0;
		SF_DATA = 4'b0011;
		initDone = 1'b0;
		if (rTimeCount < 2200)
			rNextState = `SIX;
		else begin
			rTimeCountReset = 1'b1;
			rNextState = `SEVEN;
		end		
	end
	//------------------------------------------
	`SEVEN:
	begin
		LCD_E = 1'b1;
		LCD_RW = 1'b0;
		LCD_RS = 1'b0;
		SF_DATA = 4'b0010;
		initDone = 1'b0;
		if (rTimeCount < 20)
			rNextState = `SEVEN;
		else begin
			rTimeCountReset = 1'b1;
			rNextState = `EIGHT;
		end	
	end
	//------------------------------------------
	`EIGHT:
	begin
		LCD_E = 1'b0;
		LCD_RW = 1'b0;
		LCD_RS = 1'b0;
		SF_DATA = 4'b0010;
		initDone = 1'b0;
		if (rTimeCount < 2200)
			rNextState = `EIGHT;
		else begin
			rTimeCountReset = 1'b1;
			rNextState = `DONE;
		end
	end
	//------------------------------------------
	`DONE:
	begin
		LCD_E = 1'b0;
		LCD_RW = 1'b0;
		LCD_RS = 1'b0;
		SF_DATA = 4'b0010;
		initDone = 1'b1;
		rNextState = `DONE;
	end
	//------------------------------------------
	default:
	begin 
		LCD_E = 1'b0;
		LCD_RW = 1'b0;
		LCD_RS = 1'b0;
		SF_DATA = 4'b0;
		initDone = 1'b0;
		if (~Reset) begin
			rTimeCountReset = 1'b1;
			rNextState = `FIFTEENMS; 
		end else
			rNextState = `IDLE;
	end
	endcase
//------------MAIN SM------------------
	case(rCurrentStateWrite)
//------------------------------------------
	`INIT_FINISH_LCD:
	begin 
		LCD_E = 1'b1;
		LCD_RW = 1'b0;
		LCD_RS = 1'b0;
		SF_DATA = 4'b0000;
		CMD = 2'h28;
		txInit = 1'b0;
		if (initDone)
			rNextStateWrite = `FUNCTION_SET;
		else
			rNextStateWrite = `INIT_FINISH_LCD;	
	end
//------------------------------------------
	`FUNCTION_SET:
	begin 
		LCD_E = 1'b1;
		LCD_RW = 1'b0;
		LCD_RS = 1'b0;
		SF_DATA = 4'b0000;
		CMD = 2'h28;
		txInit = 1'b0;
		rNextStateWrite = `ENTRY_SET;	
	end
//------------------------------------------
	`ENTRY_SET:
	begin 
		LCD_E = 1'b1;
		LCD_RW = 1'b0;
		LCD_RS = 1'b0;
		SF_DATA = 4'b0000;
		CMD = 2'h06;
		txInit = 1'b0;
		rNextStateWrite = `SET_DISPLAY;	
	end
//------------------------------------------
	`SET_DISPLAY:
	begin 
		LCD_E = 1'b1;
		LCD_RW = 1'b0;
		LCD_RS = 1'b0;
		SF_DATA = 4'b0000;
		CMD = 2'h0C;
		txInit = 1'b0;
		rNextStateWrite = `CLEAR_DISPLAY;
	end
//------------------------------------------
	`CLEAR_DISPLAY:
	begin 
		LCD_E = 1'b1;
		LCD_RW = 1'b0;
		LCD_RS = 1'b0;
		SF_DATA = 4'b0000;
		CMD = 2'h0C;
		txInit = 1'b0;
		rTimeCountReset = 1'b1;
		rNextStateWrite = `PAUSE;
	end
//------------------------------------------
	`PAUSE:
	begin 
		LCD_E = 1'b1;
		LCD_RW = 1'b0;
		LCD_RS = 1'b0;
		SF_DATA = 4'b0000;
		CMD = 2'h0C;
		txInit = 1'b0;
		if (rTimeCount < 90000)
			rNextStateWrite = `PAUSE;
		else 
			rNextStateWrite = `SET_ADDR;
	end
//------------------------------------------
	`SET_ADDR:
	begin 
		LCD_E = 1'b1;
		LCD_RW = 1'b0;
		LCD_RS = 1'b0;
		SF_DATA = 4'b0000;
		CMD = 2'h80;
		txInit = 1'b1;
		rNextStateWrite = `CHAR;
	end
//------------------------------------------
	`CHAR:
	begin 
		LCD_E = 1'b1;
		LCD_RW = 1'b0;
		LCD_RS = 1'b0;
		SF_DATA = 4'b0000;
		CMD = 2'h80;
		txInit = 1'b1;
		if (txInit)
			rNextStateWrite = `CHAR;
		else
			rNextStateWrite = `DONE_MAIN_SM;
	end
//------------------------------------------
	`DONE_MAIN_SM:
	begin 
		LCD_E = 1'b1;
		LCD_RW = 1'b0;
		LCD_RS = 1'b0;
		SF_DATA = 4'b0000;
		CMD = 2'h00;
		txInit = 1'b0;
		rNextStateWrite = `DONE_MAIN_SM;
	end
	default:
	begin 
		LCD_E = 1'b1;
		LCD_RW = 1'b0;
		LCD_RS = 1'b0;
		SF_DATA = 4'b0000;
		CMD = 2'h28;
		txInit = 1'b0;
		if (initDone)
			rNextStateWrite = `FUNCTION_SET;
		else
			rNextStateWrite = `INIT_FINISH_LCD;	
	end
	endcase

//---------TIME CONSTRARINS SM-----------
	case(rCurrentStateTM)
//------------------------------------------
	`DONE_TM:
	begin
		LCD_RW = 1'b0;
		LCD_RS = 1'b0;
		LCD_E = 1'b0;
		SF_DATA = 4'b0;
		if (txInit) begin
			rNextStateTM = `HIGH_SETUP;
			rTimeCountReset = 1'b1;
		end
		else
			rNextStateTM = `DONE_TM;
	end
	//------------------------------------------
	`HIGH_SETUP:
	begin
		LCD_RW = 1'b0;
		LCD_RS = 1'b0;
		LCD_E = 1'b0;
		SF_DATA = CMD[7:4];
		if (rTimeCount < 10)
			rNextStateTM = `HIGH_SETUP;
		else begin
			rTimeCountReset = 1'b1;
			rNextStateTM = `HIGH_HOLD;
		end
	end
	//------------------------------------------
	`HIGH_HOLD:
	begin
		LCD_RW = 1'b0;
		LCD_RS = 1'b0;
		LCD_E = 1'b1;
		SF_DATA = CMD[7:4];
		if (rTimeCount < 40)
			rNextStateTM = `HIGH_HOLD;
		else begin
			rTimeCountReset = 1'b1;
			rNextStateTM = `ONEUS;
		end
	end
	//------------------------------------------
	`ONEUS:
	begin
		LCD_RW = 1'b0;
		LCD_RS = 1'b0;
		LCD_E = 1'b1;
		SF_DATA = CMD[7:4];
		if (rTimeCount < 100)
			rNextStateTM = `ONEUS;
		else begin
			rTimeCountReset = 1'b1;
			rNextStateTM = `LOW_SETUP;
		end
	end
	//------------------------------------------
	`LOW_SETUP:
	begin
		LCD_RW = 1'b0;
		LCD_RS = 1'b0;
		LCD_E = 1'b0;
		SF_DATA = CMD[3:0];
		if (rTimeCount < 10)
			rNextStateTM = `LOW_SETUP;
		else begin
			rTimeCountReset = 1'b1;
			rNextStateTM = `LOW_HOLD;
		end
	end
	//------------------------------------------
	`LOW_HOLD:
	begin
		LCD_RW = 1'b0;
		LCD_RS = 1'b0;
		LCD_E = 1'b1;
		SF_DATA = CMD[3:0];
		if (rTimeCount < 40)
			rNextStateTM = `LOW_HOLD;
		else begin
			rTimeCountReset = 1'b1;
			rNextStateTM = `FORTYUS;
		end
	end
	//------------------------------------------
	`FORTYUS:
	begin
		LCD_RW = 1'b0;
		LCD_RS = 1'b0;
		LCD_E = 1'b1;
		SF_DATA = CMD[3:0];
		if (rTimeCount < 2500)
			rNextStateTM = `FORTYUS;
		else begin 
			txInit = 1'b0;
			rNextStateTM = `DONE;
		end
	end
	//------------------------------------------
	default:
	begin
		LCD_RW = 1'b0;
		LCD_RS = 1'b0;
		LCD_E = 1'b0;
		SF_DATA = 4'b0;
		if (txInit) begin
			rNextStateTM = `HIGH_SETUP;
			rTimeCountReset = 1'b1;
			txInit = 1'b0;
		end
		else
			rNextStateTM = `DONE_TM;
	end
	endcase
end
endmodule