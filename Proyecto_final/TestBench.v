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
	
	reg BTN_EAST; // Moverse Iquierda
	reg BTN_NORTH; // Moverse Arriba
	reg BTN_SOUTH; // Moverse Abajo
	reg BTN_WEST; // Moverse Derecha
	
	reg ROT_CENTER; // Seleccionador
	reg ROT_A; // Girar sentido Horario
	reg ROT_B; // Girar sentido Anti Horario

	// Outputs
	wire VGA_RED, VGA_GREEN, VGA_BLUE,  // Colores VGA
    wire VGA_HSYNC; // Cambio de fila VGA
	wire VGA_VSYNC; // Return inicio VGA 
	wire [3:0] SF_DATA; // Datos para LCD

	// Instantiate the Unit Under Test (UUT)
	MiniAlu uut (
		.Clock(Clock), 
		.Reset(Reset),
		.BTN_EAST(BTN_EAST),
		.BTN_NORTH(BTN_NORTH),
		.BTN_SOUTH(BTN_SOUTH),
		.BTN_WEST(BTN_WEST),
		.ROT_CENTER(ROT_CENTER),
		.ROT_A(ROT_A)
		.ROT_B(ROT_B),
		.VGA_RED(VGA_RED), 
		.VGA_GREEN(VGA_GREEN),
		.VGA_BLUE(VGA_BLUE),
		.VGA_HSYNC(VGA_HSYNC),
		.VGA_VSYNC(VGA_VSYNC),
		.SF_DATA(SF_DATA)
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
        
		// Add stimulus here

	end
      
endmodule

