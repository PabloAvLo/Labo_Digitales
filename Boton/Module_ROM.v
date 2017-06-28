`timescale 1ns / 1ps
`include "Defintions.v"

`define SALTO_1 8'd8
`define SALTO_2 8'd25
`define SALTO_3 8'd42
`define SALTO_4 8'd50
`define SALTO_5 8'd11
`define SALTO_6 8'd14
`define SALTO_7 8'd17
`define SALTO_8 8'd28
`define SALTO_9 8'd31
`define SALTO_10 8'd34
// `define SALTO_11 8'd70
// `define SALTO_12 8'd73
// `define SALTO_13 8'd76
`define SALTO_14 8'd53
`define SALTO_15 8'd56
`define SALTO_16 8'd59


module ROM
(
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
	
	//---------------PRIMERA COLUMNA---------------
	// Salto_1
	8: oInstruction = { `VGA ,`COLOR_WHITE, `R6, `R7  }; //pasa direccion 0 a la RAM para guardar color azul
	9: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	10: oInstruction = { `BLE, `SALTO_1, `R7, `R1 };	//salta a la instruccion 5

	// Salto_5
	11: oInstruction = {`VGA ,`COLOR_YELLOW, `R6, `R7 };
	12: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	13: oInstruction = { `BLE, `SALTO_5, `R7, `R2 };	//salta a la instruccion 5

	// Salto_6
	14: oInstruction = {`VGA ,`COLOR_WHITE, `R6, `R7 };
	15: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	16: oInstruction = { `BLE, `SALTO_6, `R7, `R3 };	//salta a la instruccion 5

	// Salto_7
	17: oInstruction = {`VGA ,`COLOR_YELLOW, `R6, `R7 };
	18: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	19: oInstruction = { `BLE, `SALTO_7, `R7, `R5 };	//salta a la instruccion 5

	20: oInstruction = { `STO ,`R7, 16'd0 };	
	21: oInstruction = { `INC, `R6, `R6, 8'd0 };
	22: oInstruction = { `BLE, `SALTO_1, `R6, `R4 };

	//---------------SEGUNDA COLUMNA---------------

	23: oInstruction = { `STO ,`R7, 16'd0 };	//R7 => Fil
	24: oInstruction = { `STO ,`R4, 16'd127 };	//R4 => Limite Col

	// Salto_2
	25: oInstruction = { `VGA ,`COLOR_YELLOW, `R6, `R7  };
	26: oInstruction = { `INC, `R7, `R7, 8'd0 };
	27: oInstruction = { `BLE, `SALTO_2, `R7, `R1 };

	// Salto_8
	28: oInstruction = {`VGA ,`COLOR_WHITE, `R6, `R7 };
	29: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	30: oInstruction = { `BLE, `SALTO_8, `R7, `R2 };	//salta a la instruccion 5

	// Salto_9
	31: oInstruction = {`VGA ,`COLOR_YELLOW, `R6, `R7 };
	32: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	33: oInstruction = { `BLE, `SALTO_9, `R7, `R3 };	//salta a la instruccion 5

	// Salto_10
	34: oInstruction = {`VGA ,`COLOR_WHITE, `R6, `R7 };
	35: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	36: oInstruction = { `BLE, `SALTO_10, `R7, `R5 };	//salta a la instruccion 5

	37: oInstruction = { `STO ,`R7, 16'd0 };	
	38: oInstruction = { `INC, `R6, `R6, 8'd0 };
	39: oInstruction = { `BLE, `SALTO_2, `R6, `R4 };	
	
	//---------------TERCERA COLUMNA---------------

	40: oInstruction = { `STO ,`R7, 16'd0 };	//R7 => Fil
	41: oInstruction = { `STO ,`R4, 16'd191 };	//R4 => Limite Col

	// Salto_3
	42: oInstruction = { `VGA ,`COLOR_WHITE, `R6, `R7  };
	43: oInstruction = { `INC, `R7, `R7, 8'd0 };
	44: oInstruction = { `BLE, `SALTO_3, `R7, `R5 };	

	// // Salto_11
	// 70: oInstruction = {`VGA ,`COLOR_YELLOW, `R6, `R7 };
	// 71: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	// 71: oInstruction = { `BLE, `SALTO_11, `R7, `R2 };	//salta a la instruccion 5

	// // Salto_12
	// 73: oInstruction = {`VGA ,`COLOR_WHITE, `R6, `R7 };
	// 74: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	// 75: oInstruction = { `BLE, `SALTO_12, `R7, `R3 };	//salta a la instruccion 5

	// // Salto_13
	// 76: oInstruction = {`VGA ,`COLOR_YELLOW, `R6, `R7 };
	// 77: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	// 78: oInstruction = { `BLE, `SALTO_13, `R7, `R5 };	//salta a la instruccion 5

	45: oInstruction = { `STO ,`R7, 16'd0 };	
	46: oInstruction = { `INC, `R6, `R6, 8'd0 };
	47: oInstruction = { `BLE, `SALTO_3, `R6, `R4 };

	//---------------CUARTA COLUMNA---------------	
	
	48: oInstruction = { `STO ,`R7, 16'd0 };	//R7 => Fil
	49: oInstruction = { `STO ,`R4, 16'd255 };	//R4 => Limite Col

	// Salto_4
	50: oInstruction = { `VGA, `COLOR_YELLOW	, `R6, `R7  };
	51: oInstruction = { `INC, `R7, `R7, 8'd0 };
	52: oInstruction = { `BLE, `SALTO_4, `R7, `R5 };

	// // Salto_14
	// 53: oInstruction = {`VGA ,`COLOR_WHITE, `R6, `R7 };
	// 54: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	// 55: oInstruction = { `BLE, `SALTO_8, `R7, `R2 };	//salta a la instruccion 5

	// // Salto_15
	// 56: oInstruction = {`VGA ,`COLOR_YELLOW, `R6, `R7 };
	// 57: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	// 58: oInstruction = { `BLE, `SALTO_9, `R7, `R3 };	//salta a la instruccion 5

	// // Salto_16
	// 59: oInstruction = {`VGA ,`COLOR_WHITE, `R6, `R7 };
	// 60: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	// 61: oInstruction = { `BLE, `SALTO_10, `R7, `R5 };	//salta a la instruccion 5


	53: oInstruction = { `STO ,`R7, 16'd0 };	
	54: oInstruction = { `INC, `R6, `R6, 8'd0 };
	55: oInstruction = { `BLE, `SALTO_4, `R6, `R5 };
	
	//Poner botón en LEDs
	48: oInstruction = { `STO ,`R7, 16'd0 };	//Limpiar R7
	48: oInstruction = { `BTN ,`R7, 16'd0 };	//Poner Botón leído en R7
	56: oInstruction = { `LED ,8'b0,`R7,8'b0 }; //Poner R7 en LEDs

	//quedese ahi
	57: oInstruction = { `JMP, 8'd57, 16'b0 };

	

	default:
		oInstruction = { `NOP ,24'd4000       };		//NOP
	endcase	
end
	
endmodule
