`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:07:59 04/06/2016 
// Design Name: 
// Module Name:    regfile 
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
module regfile(input clock, input [3:0] address, input en_write, input [7:0] data_in, output [7:0] data_out);

// Register file storage
reg [7:0] registers[0:15];
reg [7:0] out_val;

// Read and write from register file
always @(posedge clock ) begin
    if (en_write) begin // si escribir en alto
        registers[address] <= data_in; // asigna al registro en la posicion address el valor de dato de entrada
		  out_val <= 8'h00;end
		  
    else
        out_val <= registers[address]; // sino asigna a la salida el dato en posicion address
end
// Output data if not writing. If we are writing,
// do not drive output pins. This is denoted
// by assigning 'z' to the output pins.

assign data_out =  out_val;

endmodule
