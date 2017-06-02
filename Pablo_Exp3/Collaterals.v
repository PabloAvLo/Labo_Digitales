`timescale 1ns / 1ps

`include "Defintions.v"
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

module LCD(
	clk,
	chars,
	//nibble,
	//counter,
	lcd_rs, lcd_rw, lcd_e, lcd_4, lcd_5, lcd_6, lcd_7);

	// inputs and outputs
	input       	clk;
	//input [3:0] nibble;
	//input [6:0] counter;
	// inputreg [256:0] 	chars;
	output      	lcd_rs, lcd_rw, lcd_e, lcd_4, lcd_5, lcd_6, lcd_7;

	input wire [256:0] 	chars;
	reg	 	lcd_rs, lcd_rw, lcd_e, lcd_4, lcd_5, lcd_6, lcd_7;

	// internal variables
	reg [5:0] 	lcd_code;
	reg [1:0] 	write = 2'b10;	// write code has 10 for rs rw

	// delays
	reg [1:0]	before_delay = 3;	// time before on
	reg [3:0]	on_delay = 13;		// time on
	reg [23:0]	off_delay = 750_001;	// time off

	// states and counters
	reg [6:0]	current_State = 0;
	reg [19:0]	count = 0;
	reg [1:0]	delay_state = 0;

	// character data
	reg [256:0]	chars_hold = "                                ";
	wire [3:0]	chars_data [63:0];	// array of characters



	// redirects characters data to an array
	generate
	genvar i;
		for (i = 64; i > 0; i = i-1)
			begin : for_name
				assign chars_data[64-i] = chars_hold[i*4-1:i*4-4];
			end
	endgenerate

	always @ (posedge clk) begin

		// store character data
		if (current_State == 10 && count == 0)
			chars_hold <= chars;
			//chars_data [counter] <= nibble;
		
		// set time when enable is off
		//INICIALIZACION
		if (current_State < 3) begin
			case (current_State)
				0: off_delay <= 750000;	// 15ms delay
				1: off_delay <= 250000;	// 5ms delay
				2: off_delay <= 5000;		// 0.1ms delay
			endcase
		end else begin
			if (current_State > 12) begin
				off_delay	<= 2000;	// 40us delay
			end else begin
				off_delay	<= 250000;	// 5ms delay
			end
		end

		// delays during each state
		if (current_State < 80) begin
		case (delay_state)
			0: begin
					// enable is off
					lcd_e <= 0;
					{lcd_rs,lcd_rw,lcd_7,lcd_6,lcd_5,lcd_4} <= lcd_code;
					if (count == off_delay) begin
						count <= 0;
						delay_state <= delay_state + 1;
					end else begin
						count <= count + 1;
					end
				end
			1: begin
					// data set before enable is on
					lcd_e <= 0;
					if (count == before_delay) begin
						count <= 0;
						delay_state <= delay_state + 1;
					end else begin
						count <= count + 1;
					end
				end
			2: begin
					// enable on
					lcd_e <= 1;
					if (count == on_delay) begin
						count <= 0;
						delay_state <= delay_state + 1;
					end else begin
						count <= count + 1;
					end
				end
			3: begin
					// enable off with data set
					lcd_e <= 0;
					if (count == before_delay) begin
						count <= 0;
						delay_state <= 0;
						current_State <= current_State + 1;		// next case
					end else begin
						count <= count + 1;
					end
				end
		endcase
		end

		// set lcd_code
		if (current_State < 12) begin
			// initialize LCD
			case (current_State)
				0: lcd_code <= 6'h03;        // power-on initialization
				1: lcd_code <= 6'h03;
				2: lcd_code <= 6'h03;
				3: lcd_code <= 6'h02;
				4: lcd_code <= 6'h02;        // function set
				5: lcd_code <= 6'h08;
				6: lcd_code <= 6'h00;        // entry mode set
				7: lcd_code <= 6'h06;
				8: lcd_code <= 6'h00;        // display on/off control
				9: lcd_code <= 6'h0C;
				10:lcd_code <= 6'h00;        // display clear
				11:lcd_code <= 6'h01;
				default: lcd_code <= 6'h10;	
			endcase
		end else begin

			// set character data to lcd_code
			if (current_State == 44) begin			// change address at end of first line
				lcd_code <= {2'b00, 4'b1100};	// 0100 0000 address change
			end else if (current_State == 45) begin
				lcd_code <= {2'b00, 4'b0000};
			end else begin
				if (current_State < 44) begin
					lcd_code <= {write, chars_data[current_State-12]};
				end else begin
					lcd_code <= {write, chars_data[current_State-14]};
				end
			end

		end

		// hold and loop back
		if (current_State == 78) begin
			lcd_e <= 0;
			if (count == off_delay) begin
				current_State 			<= 10;
				count 		<= 0;
			end else begin
				count <= count + 1;
			end
		end

	end

endmodule