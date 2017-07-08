`timescale 1ns / 1ps

//------------------------------------------------
// Módulo del contador que se incrementa en 1 para 
// llevar el orden de las instrucciones a ejecutar.
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
// Módulo de un flip-flop D de flanco positivo 
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
// Módulo VGA controller
module VGA_controller
(
	input wire				Clock_lento,
	input wire 				Reset,
	input wire	[2:0]		iVGA_RGB,
	input wire  [2:0]		iColorCuadro,
	input wire  [7:0]		iXRedCounter,
	input wire  [7:0]		iYRedCounter,
	output wire	[2:0]		oVGA_RGB,
	output wire				oHsync,
	output wire				oVsync,
	output wire [9:0]		oVcounter,
	output wire [9:0]		oHcounter
);
wire iVGA_R, iVGA_G, iVGA_B;
wire oVGA_R, oVGA_G, oVGA_B;
wire wEndline;
wire [3:0] wMarco; //, wCuadro;
wire [2:0] wVGAOutputSelection;

assign wMarco = 3'b0;

assign wVGAOutputSelection = {iVGA_R, iVGA_G, iVGA_B};

assign iVGA_R = iVGA_RGB[2];
assign iVGA_G = iVGA_RGB[1];
assign iVGA_B = iVGA_RGB[0];
assign oVGA_RGB = {oVGA_R, oVGA_G, oVGA_B};

assign oHsync = (oHcounter < 704) ? 1'b1 : 1'b0; //640
assign wEndline = (oHcounter == 799);
assign oVsync = (oVcounter < 519) ? 1'b1 : 1'b0; //480

// Marco negro e imagen de 256*256
assign {oVGA_R, oVGA_G, oVGA_B} = (oVcounter < 142 || oVcounter >= 396 || 
					  oHcounter < 242 || oHcounter > 497) ? 
					  wMarco : wVGAOutputSelection;

UPCOUNTER_POSEDGE # (10) HORIZONTAL_COUNTER
(
.Clock	(   Clock_lento   ), 
.Reset	( (oHcounter > 799) || Reset 		),
.Initial	( 10'b0  			),
.Enable	(  1'b1				),
.Q			(	oHcounter      )
);

UPCOUNTER_POSEDGE # (10) VERTICAL_COUNTER
(
.Clock	( Clock_lento    ), 
.Reset	( (oVcounter > 520) || Reset ),
.Initial	( 10'b0  			),	
.Enable	( wEndline            ),
.Q			( oVcounter      )
);

endmodule

//----------------------------------------------------------------------
// Module LCD

module LCD(
	clk,
	chars,
	lcd_rs, lcd_rw, lcd_e, lcd_4, lcd_5, lcd_6, lcd_7);

	// inputs and outputs
	input clk;
	output lcd_rs, lcd_rw, lcd_e, lcd_4, lcd_5, lcd_6, lcd_7;

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

//----------------------------------------------------------------------
// Module Button

module Button
(	input wire BTN_UP,
	input wire BTN_DOWN,
	input wire BTN_LEFT,
	input wire BTN_RIGHT,
	input wire BTN_CNTR,
	input wire CLK,
	input wire Reset,
	output reg [4:0] BTN
);
	
	reg [31:0] rCLKCounter;  //Contador de ciclos del reloj
	reg [4:0] rBTN; 		//Registro con botón presionado
	reg [4:0] rBTNTemp;		//Temporal para BTN mientras se suprimen los rebotes
	
	//Lógica principal
	always @ (posedge CLK or posedge Reset) begin
		rCLKCounter <= rCLKCounter + 1;
		
		//Manejo del Reset
		if (Reset) begin
			rCLKCounter <= 0;
			rBTN <= 0;
			rBTNTemp <= 0;
			BTN <= 0;
		end	//end Reset
				
		//Control de los Botones
		else begin 
			//Verificar que se haya presionado algún botón
			rBTN <= {BTN_UP, BTN_DOWN, BTN_LEFT, BTN_RIGHT, BTN_CNTR};
			
			if (rBTN != 0) begin
			//if ( BTN_UP || BTN_DOWN || BTN_LEFT || BTN_RIGHT || BTN_CNTR) begin
				rBTNTemp <= rBTN;
			end
			else begin
				rBTNTemp <= rBTNTemp;
			end
			
			if (rCLKCounter <= 1000) begin
				rBTNTemp <= rBTNTemp;
			end
			else begin
				rCLKCounter <= 0; //Reset contador de ciclos
				if (rBTN == rBTNTemp) begin //Sigue pulsado el botón y no va a enviar basura
					BTN <= rBTN;
				end
				else begin //Era basura
					BTN <= 0;
				end
			end	
		end //end Control Botone
	end
endmodule

//----------------------------------------------------------------------
// Module Knob: Rotary Encoder

module Knob 
(
	input wire Reset,
    input wire [1:0] ROT,
    input wire CLK,
    output reg [1:0] oKnob
);

	reg rotary_A, rotary_B;
	reg prevA;

	//Filtro
	always @ (posedge CLK or posedge Reset) begin
		//Manejo Reset
		if (Reset) begin
			rotary_A <= 0;
			rotary_B <= 0;
			prevA <= 0;
			oKnob <= 0;
		end
		else begin
			
			//Manejo de estados de rotary_A y rotary_B
			case (ROT)
				2'b00: begin
					rotary_A <= 0;
					rotary_B <= rotary_B;
				end
				2'b01: begin
					rotary_A <= rotary_A;
					rotary_B <= 0;
				end
				2'b10: begin
					rotary_A <= rotary_A;
					rotary_B <= 1;
				end
				2'b11: begin
					rotary_A <= 1;
					rotary_B <= rotary_B;
				end
				default: begin
					rotary_A <= rotary_A;
					rotary_B <= rotary_B;
				end
			endcase
			
		prevA <= rotary_A;
		
		//Knob se movio
		if (prevA == 0 && rotary_A == 1) begin
			oKnob <= {1,rotary_B};
		end
		else begin
			oKnob <= {0,oKnob[0]};
		end

		end //else Reset
	end //always filtro
endmodule