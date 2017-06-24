//Mauricio José Valverde Monge A76674
//Francisco Andrés Vargas Piedra A76821
//Module_ROM.v Modificado para Laboratorio de Circuitos Digitales I

`timescale 1ns / 1ps
`include "Defintions.v"

`define SaveWhite 8'd50
`define WhiteWhite 8'd52
`define WhiteBlack 8'd57

`define SaveBlack 8'd70
`define BlackBlack 8'd72
`define BlackWhite 8'd77


`define SALTO_1 8'd5
`define SALTO_2 8'd13
`define SALTO_3 8'd21
`define SALTO_4 8'd29
`define SALTO_5 8'd37


module ROM
(
	input  wire[15:0]  		iAddress,
	output reg [27:0] 		oInstruction
);
	
always @ ( iAddress )
begin
	case (iAddress)

	0: oInstruction = { `NOP ,24'd2000       }; 
	1: oInstruction = { `STO ,`R4, 16'd63 };	//R4 => cantidad filas
	2: oInstruction = { `STO ,`R5, 16'd255 };	//R5 => cantidad columnas

	3: oInstruction = { `STO ,`R7, 16'd0 };	//R7 => Fil 	Registros en donde se elige donde escribir en RAM, y la posición en pantalla.
	4: oInstruction = { `STO ,`R6, 16'd0 };	//R8 => Col
	// Salto_1
	5: oInstruction = { `VGA ,`COLOR_GREEN, `R7, `R6  }; //pasa direccion 0 a la RAM para guardar color azul
	6: oInstruction = { `INC, `R7, `R7, 8'd0 }; //pasa a la siguiente direccion de RAM
	7: oInstruction = { `BLE, `SALTO_1, `R7, `R5 };	//salta a la instruccion 5
	8: oInstruction = { `STO ,`R7, 16'd0 };	
	9: oInstruction = { `INC, `R6, `R6, 8'd0 };
	10: oInstruction = { `BLE, `SALTO_1, `R6, `R4 };

	11: oInstruction = { `STO ,`R7, 16'd0 };	//R7 => Fil
	12: oInstruction = { `STO ,`R4, 16'd127 };	//R4 => Limite Col

	// Salto_2
	13: oInstruction = { `VGA ,`COLOR_RED, `R7, `R6  };
	14: oInstruction = { `INC, `R7, `R7, 8'd0 };
	15: oInstruction = { `BLE, `SALTO_2, `R7, `R5 };	
	16: oInstruction = { `STO ,`R7, 16'd0 };	
	17: oInstruction = { `INC, `R6, `R6, 8'd0 };
	18: oInstruction = { `BLE, `SALTO_2, `R6, `R4 };	
	
	19: oInstruction = { `STO ,`R7, 16'd0 };	//R7 => Fil
	20: oInstruction = { `STO ,`R4, 16'd191 };	//R4 => Limite Col

	// Salto_3
	21: oInstruction = { `VGA ,`COLOR_MAGENTA, `R7, `R6  };
	22: oInstruction = { `INC, `R7, `R7, 8'd0 };
	23: oInstruction = { `BLE, `SALTO_3, `R7, `R5 };	
	24: oInstruction = { `STO ,`R7, 16'd0 };	
	25: oInstruction = { `INC, `R6, `R6, 8'd0 };
	26: oInstruction = { `BLE, `SALTO_3, `R6, `R4 };	
	
	27: oInstruction = { `STO ,`R7, 16'd0 };	//R7 => Fil
	28: oInstruction = { `STO ,`R4, 16'd255 };	//R4 => Limite Col

	// Salto_4
	29: oInstruction = { `VGA, `COLOR_BLUE	, `R7, `R6  };
	30: oInstruction = { `INC, `R7, `R7, 8'd0 };
	31: oInstruction = { `BLE, `SALTO_4, `R7, `R5 };	
	32: oInstruction = { `STO ,`R7, 16'd0 };	
	33: oInstruction = { `INC, `R6, `R6, 8'd0 };
	34: oInstruction = { `BLE, `SALTO_4, `R6, `R5 };	

	// 35: oInstruction = { `STO ,`R7, 16'd0 };	//R7 => Fil
	// 36: oInstruction = { `STO ,`R4, 16'd319 };	//R4 => Limite Col

	// // Salto_5
	// 37: oInstruction = { `VGA, `COLOR_YELLOW	, `R7, `R6  };
	// 38: oInstruction = { `INC, `R7, `R7, 8'd0 };
	// 39: oInstruction = { `BLE, `SALTO_5, `R7, `R5 };	
	// 40: oInstruction = { `STO ,`R7, 16'd0 };	
	// 41: oInstruction = { `INC, `R6, `R6, 8'd0 };
	// 42: oInstruction = { `BLE, `SALTO_4, `R6, `R5 };

	//quedese ahi
	35: oInstruction = { `JMP, 8'd35, 16'b0 };

	

	default:
		oInstruction = { `NOP ,24'd4000       };		//NOP
	endcase	
end
	
endmodule
