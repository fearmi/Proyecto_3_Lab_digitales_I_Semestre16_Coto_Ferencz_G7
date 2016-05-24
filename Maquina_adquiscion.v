`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:15:10 05/14/2016 
// Design Name: 
// Module Name:    Maquina_adquiscion 
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
module Maquina_adquiscion(
input [7:0] dato_i,
input Clock_i,
input Reset_i,
input wire rx_done_tick_i,
output [7:0] dout_o,
output  reset_o,izq_o,der_o,abajo_o,arriba_o,ent_o
    );
localparam[2:0]//parametros de entrada
a = 2'b00,
b = 2'b01,
c = 2'b10,
d = 2'b11;

reg [7:0]dato_guardado, dout;
reg [2:0] state_reg, state_next;
reg reset,enable,izq,abajo,arriba,der,ent;
always @(posedge Clock_i) // en cada flanco positivo
    if (Reset_i)
        state_reg <= a; // si reset en alto, permanezca en a
		  
    else 
        state_reg <= state_next; // en caso contrario asigne estado actual a estado siguiente
//logica de estado siguente.
always @*
begin

enable = 1'b0;
reset= 1'b0;
izq = 1'b0;
abajo = 1'b0;
arriba = 1'b0;
der = 1'b0;
ent = 1'b0;
dato_guardado=8'b0;
state_next=state_reg;
	case (state_reg)
		a:begin
		if (rx_done_tick_i)
			state_next = b;
		else
			state_next = a;
		end
		b:
		begin
		if(dato_i== 8'hF0)
			state_next = c;
		else
		begin
			reset = 1'b1;
			state_next = a;
			end
		end
		c:begin
		if (rx_done_tick_i)
		dato_guardado = dato_i;
		enable = 1'b1;
			if(dato_i==8'h1d)begin
				arriba = 1'b1;
				state_next = d;
				end
				else if (dato_i == 8'h1c)
				begin
				izq = 1'b1;
				state_next = d;
				end
				else if (dato_i == 8'h23)
				begin
				der = 1'b1;
				state_next = d;
				end
				else if (dato_i == 8'h1b)
				begin
				abajo = 1'b1;
				state_next = d;
				end
				else if (dato_i == 8'h5a)
				begin
				ent = 1'b1;
				state_next = d;
				end
		
		else
			state_next = c;
			end 
		d:
		begin
		reset = 1'b1;
		state_next = a; 
		end
		 default : state_next = a;
		endcase
end		
assign reset_o = reset;
assign arriba_o = arriba;
assign abajo_o = abajo;
assign izq_o = izq;
assign der_o = der;
assign ent_o = ent;
always @ (posedge (enable)) begin
 if (reset_o)
  dout <= 0;
 else
  dout <= dato_guardado;
end
assign dout_o = dout;
endmodule
