`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:09:25 03/31/2016 
// Design Name: 
// Module Name:    Timer 
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
module Timer(
    input clock,
    input reset,
    output [6:0]pulse
    );
reg [6:0] pulso ;

always@(posedge clock or posedge reset)
begin
	if(reset) pulso<=7'd0;
	else pulso<=pulso + 1'b1;
end

assign pulse=pulso;

endmodule

