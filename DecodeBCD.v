`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:25:25 05/31/2016 
// Design Name: 
// Module Name:    DecodeBCD 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module DecodeBCD(
    input [7:0] ps2_in,
    output [7:0] ps2_out
    );
localparam B=8;
reg [B-1:0] bcd; //decodificacion de dato de ps2

always @*
	case(ps2_in)
	8'h16 : bcd = 8'h01;// Tecla 1 en teclado
	8'h1E : bcd = 8'h02;// Tecla 2 en teclado
	8'h26 : bcd = 8'h03;// Tecla 3 en teclado
	8'h25 : bcd = 8'h04;// Tecla 4 en teclado
	8'h2E : bcd = 8'h05;// Tecla 5 en teclado
	8'h36 : bcd = 8'h06;// Tecla 6 en teclado
	8'h3D : bcd = 8'h07;// Tecla 7 en teclado
	8'h3E : bcd = 8'h08;// Tecla 8 en teclado
	8'h46 : bcd = 8'h09;// Tecla 9 en teclado
	8'h45 : bcd = 8'h00;// Tecla 0 en teclado
	default: bcd = ps2_in; // en caso de no ser ninguna de las anteriores entonces el dato no cambia
	endcase
assign ps2_out=bcd;
	


endmodule
