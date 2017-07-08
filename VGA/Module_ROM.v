`timescale 1ns / 1ps
`include "Defintions.v"

// `define SALTO_1 8'd9
// `define SALTO_2 8'd25
// `define SALTO_3 8'd42
// `define SALTO_4 8'd50
// `define SALTO_5 8'd12
// `define SALTO_6 8'd15
// `define SALTO_7 8'd18
// `define SALTO_8 8'd28
// `define SALTO_9 8'd31
// `define SALTO_10 8'd34
// `define SALTO_11 8'd50


`define SALTO_1 8'd9
`define SALTO_2 8'd12
`define SALTO_3 8'd15
`define SALTO_4 8'd18
`define SALTO_5 8'd24
`define SALTO_6 8'd27
`define SALTO_7 8'd30
`define SALTO_8 8'd33
`define SALTO_9 8'd39
`define SALTO_10 8'd42
`define SALTO_11 8'd45
`define SALTO_12 8'd48
`define SALTO_13 8'd54
`define SALTO_14 8'd57
`define SALTO_15 8'd60
`define SALTO_16 8'd63

module ROM
(
	input wire [7:0]		iRGB0,
	input wire [7:0]		iRGB1,
	input wire [7:0]		iRGB2,
	input wire [7:0]		iRGB3,
	input wire [7:0]		iRGB4,
	input wire [7:0]		iRGB5,
	input wire [7:0]		iRGB6,
	input wire [7:0]		iRGB7,
	input wire [7:0]		iRGB8,
	input wire [7:0]		iRGB9,
	input wire [7:0]		iRGB10,
	input wire [7:0]		iRGB11,
	input wire [7:0]		iRGB12,
	input wire [7:0]		iRGB13,
	input wire [7:0]		iRGB14,
	input wire [7:0]		iRGB15,
	input  wire[15:0]  		iAddress,
	output reg [27:0] 		oInstruction
);
	
