`timescale 1ns / 1ps
`include "Defintions.v"

`define LOOP1 8'd8
`define LOOP2 8'd5
module ROM
(
	input  wire[15:0]  		iAddress,
	output reg [27:0] 		oInstruction
);	
always @ ( iAddress )
begin
	case (iAddress)

	0: oInstruction = { `NOP ,24'd4000    };
	1: oInstruction = { `STO , `R7, 16'b10 }; // Originalmente R7=1, ahora 2 para multiplicarse.
	//1: oInstruction = { `STO , `R7, -16'b10 }; // Originalmente R7=1, ahora -2 para SMUL negatuva.
	2: oInstruction = { `STO ,`R3,16'h1     }; 
	3: oInstruction = { `STO, `R4,16'd1000 };
	4: oInstruction = { `STO, `R5,16'd0     };  
	5: oInstruction = { `STO, `R6,16'd2     };  
	//5: oInstruction = { `STO, `R6,16'd3    }; // Se usa R6=3 para ejemplificar SMUL. 
	
//LOOP2:
	6: oInstruction = { `LED ,8'b0,`R7,8'b0 };
	7: oInstruction = { `STO ,`R1,16'h0     }; 	
	//8: oInstruction = { `STO ,`R2,16'd65000 }; // Originalmente
	8: oInstruction = { `STO ,`R2,16'd20000 };   // Se reduce el tiempo del loop para desplegar resultado
//LOOP1:	
	9: oInstruction = { `ADD ,`R1,`R1,`R3    }; 
	10: oInstruction = { `BLE ,`LOOP1,`R1,`R2 }; 
	
	11: oInstruction = { `ADD ,`R5,`R5,`R3    };
	12: oInstruction = { `BLE ,`LOOP2,`R5,`R4 };	
	13: oInstruction = { `NOP ,24'd4000       }; 
	//14: oInstruction = { `ADD ,`R7,`R7,`R3    };
	//14: oInstruction = { `SUB ,`R7,`R7,`R3    }; //EJERCICIO 1.2
	//14: oInstruction = { `SMUL,`R7,`R7,`R6  }; //EJERCICIO 2.1
	14: oInstruction = { `IMUL,`R7,`R7,`R6  }; //EJERCICIO 2.2
	//14: oInstruction = { `IMUL2,`R7,`R7,`R6  }; //EJERCICIO 2.4
	15: oInstruction = { `JMP ,  8'd2,16'b0   };

	default:
		oInstruction = { `LED ,  24'b10101010 };		//NOP
	endcase	
end
	
endmodule