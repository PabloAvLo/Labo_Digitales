`timescale 1ns / 1ps
`include "Defintions.v"

module MiniAlu
(
 input wire Clock,
 input wire Reset,
 output wire [7:0] oLed,
 output wire LCD_E,
 output wire LCD_RS,
 output wire LCD_RW,
 output wire [3:0] SF_DATA
);

reg [6:0] LCD_counter = 0;
wire [15:0]  wIP,wIP_temp;
reg         rWriteEnable,rBranchTaken;
wire [27:0] wInstruction;
wire [3:0]  wOperation;
// reg [15:0]   rResult;
reg [32:0]   rResult;  // Registro de resultado para SMUL (+1 bit para signo)
wire [15:0]	wArr_mul; // Registro de resultado de IMUL
wire [31:0] wArr_mul2; // Registro de resultado de IMUL2
wire [7:0]  wSourceAddr0,wSourceAddr1,wDestination;
wire [15:0] wSourceData0,wSourceData1,wIPInitialValue,wImmediateValue;

//EJERCICIO 2.1 : Cables con signo para SMUL (+1 bit y signed)
wire signed [16:0] wSourceData0_signed,wSourceData1_signed;

reg [256:0] 	chars = "Hola Mundo!!                    ";
reg [256:0] 	charsTemp = "L                               ";
assign wSourceData0_signed = wSourceData0; // Para pasara adecuadamente los datos a SMUL y 
assign wSourceData1_signed = wSourceData1; // analizar datos con y sin signo.

ROM InstructionRom 
(
	.iAddress(     wIP          ),
	.oInstruction( wInstruction )
);

RAM_DUAL_READ_PORT DataRam 
(
	.Clock(         Clock        ),
	.iWriteEnable(  rWriteEnable ),
	.iReadAddress0( wInstruction[7:0] ),
	.iReadAddress1( wInstruction[15:8] ),
	.iWriteAddress( wDestination ),
	.iDataIn(       rResult      ),
	.oDataOut0(     wSourceData0 ),
	.oDataOut1(     wSourceData1 )
);

assign wIPInitialValue = (Reset) ? 8'b0 : wDestination;
UPCOUNTER_POSEDGE IP
(
.Clock(   Clock                ), 
.Reset(   Reset | rBranchTaken ),
.Initial( wIPInitialValue + 1  ),
.Enable(  1'b1                 ),
.Q(       wIP_temp             )
);
assign wIP = (rBranchTaken) ? wIPInitialValue : wIP_temp;

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD1
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[27:24]),
	.Q(wOperation)
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD2
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[7:0]),
	.Q(wSourceAddr0)
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD3
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[15:8]),
	.Q(wSourceAddr1)
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD4
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[23:16]),
	.Q(wDestination)
);


reg rFFLedEN;
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FF_LEDS
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable( rFFLedEN ),
	.D( wSourceData1 ),
	.Q( oLed    )
);


assign wImmediateValue = {wSourceAddr1,wSourceAddr0};

// Instancia de IMUL
IMUL arr_mult(.oResult(wArr_mul), .A(wSourceData1), .B(wSourceData0)); 

// Instancia de IMUL2
IMUL2 mux_mult(.result(wArr_mul2), .A(wSourceData0), .B(wSourceData1));


//Module_LCD_Control LCD_DISPLAY (.Clock(Clock), .Reset(Reset), .LCD_E(LCD_E), .LCD_RS(LCD_RS), 
								//.LCD_RW(LCD_RW), .SF_DATA(SF_DATA));
								
								

//chars tiene que ser de 32 caracteres 
LCD display (.clk(Clock), .chars(chars), .lcd_rs(LCD_RS), .lcd_rw(LCD_RW), .lcd_e(LCD_E), 
			.lcd_4(SF_DATA[0]), .lcd_5(SF_DATA[1]), .lcd_6(SF_DATA[2]), .lcd_7(SF_DATA[3]));

always @ ( * )
begin
	case (wOperation)
	//-------------------------------------
	`NOP:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
	end
	//-------------------------------------
	`ADD:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		rResult      <= wSourceData1 + wSourceData0;
	end
	//-------------------------------------
	`STO:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b1;
		rBranchTaken <= 1'b0;
		rResult      <= wImmediateValue;
	end
	//-------------------------------------
	`BLE:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		if (wSourceData1 <= wSourceData0 )
			rBranchTaken <= 1'b1;
		else
			rBranchTaken <= 1'b0;
		
	end
	//-------------------------------------	
	`JMP:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b1;
	end
	//-------------------------------------	
	`LED:
	begin
		rFFLedEN     <= 1'b1;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b0;
	end
		//-------------------------------------
		//Ejercicio 1.2: Definicion
		//-------------------------------------
	`SUB:
	begin
		rFFLedEN     <= 1'b0; // No enciende LEDS
		rBranchTaken <= 1'b0;  // No salta
		rWriteEnable <= 1'b1;  // Si escribe a memoria
		rResult      <= wSourceData1 - wSourceData0; // Resta dos registros y lo guarda en un tercero
	end
		//-------------------------------------
		//Ejercicio 2.1: Definicion
		//-------------------------------------
	`SMUL:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		rResult <= wSourceData0_signed * wSourceData1_signed; // Cables de datos, con signo, de SMUL	
	end  
		//-------------------------------------
		//Ejercicio 2.2: Definicion
		//-------------------------------------
	`IMUL:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		rResult <= wArr_mul; // Cable conectado a la salida de la instancia de  IMUL
	end
		//-------------------------------------
		//Ejercicio 2.4: Definicion
		//-------------------------------------
	`IMUL2:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		rResult <= wArr_mul2; // Cable conectado a la salida de la instancia de  IMUL2
	end
		//-------------------------------------  
	`LCD:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;	
		rResult      <= 0;	
		//indicamos que vamos a poner los 4 bits mas significativos de
		//Fuente1 en el codigo de la LCD.
		//rResult <= {wSourceData1[15:12],29'b0};
		if (LCD_counter >= 64)
			LCD_counter = 0;
		else begin
			case(LCD_counter) 
				0: begin
					charsTemp[255:252] <= wSourceData1[7:4]; 
					chars[256:0] <= charsTemp[256:0];
				end
				1: begin
					charsTemp[251:248] <= wSourceData1[7:4];
					chars[256:0] <= charsTemp[256:0];					
				end	
				default: chars[255:0] <= charsTemp[255:0];	
			endcase
			
		LCD_counter = LCD_counter +1;
		end

	end
		//------------------------------------- 
	`SHL:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		//Fuente1 es desplazado a la izquierda una 
	    //cantidad de bits igual a Fuente2 
		rResult  <= wSourceData1 << wSourceData0;
	end
		//------------------------------------- 
	default:
	begin
		rFFLedEN     <= 1'b1;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b0;
	end	
	//-------------------------------------	
	endcase	
end

endmodule
