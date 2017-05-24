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

reg [256:0] 	chars = "L                               ";


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
LCD display (.clk(Clock), .chars(chars), /*.counter(LCD_counter),*/ .lcd_rs(LCD_RS), .lcd_rw(LCD_RW), .lcd_e(LCD_E), 
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
		//indicamos que vamos a poner los 4 bits mas significativos de
		//Fuente1 en el codigo de la LCD.
		//rResult <= {wSourceData1[15:12],29'b0};
		if (LCD_counter >= 256)
			LCD_counter = 0;

		//chars[(256-(4*LCD_counter)):(253-(4*LCD_counter))] <= wSourceData1[15:12]; 
		//chars[256:253] <= wSourceData1[15:12]; 
		if (LCD_counter < 64) begin
			case(LCD_counter)
				0: begin
					chars[256:253] <= wSourceData1[15:12];
				end
				1: begin
					chars[252:249] <= wSourceData1[15:12];
				end
				2: begin
					chars[248:245] <= wSourceData1[15:12];
				end
				3: begin
					chars[244:241] <= wSourceData1[15:12];
				end
				4: begin
					chars[240:237] <= wSourceData1[15:12];
				end
				5: begin
					chars[236:233] <= wSourceData1[15:12];
				end
				6: begin
					chars[232:229] <= wSourceData1[15:12];
				end
				7: begin
					chars[228:225] <= wSourceData1[15:12];
				end
				8: begin
					chars[224:221] <= wSourceData1[15:12];
				end
				9: begin
					chars[220:217] <= wSourceData1[15:12];
				end
				10: begin
					chars[216:213] <= wSourceData1[15:12];
				end
				11: begin
					chars[212:209] <= wSourceData1[15:12];
				end
				12: begin
					chars[208:205] <= wSourceData1[15:12];
				end
				13: begin
					chars[204:201] <= wSourceData1[15:12];
				end
				14: begin
					chars[200:197] <= wSourceData1[15:12];
				end
				15: begin
					chars[196:193] <= wSourceData1[15:12];
				end
				16: begin
					chars[192:189] <= wSourceData1[15:12];
				end
				17: begin
					chars[188:185] <= wSourceData1[15:12];
				end
				18: begin
					chars[184:181] <= wSourceData1[15:12];
				end
				19: begin
					chars[180:177] <= wSourceData1[15:12];
				end
				20: begin
					chars[176:173] <= wSourceData1[15:12];
				end
				21: begin
					chars[172:169] <= wSourceData1[15:12];
				end
				22: begin
					chars[168:165] <= wSourceData1[15:12];
				end
				23: begin
					chars[164:161] <= wSourceData1[15:12];
				end
				24: begin
					chars[160:157] <= wSourceData1[15:12];
				end
				25: begin
					chars[156:153] <= wSourceData1[15:12];
				end
				26: begin
					chars[152:149] <= wSourceData1[15:12];
				end
				27: begin
					chars[148:145] <= wSourceData1[15:12];
				end
				28: begin
					chars[144:141] <= wSourceData1[15:12];
				end
				29: begin
					chars[140:137] <= wSourceData1[15:12];
				end
				30: begin
					chars[136:133] <= wSourceData1[15:12];
				end
				31: begin
					chars[132:129] <= wSourceData1[15:12];
				end
				32: begin
					chars[128:125] <= wSourceData1[15:12];
				end
				33: begin
					chars[124:121] <= wSourceData1[15:12];
				end
				34: begin
					chars[120:117] <= wSourceData1[15:12];
				end
				35: begin
					chars[116:113] <= wSourceData1[15:12];
				end
				36: begin
					chars[112:109] <= wSourceData1[15:12];
				end
				37: begin
					chars[108:105] <= wSourceData1[15:12];
				end
				38: begin
					chars[104:101] <= wSourceData1[15:12];
				end
				39: begin
					chars[100:97] <= wSourceData1[15:12];
				end
				40: begin
					chars[96:93] <= wSourceData1[15:12];
				end
				41: begin
					chars[92:89] <= wSourceData1[15:12];
				end
				42: begin
					chars[88:85] <= wSourceData1[15:12];
				end
				43: begin
					chars[84:81] <= wSourceData1[15:12];
				end
				44: begin
					chars[80:77] <= wSourceData1[15:12];
				end
				45: begin
					chars[76:73] <= wSourceData1[15:12];
				end
				46: begin
					chars[72:69] <= wSourceData1[15:12];
				end
				47: begin
					chars[68:65] <= wSourceData1[15:12];
				end
				48: begin
					chars[64:61] <= wSourceData1[15:12];
				end
				49: begin
					chars[60:57] <= wSourceData1[15:12];
				end
				50: begin
					chars[56:53] <= wSourceData1[15:12];
				end
				51: begin
					chars[52:49] <= wSourceData1[15:12];
				end
				52: begin
					chars[48:45] <= wSourceData1[15:12];
				end
				53: begin
					chars[44:41] <= wSourceData1[15:12];
				end
				54: begin
					chars[40:37] <= wSourceData1[15:12];
				end
				55: begin
					chars[36:33] <= wSourceData1[15:12];
				end
				56: begin
					chars[32:29] <= wSourceData1[15:12];
				end
				57: begin
					chars[28:25] <= wSourceData1[15:12];
				end
				58: begin
					chars[24:21] <= wSourceData1[15:12];
				end
				59: begin
					chars[20:17] <= wSourceData1[15:12];
				end
				60: begin
					chars[16:13] <= wSourceData1[15:12];
				end
				61: begin
					chars[12:9] <= wSourceData1[15:12];
				end
				62: begin
					chars[8:5] <= wSourceData1[15:12];
				end
				63: begin
					chars[4:1] <= wSourceData1[15:12];
				end
		endcase end else 
			LCD_counter = 0;

		LCD_counter = LCD_counter + 1;
	end
		//------------------------------------- 
	`SHL:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		//Fuente1 es desplazado a la izquierda una 
	    //cantidad de bits igual a Fuente2 
		//wSourceData1 <= wSourceData1 << wSourceData0;
		rResult <= wSourceData1 << wSourceData0;
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
