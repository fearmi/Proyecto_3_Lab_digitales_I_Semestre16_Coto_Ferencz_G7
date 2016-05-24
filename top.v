`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:32:58 05/16/2016 
// Design Name: 
// Module Name:    top 
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
module top( 
input Clock_i,
input Reset_i,
input ps2d, 
input ps2c,
input rx_en,
output [7:0] dout_o,
output ent_o,arriba_o,abajo_o,der_o,izq_o
//output reset_o

    );
wire [7:0] dout;	 
ps2_rx ps2 (
    .clk(Clock_i), 
    .reset(Reset_i), 
    .ps2d(ps2d), 
    .ps2c(ps2c), 
    .rx_en(rx_en), 
    .rx_done_tick(rx_done_tick), 
    .dout(dout)
    ); 
Maquina_adquiscion Maquina (
    .dato_i(dout), 
    .Clock_i(Clock_i), 
    .Reset_i(Reset_i), 
    .rx_done_tick_i(rx_done_tick), 
    .dout_o(dout_o),  
    .izq_o(izq_o), 
    .der_o(der_o), 
    .abajo_o(abajo_o), 
    .arriba_o(arriba_o), 
    .ent_o(ent_o)
    );







endmodule
