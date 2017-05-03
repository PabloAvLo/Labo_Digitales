`timescale 1ns / 1ps
`ifndef DEFINTIONS_V
`define DEFINTIONS_V
	
//instrucciones de la ROM
`default_nettype none	
`define NOP   4'd0
`define LED   4'd2
`define BLE   4'd3
`define STO   4'd4
`define ADD   4'd5
`define JMP   4'd6
`define SUB  4'd7      // Instruccion nueva, Ejercicio 1.2
`define SMUL   4'd8   // Instruccion nueva, Ejercicio 2.1
`define IMUL  4'd9     // Instruccion nueva, Ejercicio 2.2
`define IMUL2  4'd10 // Instruccion nueva, Ejercicio 2.4

//maquina de estado de inicializacion
`define IDLE 8'd0
`define FIFTEENMS 8'd1
`define ONE 8'd2
`define TWO 8'd3  
`define THREE 8'd4
`define FOUR 8'd5
`define FIVE 8'd6
`define SIX 8'd7
`define SEVEN 8'd8
`define EIGHT 8'd9 
`define DONE 8'd10

//maquina de estados principal
`define INIT_FINISH_LCD 8'd1
`define FUNCTION_SET 8'd2
`define ENTRY_SET 8'd3
`define SET_DISPLAY 8'd4
`define CLEAR_DISPLAY 8'd5
`define PAUSE 8'd6
`define SET_ADDR 8'd7
`define CHAR 8'd8
`define DONE_MAIN_SM 8'd9

//maquina de estamos de los time constrains
`define DONE_TM 8'd0
`define HIGH_SETUP 8'd1
`define HIGH_HOLD 8'd2
`define ONEUS 8'd3
`define LOW_SETUP 8'd4
`define LOW_HOLD 8'd5
`define FORTYUS 8'd5

//registros
`define R0 8'd0
`define R1 8'd1
`define R2 8'd2
`define R3 8'd3
`define R4 8'd4
`define R5 8'd5
`define R6 8'd6
`define R7 8'd7

`endif