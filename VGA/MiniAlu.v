`timescale 1ns / 1ps
`include "Defintions.v"
//`include "random_generator.v"
`include "TABLERO_TOPOS.v"

module MiniAlu
(
// Inputs
 input wire Clock,
 input wire Reset,
 input wire BTN_EAST, // Moverse Iquierda
 input wire BTN_NORTH, // Moverse Arriba
 input wire BTN_SOUTH, // Moverse Abajo
 input wire BTN_WEST, // Moverse Derecha
 input wire ROT_CENTER, // Seleccionador
 input wire ROT_A, // Girar sentido Horario
 input wire ROT_B, // Girar sentido Anti Horario

// Outputs
 output wire VGA_RED, VGA_GREEN, VGA_BLUE,  // Colores VGA
 output wire VGA_HSYNC, // Cambio de fila VGA
 output wire VGA_VSYNC, // Return inicio VGA 
 
 output wire LCD_E, // LCD Enable
 output wire LCD_RS, // LCD 
 output wire LCD_RW, // LCD
 output wire [3:0] SF_DATA, // Datos para LCD
 output wire [7:0] oLed //LEDs
 
);

wire [15:0] wIP,wIP_temp; //Wires de 16 bits para Dirección
reg         rWriteEnable,rBranchTaken; //Registros de 1 bit
wire [27:0] wInstruction;  /*Wire de 28 bits para instrucciones. Conecta al registro de Module_ROM*/									
wire [3:0]  wOperation;    
reg [15:0]  rResult;
wire [7:0]  wSourceAddr0,wSourceAddr1,wDestination;
wire [15:0] wSourceData0,wSourceData1,wIPInitialValue,wImmediateValue;

reg rVGAWriteEnable;
wire wVGA_R, wVGA_G, wVGA_B;

wire [9:0] wH_counter,wV_counter;
wire [7:0] wH_read, wV_read;


reg rRetCall;
reg [7:0] rDirectionBuffer;
wire [7:0] wRetCall;
wire [7:0] wXRedCounter, wYRedCounter;
wire [3:0] HolyCow;

// Definición del clock de 25 MHz
wire Clock_lento; // Clock con frecuencia de 25 MHz

// Se crea una entrada de reset especial 
// para el clock lento, ya que se quiere
// que se inicie desde el puro inicio.
reg rflag;
reg Reset_clock;
always @ (posedge Clock)
begin
	if (rflag) begin
		Reset_clock <= 0;
	end
	else begin
		Reset_clock <= 1;
		rflag <= 1;
	end
end

// Instancia para crear el clock lento 
wire wClock_counter;
assign Clock_lento = wClock_counter;
UPCOUNTER_POSEDGE # ( 1 ) Slow_clock
(
.Clock(   Clock                ), 
.Reset(   Reset_clock ),
.Initial( 1'd0 ), 
.Enable(  1'b1                 ),
.Q(       wClock_counter             )
);
// Fin de la implementación del reloj lento 

// Instancia del controlador de VGA


VGA_controller VGA_controlador
(
	.Clock_lento(Clock_lento),
	.Reset(Reset),
	.iXRedCounter(wXRedCounter),
	.iYRedCounter(wYRedCounter),
	.iVGA_RGB({wVGA_R,wVGA_G,wVGA_B}),
	.iColorCuadro(HolyCow),
	.oVGA_RGB({VGA_RED, VGA_GREEN, VGA_BLUE}),
	.oHsync(VGA_HSYNC),
	.oVsync(VGA_VSYNC),
	.oVcounter(wV_counter),
	.oHcounter(wH_counter)
);

wire [7:0] wRGB0;
wire [7:0] wRGB1;
wire [7:0] wRGB2;
wire [7:0] wRGB3;
wire [7:0] wRGB4;
wire [7:0] wRGB5;
wire [7:0] wRGB6;
wire [7:0] wRGB7;
wire [7:0] wRGB8;
wire [7:0] wRGB9;
wire [7:0] wRGB10;
wire [7:0] wRGB11;
wire [7:0] wRGB12;
wire [7:0] wRGB13;
wire [7:0] wRGB14;
wire [7:0] wRGB15;

ROM InstructionRom 
(
	.iRGB0(wRGB0),
	.iRGB1(wRGB1),
	.iRGB2(wRGB2),
	.iRGB3(wRGB3),
	.iRGB4(wRGB4),
	.iRGB5(wRGB5),
	.iRGB6(wRGB6),
	.iRGB7(wRGB7),
	.iRGB8(wRGB8),
	.iRGB9(wRGB9),
	.iRGB10(wRGB10),
	.iRGB11(wRGB11),
	.iRGB12(wRGB12),
	.iRGB13(wRGB13),
	.iRGB14(wRGB14),
	.iRGB15(wRGB15),
	.iAddress(     wIP          ),	
	.oInstruction( wInstruction )
);

// Instancia RAM de instrucciones y registros
RAM_DUAL_READ_PORT # (16, 3, 8) DataRam
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


assign wH_read = (wH_counter >= 242 && wH_counter <= 496) ? (wH_counter - 240) : 8'd0;
assign wV_read = (wV_counter >= 141 && wV_counter <= 397) ? (wV_counter - 141) : 8'd0;
// Memoria ram para video
RAM_SINGLE_READ_PORT # (3,16,65535) VideoMemory
(
	.Clock(Clock),
	.iWriteEnable( rVGAWriteEnable ),
	.iReadAddress( {wH_read,wV_read} ), // Columna, fila
	.iWriteAddress( {wSourceData1[7:0],wSourceData0[7:0]} ), // Columna, fila
	.iDataIn(wDestination[2:0]),
	.oDataOut( {wVGA_R,wVGA_G,wVGA_B} )
);

always @ (posedge Clock)
begin
	if (wOperation == `CALL)
		rDirectionBuffer <= wIP_temp;
