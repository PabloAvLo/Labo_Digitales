`timescale 1ns / 1ps
`include "Defintions.v"

`define SALTO_1 8'd9
`define SALTO_2 8'd25
`define SALTO_3 8'd42
`define SALTO_4 8'd50
`define SALTO_5 8'd12
`define SALTO_6 8'd15
`define SALTO_7 8'd18
`define SALTO_8 8'd28
`define SALTO_9 8'd31
`define SALTO_10 8'd34

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
	8: oInstruction = { `STO ,`R0, 16'd255 };	//R5 => cantidad columnas
	
	//---------------PRIMERA FILA---------------
	// Salto_1
	9: oInstruction = { `VGA ,`COLOR_WHITE, `R7, `R6  }; //pasa direccion 0 a la RAM para guardar color azul
	10: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	11: oInstruction = { `BLE, `SALTO_1, `R7, `R1 };	//salta a la instruccion 5

	// Salto_5
	12: oInstruction = {`VGA ,`COLOR_BLUE, `R7, `R6 };
	13: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	14: oInstruction = { `BLE, `SALTO_5, `R7, `R2 };	//salta a la instruccion 5

	// Salto_6
	15: oInstruction = {`VGA ,`COLOR_WHITE, `R7, `R6 };
	16: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	17: oInstruction = { `BLE, `SALTO_6, `R7, `R3 };	//salta a la instruccion 5

	// Salto_7
	18: oInstruction = {`VGA ,`COLOR_BLUE, `R7, `R6 };
	19: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	20: oInstruction = { `BLE, `SALTO_7, `R7, `R5 };	//salta a la instruccion 5

	21: oInstruction = { `STO ,`R7, 16'd0 };	
	22: oInstruction = { `INC, `R6, `R6, 8'd0 };
	23: oInstruction = { `BLE, `SALTO_1, `R6, `R4 };

	//repetir
	40: oInstruction = { `STO ,`R4, 16'd191 };
	41: oInstruction = { `STO ,`R6, 16'd127 };
	42: oInstruction = { `BLE, `SALTO_1, `R6, `R3 };

	47: oInstruction = { `STO ,`R6, 16'd63 };

	//---------------SEGUNDA FILA---------------

	// Salto_2
	25: oInstruction = { `VGA ,`COLOR_BLUE, `R7, `R6  };
	26: oInstruction = { `INC, `R7, `R7, 8'd0 };
	27: oInstruction = { `BLE, `SALTO_2, `R7, `R1 };

	// Salto_8
	28: oInstruction = {`VGA ,`COLOR_WHITE, `R7, `R6 };
	29: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	30: oInstruction = { `BLE, `SALTO_8, `R7, `R2 };	//salta a la instruccion 5

	// Salto_9
	31: oInstruction = {`VGA ,`COLOR_BLUE, `R7, `R6 };
	32: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	33: oInstruction = { `BLE, `SALTO_9, `R7, `R3 };	//salta a la instruccion 5

	// Salto_10
	34: oInstruction = {`VGA ,`COLOR_WHITE, `R7, `R6 };
	35: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	36: oInstruction = { `BLE, `SALTO_10, `R7, `R5 };	//salta a la instruccion 5

	37: oInstruction = { `STO ,`R7, 16'd0 };	
	38: oInstruction = { `INC, `R6, `R6, 8'd0 };
	39: oInstruction = { `BLE, `SALTO_2, `R6, `R0  };	

	//repetir
	43: oInstruction = { `STO ,`R0, 16'd127 };
	44: oInstruction = { `STO ,`R6, 16'd63 };
	45: oInstruction = { `BLE, `SALTO_2, `R6, `R2 };

	//quedese ahi
	46: oInstruction = { `JMP, 8'd46, 16'b0 };
	

	default:
		oInstruction = { `NOP ,24'd4000       };		//NOP
	endcase	
end
	
endmodule