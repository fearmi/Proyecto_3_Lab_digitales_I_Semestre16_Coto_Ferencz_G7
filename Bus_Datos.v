`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:52:05 04/17/2016 
// Design Name: 
// Module Name:    Bus_Datos 
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
module Bus_Datos(clk,leerdato,escribirdato,AD,direccion,datoescribir,datoleer,salient); //modulo que se encarga de datos 
//señales de entrada y salida
input wire clk,leerdato;
input wire escribirdato,AD;
input wire [7:0] direccion,datoescribir;
output reg [7:0] datoleer;
inout wire [7:0]salient;
 
wire [7:0]datodireccion; // dato o direccion segun señal de seleccion
assign datodireccion= AD ? datoescribir:direccion; // si AD alto entonces dato, sino direccion
assign salient=escribirdato ? datodireccion:8'hzz; // si escribir dato en alto entonces se coloca datodireccion,
  // sino alta impedancia
always @(posedge clk)
      if (leerdato) // si leer en alto
         datoleer  <= salient; //dato leer es igual al dato de entrada del RTC
      else
         datoleer <= datoleer;// datoleer es el dato que se lee del rtc
endmodule


