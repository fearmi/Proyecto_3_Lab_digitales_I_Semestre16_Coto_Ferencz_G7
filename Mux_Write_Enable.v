`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:02:06 04/11/2016 
// Design Name: 
// Module Name:    Mux_Write_Enable 
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
module Mux_Write_Enable( // mux para el write_enable de banco de registros
    input P, // se tienen dos señales, una cuando se programa con botones y se quiere escribir datos en esos registros
    input P1, // y otra donde se envian datos al RTC y se habilita la lectura del banco de registros
    input Select, // selector
    output WE // salida de write_enable de banco de registros de programacion
    );
assign WE= Select ? P : P1; // select 0 pasa P1 con select 1 pasa P

endmodule
