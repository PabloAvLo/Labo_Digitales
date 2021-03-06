`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:30:52 01/30/2011
// Design Name:   MiniAlu
// Module Name:   D:/Proyecto/RTL/Dev/MiniALU/TestBench.v
// Project Name:  MiniALU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MiniAlu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TestBench;

	// Inputs
	reg Clock;
	reg Reset;
	reg PS2_CLK;
	reg PS2_DATA;
/*
	// Outputs
	wire oVGA_R; 
	wire oVGA_G;
	wire oVGA_B;
	wire oH_sync;
	wire oV_sync;
*/
	// Instantiate the Unit Under Test (UUT)
	MiniAlu uut (
		.Clock(Clock), 
		.Reset(Reset),
		.PS2_CLK(PS2_CLK),
		.PS2_DATA(PS2_DATA) /*,
		.VGA_RED(oVGA_R), 
		.VGA_GREEN(oVGA_G),
		.VGA_BLUE(oVGA_B),
		.VGA_HSYNC(oH_sync),
		.VGA_VSYNC(oV_sync)*/
	);
	
	always
	begin
		#5  Clock =  ! Clock;

	end

	initial begin
		// Initialize Inputs
		Clock = 0;
		Reset = 0;
		PS2_CLK = 1;
		PS2_DATA = 1;

		// Wait 100 ns for global reset to finish
		#100;
		Reset = 1;
		#50
		Reset = 0;
		#50
		PS2_CLK = 0;
		PS2_DATA = 0;
				#50
		PS2_CLK = 0;
		PS2_DATA = 0;
				#50
		PS2_CLK = 1;
		PS2_DATA = 1;
				#50
		PS2_CLK = 1;
		PS2_DATA = 1;
				#50
		PS2_CLK = 0;
		PS2_DATA = 0;
				#50
		PS2_CLK = 0;
		PS2_DATA = 0;
				#50
		PS2_CLK = 1;
		PS2_DATA = 1;
				#50
		PS2_CLK = 0;
		PS2_DATA = 0;
				#50
		PS2_CLK = 0;
		PS2_DATA = 0;
				#50
		PS2_CLK = 1;
		PS2_DATA = 1;
				#50
		PS2_CLK = 0;
		PS2_DATA = 0;
				#50
		PS2_CLK = 0;
		PS2_DATA = 0;
				#50
		PS2_CLK = 1;
		PS2_DATA = 1;
				#50
		PS2_CLK = 1;
		PS2_DATA = 1;
				#50
		PS2_CLK = 0;
		PS2_DATA = 0;
				#50
		PS2_CLK = 0;
		PS2_DATA = 0;
				#50
		PS2_CLK = 1;
		PS2_DATA = 1;
				#50
		PS2_CLK = 0;
		PS2_DATA = 0;
				#50
		PS2_CLK = 0;
		PS2_DATA = 0;
				#50
		PS2_CLK = 1;
		PS2_DATA = 1;
				#50
		PS2_CLK = 1;
		PS2_DATA = 1;
				#50
		PS2_CLK = 1;
		PS2_DATA = 1;
				#50
		PS2_CLK = 1;
		PS2_DATA = 1;
        
		// Add stimulus here

	end
      
endmodule