always @ ( iAddress )
begin
	case (iAddress)

	0: oInstruction = { `NOP ,24'd2000       }; 
	1: oInstruction = { `STO ,`R1, 16'd63 };	//R4 => cantidad filas
	2: oInstruction = { `STO ,`R2, 16'd127 };	//R4 => cantidad filas
	3: oInstruction = { `STO ,`R3, 16'd191 };	//R4 => cantidad filas
	4: oInstruction = { `STO ,`R4, 16'd63 };	//R4 => cantidad filas
	5: oInstruction = { `STO ,`R5, 16'd255 };	//R5 => cantidad columnas

	6: oInstruction = { `STO ,`R7, 16'd0 };	//R7 => Fil 	Registros en donde se elige donde escribir en RAM, y la posición en pantalla.
	7: oInstruction = { `STO ,`R6, 16'd0 };	//R8 => Col
	8: oInstruction = { `STO ,`R0, 16'd255 };	//R5 => cantidad columnas

	//---------------PRIMERA FILA---------------
	// Salto_1
	9: oInstruction = { `VGA ,iRGB0, `R7, `R6  }; //pasa direccion 0 a la RAM para guardar color azul
	10: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	11: oInstruction = { `BLE, `SALTO_1, `R7, `R1 };	//salta a la instruccion 5

	// Salto_2
	12: oInstruction = {`VGA ,iRGB1, `R7, `R6 };
	13: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	14: oInstruction = { `BLE, `SALTO_2, `R7, `R2 };	//salta a la instruccion 5

	// Salto_3
	15: oInstruction = {`VGA ,iRGB2, `R7, `R6 };
	16: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	17: oInstruction = { `BLE, `SALTO_3, `R7, `R3 };	//salta a la instruccion 5

	// Salto_4
	18: oInstruction = {`VGA ,iRGB3, `R7, `R6 };
	19: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	20: oInstruction = { `BLE, `SALTO_4, `R7, `R5 };	//salta a la instruccion 5

	21: oInstruction = { `STO ,`R7, 16'd0 };	
	22: oInstruction = { `INC, `R6, `R6, 8'd0 };
	23: oInstruction = { `BLE, `SALTO_1, `R6, `R4 };


//---------------SEGUNDA FILA---------------
	// Salto_5
	24: oInstruction = { `VGA ,iRGB4, `R7, `R6  }; //pasa direccion 0 a la RAM para guardar color azul
	25: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	26: oInstruction = { `BLE, `SALTO_5, `R7, `R1 };	//salta a la instruccion 5

	// Salto_6
	27: oInstruction = {`VGA ,iRGB5, `R7, `R6 };
	28: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	29: oInstruction = { `BLE, `SALTO_6, `R7, `R2 };	//salta a la instruccion 5

	// Salto_7
	30: oInstruction = {`VGA ,iRGB6, `R7, `R6 };
	31: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	32: oInstruction = { `BLE, `SALTO_7, `R7, `R3 };	//salta a la instruccion 5

	// Salto_8
	33: oInstruction = {`VGA ,iRGB7, `R7, `R6 };
	34: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	35: oInstruction = { `BLE, `SALTO_8, `R7, `R5 };	//salta a la instruccion 5

	36: oInstruction = { `STO ,`R7, 16'd0 };	
	37: oInstruction = { `INC, `R6, `R6, 8'd0 };
	38: oInstruction = { `BLE, `SALTO_5, `R6, `R2 };

	//---------------TERCERA FILA---------------
	// Salto_9
	39: oInstruction = { `VGA ,iRGB8, `R7, `R6  }; //pasa direccion 0 a la RAM para guardar color azul
	40: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	41: oInstruction = { `BLE, `SALTO_9, `R7, `R1 };	//salta a la instruccion 5

	// Salto_10
	42: oInstruction = {`VGA ,iRGB9, `R7, `R6 };
	43: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	44: oInstruction = { `BLE, `SALTO_10, `R7, `R2 };	//salta a la instruccion 5

	// Salto_11
	45: oInstruction = {`VGA ,iRGB10, `R7, `R6 };
	46: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	47: oInstruction = { `BLE, `SALTO_11, `R7, `R3 };	//salta a la instruccion 5

	// Salto_12
	48: oInstruction = {`VGA ,iRGB11, `R7, `R6 };
	49: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	50: oInstruction = { `BLE, `SALTO_12, `R7, `R5 };	//salta a la instruccion 5

	51: oInstruction = { `STO ,`R7, 16'd0 };	
	52: oInstruction = { `INC, `R6, `R6, 8'd0 };
	53: oInstruction = { `BLE, `SALTO_9, `R6, `R3 };

//---------------CUARTA FILA---------------
	// Salto_13
	54: oInstruction = { `VGA ,iRGB12, `R7, `R6  }; //pasa direccion 0 a la RAM para guardar color azul
	55: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	56: oInstruction = { `BLE, `SALTO_13, `R7, `R1 };	//salta a la instruccion 5

	// Salto_14
	57: oInstruction = {`VGA ,iRGB13, `R7, `R6 };
	58: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	59: oInstruction = { `BLE, `SALTO_14, `R7, `R2 };	//salta a la instruccion 5

	// Salto_15
	60: oInstruction = {`VGA ,iRGB14, `R7, `R6 };
	61: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	62: oInstruction = { `BLE, `SALTO_15, `R7, `R3 };	//salta a la instruccion 5

	// Salto_16
	63: oInstruction = {`VGA ,iRGB15, `R7, `R6 };
	64: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	65: oInstruction = { `BLE, `SALTO_16, `R7, `R5 };	//salta a la instruccion 5

	66: oInstruction = { `STO ,`R7, 16'd0 };	
	67: oInstruction = { `INC, `R6, `R6, 8'd0 };
	68: oInstruction = { `BLE, `SALTO_13, `R6, `R5 };
	69: oInstruction = { `STO ,`R6, 16'd0 };

	// 14: oInstruction = { `BTN ,`R7, `R7, 8'd0};	//Poner Botón leído en R7
	70: oInstruction = { `LED ,8'b0,`R7,8'b0 };
	//quedese ahi
	71: oInstruction = { `JMP, 8'd6, 16'b0 };
	
	default:
		oInstruction = { `NOP ,24'd4000       };		//NOP
	endcase	
end
	
endmodule