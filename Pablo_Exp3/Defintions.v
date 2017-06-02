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
`define LCD  4'd11 // Instruccion nueva, Ejercicio 3.2
`define SHL  4'd12 // Instruccion nueva, Ejercicio 3.2

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