end

assign wIP = (rBranchTaken) ? wIPInitialValue : wIP_temp;
assign wIPInitialValue = (Reset) ? 8'b0 : wRetCall;
assign wRetCall = (rRetCall) ? rDirectionBuffer : wDestination;

UPCOUNTER_POSEDGE IP
(
.Clock(   Clock                ), 
.Reset(   Reset | rBranchTaken ),
.Initial( wIPInitialValue + 16'b1  ),
.Enable(  1'b1                 ),
.Q(       wIP_temp             )
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 4 ) FFD1 //FFs de Instrucción
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[27:24]),
	.Q(wOperation)
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD2 //FFs de Source2
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[7:0]),
	.Q(wSourceAddr0)
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD3 //FFs de Source1
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[15:8]),
	.Q(wSourceAddr1)
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD4 //FFs de Destino
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[23:16]),
	.Q(wDestination)
);

assign wImmediateValue = {wSourceAddr1,wSourceAddr0};


wire [3:0] rand_number; 

random_generator randy (.CLK(Clock), .reset(Reset), .rand(rand_number));

TABLERO_TOPOS tablero (
					.reset(Reset),
					.N_CELDA_PONER_TOPO(rand_number),
					.N_CELDA_SELECT(4'b0011),
					.PONER_TOPO(1'b1),
					.SELECT(1'b1),
					.ENTER(1'b0),
					//.DIR_RGB(),
					.HIT(),
					.oRGB0(wRGB0),
					.oRGB1(wRGB1),
					.oRGB2(wRGB2),
					.oRGB3(wRGB3),
					.oRGB4(wRGB4),
					.oRGB5(wRGB5),
					.oRGB6(wRGB6),
					.oRGB7(wRGB7),
					.oRGB8(wRGB8),
					.oRGB9(wRGB9),
					.oRGB10(wRGB10),
					.oRGB11(wRGB11),
					.oRGB12(wRGB12),
					.oRGB13(wRGB13),
					.oRGB14(wRGB14),
					.oRGB15(wRGB15)
					);

//************ Lectura Botones *******************

wire [4:0] oBTN; //Boton presionado

Button BTN_CHECK (
	.BTN_UP(BTN_NORTH),
	.BTN_DOWN(BTN_SOUTH),
	.BTN_LEFT(BTN_WEST),
	.BTN_RIGHT(BTN_EAST),
	.BTN_CNTR(ROT_CENTER),
	.CLK(Clock),
	.Reset(Reset),
	.BTN(oBTN)
);

//************ Knob *******************

wire [1:0] KNOB; //Giro Boton 
// Bit 1: 1 = Giro, 0 = No Giro 
// Bit 0: 1 = Left, 0 = Rigth

Knob FrecCtrl (
	.Reset(Reset),
	.ROT( {ROT_A, ROT_B} ),
	.CLK(Clock),
	.oKnob(KNOB)
	);

//************** LCD Logica ********************

reg [7:0] 		digito1;
reg [7:0] 		digito2;
reg [7:0]		nivel;
reg [256:0]	chars;
reg Edge;

always @ (posedge Clock)
begin
	if(Reset) begin
		chars <= "Atrapa al Topo                  ";
		digito1 <= 8'b00110000;
		digito2 <= 8'b00110000;
		Edge <= 0;
		nivel <= 8'b00110000;
	end
	
	else begin
		//Logica Botones
		if ((oBTN[0] == 1) && (Edge == 0))begin
			if(digito1 <48 || digito1 >56) begin
				digito1 <= 8'b00110000;
				
				if(digito2 <48 || digito2 >56) begin
					digito2 <= 8'b00110000;
				end
				else begin
					digito2 <= digito2 +1;
				end
			end	
				
			else begin 
				digito1 <= digito1 + 1;
			end
		end
		//Logica Knob
		if (KNOB[1]) begin
			if (KNOB[0]) begin
				if (nivel > 49) begin
					nivel <= nivel - 1;
				end
			end //Izquierda
			else begin
				if (nivel <= 52) begin
					nivel <= nivel + 1;
				end
			end //derecha
		end
		chars <= { "Atrapa al Topo!!Score: ", digito2, digito1, " Lvl: ", nivel };
		Edge <= oBTN[0];
	end	
end

//****************** LCD  ********************
LCD display (
	.clk(Clock), 
	.chars(chars), 
	.lcd_rs(LCD_RS),
	.lcd_rw(LCD_RW), 
	.lcd_e(LCD_E), 
	.lcd_4(SF_DATA[0]), 
	.lcd_5(SF_DATA[1]),
	.lcd_6(SF_DATA[2]), 
	.lcd_7(SF_DATA[3])
);
	
//LEDs
reg rFFLedEN;
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FF_LEDS
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable( rFFLedEN ),
	//.D( KNOB ),
	.D( oBTN ),
	//.D( wSourceData1 ),
	.Q( oLed    )
);
	
always @ ( * )
begin
	case (wOperation)
	//-------------------------------------
	`BGE:
	begin
		rVGAWriteEnable <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rRetCall <= 1'b0;
		if (wSourceData1 >= wSourceData0 )
			rBranchTaken <= 1'b1;
		else
			rBranchTaken <= 1'b0;
	end
	//-------------------------------------
	`BLE:
	begin
		rVGAWriteEnable <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rRetCall <= 1'b0;
		if (wSourceData1 <= wSourceData0 )
			rBranchTaken <= 1'b1;
		else
			rBranchTaken <= 1'b0;
	end
	//-------------------------------------
	`JMP:
	begin
		rVGAWriteEnable <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b1;
		rRetCall <= 1'b0;
	end
	//-------------------------------------	
	`NOP:
	begin
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rVGAWriteEnable <= 1'b0;
		rRetCall <= 1'b0;
	end
	//-------------------------------------
	`STO:
	begin
		rWriteEnable <= 1'b1;
		rBranchTaken <= 1'b0;
		rResult      <= wImmediateValue;
		rVGAWriteEnable <= 1'b0;
		rRetCall <= 1'b0;
	end
	//-------------------------------------
	// Instrucción de sumar 1
	`INC:
	begin
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		rResult      <= wSourceData1 + 1;
		rVGAWriteEnable <= 1'b0;
		rRetCall <= 1'b0;
	end
	//-------------------------------------
		`ADD:
	begin
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		rResult      <= wSourceData1 + wSourceData0;
		rVGAWriteEnable <= 1'b0;
		rRetCall <= 1'b0;
	end
		//--------------------------------------
		`CALL:	//Nuevo
	begin
		rVGAWriteEnable <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b1;
		rRetCall <= 1'b0;
	end
	//--------------------------------------
		`RET:		//Nuevo
	begin
		rVGAWriteEnable <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b1;
		rRetCall <= 1'b1;
	end
	//-------------------------------------
	// Instrucción para escribir pixel a una posición específica	
	`VGA:
	begin
		rWriteEnable <= 1'b0;
		rBranchTaken <= 1'b0;
		rResult      <= 16'b0;
		rVGAWriteEnable <= 1'b1;
		rRetCall <= 1'b0;
	end
		//-------------------------------------
	// Instrucción para escribir pixel a una posición específica	
	`BTN:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b1;
		rBranchTaken <= 1'b0;
		rResult     <= wSourceData1 + oBTN; //Pasa botón presionado
		rVGAWriteEnable <= 1'b0;
		rRetCall <= 1'b0;
	end 
	//-------------------------------------
	`LED:
	begin
		rFFLedEN     <= 1'b1;
		rWriteEnable <= 1'b0;
		rResult      <= 16'b0;
		rBranchTaken <= 1'b0;
		rVGAWriteEnable <= 1'b0;
		rRetCall <= 1'b0;
	end
	//-------------------------------------
	default:
	begin
		rWriteEnable <= 1'b0;
		rResult      <= 16'b0;
		rBranchTaken <= 1'b0;
		rVGAWriteEnable <= 1'b0;
		rRetCall <= 1'b0;
	end	
	//-------------------------------------	
	endcase	
end

endmodule
