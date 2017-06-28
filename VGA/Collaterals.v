//Mauricio José Valverde Monge A76674
//Francisco Andrés Vargas Piedra A76821
//Collaterals.v Modificado para Laboratorio de Circuitos Digitales I

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
assign {oVGA_R, oVGA_G, oVGA_B} = (oVcounter < 142 || oVcounter >= 398 || 
					  oHcounter < 75 || oHcounter > 665) ? 
					  wMarco : wVGAOutputSelection;

// assign {oVGA_R, oVGA_G, oVGA_B} = (oVcounter < 142 || oVcounter >= 398 || 
// 					  oHcounter < 100 || oHcounter > 356) ? 
// 					  wMarco : wVGAOutputSelection;			

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

module teclado (DATA, CLOCK, Reset, tecla);
	
	input wire DATA, CLOCK,  Reset;
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