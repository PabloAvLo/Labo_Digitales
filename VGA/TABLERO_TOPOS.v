`include "CELDA_TOPO.v"

module SELECT_LOGIC(
	input reset,
	input [4:0] BTN, // {BTN_UP, BTN_DOWN, BTN_LEFT, BTN_RGHT, BTN_CNTR}
	output reg [3:0] N_CELDA_SELECT,
	output wire ENTER
	);

	wire BTN_UP, BTN_DOWN, BTN_LEFT, BTN_RIGHT;

	assign BTN_UP = BTN[4];
	assign BTN_DOWN = BTN[3];
	assign BTN_LEFT = BTN[2];
	assign BTN_RIGHT = BTN[1];
	assign ENTER = (reset)? 0: BTN[0];


	always @(*) begin

		if(reset)
			N_CELDA_SELECT = 0;
		else begin
			if(BTN_RIGHT)
				N_CELDA_SELECT = N_CELDA_SELECT + 1;
			if(BTN_LEFT)
				N_CELDA_SELECT = N_CELDA_SELECT - 1;
			if(BTN_DOWN)
				N_CELDA_SELECT = N_CELDA_SELECT + 4;
			if(BTN_UP)
				N_CELDA_SELECT = N_CELDA_SELECT - 4;
		end
	end



endmodule

module TABLERO_TOPOS(
	input reset,
	input [3:0] N_CELDA_PONER_TOPO,
	input [3:0] N_CELDA_SELECT,
	input wire PONER_TOPO,
	input wire SELECT,
	input wire ENTER,
	input wire [3:0] DIR_RGB,
	output wire HIT,
	output wire [7:0] oRGB
	);

	wire [2:0] RGB;
	wire oHC0, oHC1, oHC2, oHC3, oHC4, oHC5, oHC6, oHC7, oHC8, oHC9, oHC10,oHC11,oHC12,oHC13,oHC14,oHC15;
	wire iPT0, iPT1,iPT2,iPT3,iPT4,iPT5,iPT6,iPT7,iPT8,iPT9,iPT10,iPT11,iPT12,iPT13,iPT14,iPT15;
	wire wS0, wS1,wS2,wS3,wS4,wS5,wS6,wS7,wS8,wS9,wS10,wS11,wS12,wS13,wS14,wS15;
	wire [2:0] wRGB0, wRGB1, wRGB2, wRGB3, wRGB4, wRGB5, wRGB6, wRGB7, wRGB8, wRGB9, wRGB10, wRGB11, wRGB12, wRGB13, wRGB14, wRGB15;

	assign HIT = oHC0 || oHC1|| oHC2|| oHC3|| oHC4|| oHC5|| oHC6|| oHC7|| oHC8|| oHC9|| oHC10|| oHC11|| oHC12|| oHC13|| oHC14|| oHC15;

	assign iPT0  = (N_CELDA_PONER_TOPO == 0  && PONER_TOPO == 1)? 1:0;
	assign iPT1  = (N_CELDA_PONER_TOPO == 1  && PONER_TOPO == 1)? 1:0;
	assign iPT2  = (N_CELDA_PONER_TOPO == 2  && PONER_TOPO == 1)? 1:0;
	assign iPT3  = (N_CELDA_PONER_TOPO == 3  && PONER_TOPO == 1)? 1:0;
	assign iPT4  = (N_CELDA_PONER_TOPO == 4  && PONER_TOPO == 1)? 1:0;
	assign iPT5  = (N_CELDA_PONER_TOPO == 5  && PONER_TOPO == 1)? 1:0;
	assign iPT6  = (N_CELDA_PONER_TOPO == 6  && PONER_TOPO == 1)? 1:0;
	assign iPT7  = (N_CELDA_PONER_TOPO == 7  && PONER_TOPO == 1)? 1:0;
	assign iPT8  = (N_CELDA_PONER_TOPO == 8  && PONER_TOPO == 1)? 1:0;
	assign iPT9  = (N_CELDA_PONER_TOPO == 9  && PONER_TOPO == 1)? 1:0;
	assign iPT10 = (N_CELDA_PONER_TOPO == 10 && PONER_TOPO == 1)? 1:0;
	assign iPT11 = (N_CELDA_PONER_TOPO == 11 && PONER_TOPO == 1)? 1:0;
	assign iPT12 = (N_CELDA_PONER_TOPO == 12 && PONER_TOPO == 1)? 1:0;
	assign iPT13 = (N_CELDA_PONER_TOPO == 13 && PONER_TOPO == 1)? 1:0;
	assign iPT14 = (N_CELDA_PONER_TOPO == 14 && PONER_TOPO == 1)? 1:0;
	assign iPT15 = (N_CELDA_PONER_TOPO == 15 && PONER_TOPO == 1)? 1:0;

	assign wS0  = (N_CELDA_SELECT == 0  && SELECT )? 1:0;
	assign wS1  = (N_CELDA_SELECT == 1  && SELECT )? 1:0;
	assign wS2  = (N_CELDA_SELECT == 2  && SELECT )? 1:0;
	assign wS3  = (N_CELDA_SELECT == 3  && SELECT )? 1:0;
	assign wS4  = (N_CELDA_SELECT == 4  && SELECT )? 1:0;
	assign wS5  = (N_CELDA_SELECT == 5  && SELECT )? 1:0;
	assign wS6  = (N_CELDA_SELECT == 6  && SELECT )? 1:0;
	assign wS7  = (N_CELDA_SELECT == 7  && SELECT )? 1:0;
	assign wS8  = (N_CELDA_SELECT == 8  && SELECT )? 1:0;
	assign wS9  = (N_CELDA_SELECT == 9  && SELECT )? 1:0;
	assign wS10 = (N_CELDA_SELECT == 10 && SELECT )? 1:0;
	assign wS11 = (N_CELDA_SELECT == 11 && SELECT )? 1:0;
	assign wS12 = (N_CELDA_SELECT == 12 && SELECT )? 1:0;
	assign wS13 = (N_CELDA_SELECT == 13 && SELECT )? 1:0;
	assign wS14 = (N_CELDA_SELECT == 14 && SELECT )? 1:0;
	assign wS15 = (N_CELDA_SELECT == 15 && SELECT )? 1:0;

	assign RGB = (DIR_RGB == 0)?  wRGB0 :
			     (DIR_RGB == 1)?  wRGB1 :
				 (DIR_RGB == 2)?  wRGB2 :
				 (DIR_RGB == 3)?  wRGB3 :
				 (DIR_RGB == 4)?  wRGB4 :
				 (DIR_RGB == 5)?  wRGB5 :
				 (DIR_RGB == 6)?  wRGB6 :
				 (DIR_RGB == 7)?  wRGB7 :
				 (DIR_RGB == 8)?  wRGB8 :
				 (DIR_RGB == 9)?  wRGB9 :
				 (DIR_RGB == 10)? wRGB10 :
				 (DIR_RGB == 11)? wRGB11 :
				 (DIR_RGB == 12)? wRGB12 :
				 (DIR_RGB == 13)? wRGB13 :
				 (DIR_RGB == 14)? wRGB14 : wRGB15;

	assign oRGB = {5'b0,RGB}; 

	CELDA_TOPO C0( .reset(reset), .PONER_TOPO(iPT0),  .GOLPE(ENTER), .SELECT(wS0),  .HIT(oHC0),  .RGB(wRGB0));
	CELDA_TOPO C1( .reset(reset), .PONER_TOPO(iPT1),  .GOLPE(ENTER), .SELECT(wS1),  .HIT(oHC1),  .RGB(wRGB1));
	CELDA_TOPO C2( .reset(reset), .PONER_TOPO(iPT2),  .GOLPE(ENTER), .SELECT(wS2),  .HIT(oHC2),  .RGB(wRGB2));
	CELDA_TOPO C3( .reset(reset), .PONER_TOPO(iPT3),  .GOLPE(ENTER), .SELECT(wS3),  .HIT(oHC3),  .RGB(wRGB3));
	CELDA_TOPO C4( .reset(reset), .PONER_TOPO(iPT4),  .GOLPE(ENTER), .SELECT(wS4),  .HIT(oHC4),  .RGB(wRGB4));
	CELDA_TOPO C5( .reset(reset), .PONER_TOPO(iPT5),  .GOLPE(ENTER), .SELECT(wS5),  .HIT(oHC5),  .RGB(wRGB5));
	CELDA_TOPO C6( .reset(reset), .PONER_TOPO(iPT6),  .GOLPE(ENTER), .SELECT(wS6),  .HIT(oHC6),  .RGB(wRGB6));
	CELDA_TOPO C7( .reset(reset), .PONER_TOPO(iPT7),  .GOLPE(ENTER), .SELECT(wS7),  .HIT(oHC7),  .RGB(wRGB7));
	CELDA_TOPO C8( .reset(reset), .PONER_TOPO(iPT8),  .GOLPE(ENTER), .SELECT(wS8),  .HIT(oHC8),  .RGB(wRGB8));
	CELDA_TOPO C9( .reset(reset), .PONER_TOPO(iPT9),  .GOLPE(ENTER), .SELECT(wS9),  .HIT(oHC9),  .RGB(wRGB9));
	CELDA_TOPO C10(.reset(reset), .PONER_TOPO(iPT10), .GOLPE(ENTER), .SELECT(wS10), .HIT(oHC10), .RGB(wRGB10));
	CELDA_TOPO C11(.reset(reset), .PONER_TOPO(iPT11), .GOLPE(ENTER), .SELECT(wS11), .HIT(oHC11), .RGB(wRGB11));
	CELDA_TOPO C12(.reset(reset), .PONER_TOPO(iPT12), .GOLPE(ENTER), .SELECT(wS12), .HIT(oHC12), .RGB(wRGB12));
	CELDA_TOPO C13(.reset(reset), .PONER_TOPO(iPT13), .GOLPE(ENTER), .SELECT(wS13), .HIT(oHC13), .RGB(wRGB13));
	CELDA_TOPO C14(.reset(reset), .PONER_TOPO(iPT14), .GOLPE(ENTER), .SELECT(wS14), .HIT(oHC14), .RGB(wRGB14));
	CELDA_TOPO C15(.reset(reset), .PONER_TOPO(iPT15), .GOLPE(ENTER), .SELECT(wS15), .HIT(oHC15), .RGB(wRGB15));

endmodule
