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

	// Outputs
	wire [7:0] oLed;
	wire VGA_RED, VGA_GREEN, VGA_BLUE, VGA_VSYNC, VGA_HSYNC; // EXPERIMENTO 4

	// Instantiate the Unit Under Test (UUT)
	MiniAlu uut (
		.Clock(Clock), 
		.Reset(Reset), 
		.oLed(oLed),
		.VGA_BLUE(VGA_BLUE),
		.VGA_GREEN(VGA_GREEN),
		.VGA_RED(VGA_RED),
		.VGA_HSYNC(VGA_HSYNC),
		.VGA_VSYNC(VGA_VSYNC)
	);
	
	always
	begin
		#20  Clock =  ! Clock;

	end

	initial begin
		// Initialize Inputs
		Clock = 0;
		Reset = 0;

		// Wait 100 ns for global reset to finish
		#400;
		Reset = 1;
		#200
		Reset = 0;
        
		// Add stimulus here

	end
      
endmodule