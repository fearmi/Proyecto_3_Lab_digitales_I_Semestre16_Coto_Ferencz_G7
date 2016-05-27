`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Montvydas Klumbys 
// 
// Create Date:    
// Design Name: 
// Module Name:    MainActivity 
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
module MainActivity(
   output wire [7:0]  rgb,
	input wire clk_i, reset_i,
	output wire hsync_o, vsync_o,
	output wire [9:0] pixel_x_o, pixel_y_o
	input wire [7:0] R_Dia_Fecha,R_Mes_Fecha,R_Ano_Fecha,R_Hora_Hora,R_Hora_Minutos,R_Hora_Segundos,R_Cronometro_Hora,R_Cronometro_Minutos,R_Cronometro_Segundo,
	);
	
	reg clk1 = 0;		//need a downcounter to 25MHz
	//parameter Mickey = 13'd6960;	//overall there are 6960 pixels
	parameter Gimpy = 13'd6400;	//overall there are 6400 pixels
	parameter GimpyXY = 7'd80;	//Gimp has 80x80 pixels

always @(posedge clk_i)begin     
		clk1 <= ~clk1;	//Slow down the counter to 25MHz
	end	
 vga_sync vga (	
 .clk_i(clk1), .reset_i(reset_i),.hsync_o(hsync_o), .vsync_o(vsync_o),.pixel_x_o(pixel_x_o), .pixel_y_o(pixel_y_o));
 
 ROM_masres ROM (
    .clk(clk_i), 
    .addr(rom_addr), 
    .data(font_word)
    );
	//VGA Interface gets values of ADDRH & ADDRV and by puting COLOUR_IN, gets valid output COLOUR_OUT
	//Also gets a trigger, when the screen is refreshed
	parameter X0 = 10'd0;//poscion inicial para titulo
	parameter X1 = 10'd200;//Posicion incial para la primer columna 
	parameter X2 = 10'd280;//posicion inicial para la segunda columna
	parameter X3 = 10'd360;//posicion inicial para la tercer columna
	parameter Y = 9'd0;//posicion de la primera fila
	parameter Y1 = 9'd160;//posicion de la segunda fila
	parameter Y2 = 9'd320;//posicion de la tercer fila
	wire [12:0] STATE,STATE1,STATE2,STATE3,STATE4,STATE5,STATE6,STATE7,STATE8;
	reg [7:0] COLOUR_DATA [0:Gimpy-1];
	reg [7:0] COLOUR_DATA1 [0:Gimpy-1];
	reg [7:0] COLOUR_DATA2 [0:Gimpy-1];
	reg [7:0] COLOUR_DATA3 [0:Gimpy-1];
	reg [7:0] COLOUR_DATA4 [0:Gimpy-1];
	reg [7:0] COLOUR_DATA5 [0:Gimpy-1];
	reg [7:0] COLOUR_DATA6 [0:Gimpy-1];
	reg [7:0] COLOUR_DATA7 [0:Gimpy-1];
	reg [7:0] COLOUR_DATA8 [0:Gimpy-1];
	reg [7:0] rg;// registro máscara de la salida de rgb

	initial
	$readmemh ("RTC.list", COLOUR_DATA);//Lee la imagen en hexadecimal
	initial
	$readmemh ("Dia.list", COLOUR_DATA1);//Lee la imagen en hexadecimal
	initial
	$readmemh ("Mes.list", COLOUR_DATA2);//Lee la imagen en hexadecimal
	initial
	$readmemh ("a.list", COLOUR_DATA3);//Lee la imagen en hexadecimal
	initial
	$readmemh ("Hora.list", COLOUR_DATA4);//Lee la imagen en hexadecimal
	initial
	$readmemh ("Min.list", COLOUR_DATA5);//Lee la imagen en hexadecimal
	initial
	$readmemh ("Seg.list", COLOUR_DATA6);//Lee la imagen en hexadecimal
	initial
	$readmemh ("Crono.list", COLOUR_DATA7);//Lee la imagen en hexadecimal
	initial
	$readmemh ("ins.list", COLOUR_DATA8);//Lee la imagen en hexadecimal
	
	assign STATE = (pixel_x_o-X0)*GimpyXY+pixel_y_o-Y;//RTC
	assign STATE1 = (pixel_x_o-X1)*GimpyXY+pixel_y_o-Y;//Dia
	assign STATE2 = (pixel_x_o-X2)*GimpyXY+pixel_y_o-Y;//Mes
	assign STATE3 = (pixel_x_o-X3)*GimpyXY+pixel_y_o-Y;//Ano
	assign STATE4 = (pixel_x_o-X1)*GimpyXY+pixel_y_o-Y1;//Hora
	assign STATE5 = (pixel_x_o-X2)*GimpyXY+pixel_y_o-Y1;//Min
	assign STATE6 = (pixel_x_o-X3)*GimpyXY+pixel_y_o-Y1;//Seg
	assign STATE7 = (pixel_x_o-X2)*GimpyXY+pixel_y_o-Y2;//Crono
	assign STATE8 = (pixel_x_o-X0)*GimpyXY+pixel_y_o-Y2;//instrucciones
	
	always @(posedge clk1) begin// Indica la posición en donde se ubicara la imagen si esta se encuentra dentro del margen definido 
		if (pixel_x_o>=X0 && pixel_x_o<X0+GimpyXY//RTC
			&& pixel_y_o>=Y && pixel_y_o<Y+GimpyXY)
				rg <= COLOUR_DATA[{STATE}];
		else if (pixel_x_o>=X1 && pixel_x_o<X1+GimpyXY//Dia
			&& pixel_y_o>=Y && pixel_y_o<Y+GimpyXY)
				rg <= COLOUR_DATA1[{STATE1}];
		else if (pixel_x_o>=X2 && pixel_x_o<X2+GimpyXY//Mes
			&& pixel_y_o>=Y && pixel_y_o<Y+GimpyXY)
				rg <= COLOUR_DATA2[{STATE2}];
		else if (pixel_x_o>=X3 && pixel_x_o<X3+GimpyXY//Ano
			&& pixel_y_o>=Y && pixel_y_o<Y+GimpyXY)
				rg <= COLOUR_DATA3[{STATE3}];
		else if (pixel_x_o>=X1 && pixel_x_o<X1+GimpyXY//Hora
			&& pixel_y_o>=Y1 && pixel_y_o<Y1+GimpyXY)
				rg <= COLOUR_DATA4[{STATE4}];
		else if (pixel_x_o>=X2 && pixel_x_o<X2+GimpyXY//Min
			&& pixel_y_o>=Y1 && pixel_y_o<Y1+GimpyXY)
				rg <= COLOUR_DATA5[{STATE5}];
		else if (pixel_x_o>=X3 && pixel_x_o<X3+GimpyXY//Seg
			&& pixel_y_o>=Y1 && pixel_y_o<Y1+GimpyXY)
				rg <= COLOUR_DATA6[{STATE6}];
		else if (pixel_x_o>=X2 && pixel_x_o<X2+GimpyXY//Seg
			&& pixel_y_o>=Y2 && pixel_y_o<Y2+GimpyXY)
				rg <= COLOUR_DATA7[{STATE7}];
		else if (pixel_x_o>=X0 && pixel_x_o<X0+GimpyXY//Seg
			&& pixel_y_o>=Y2 && pixel_y_o<Y2+GimpyXY)
				rg <= COLOUR_DATA8[{STATE8}];
			else
				rg <= 8'h1a;
	end 
assign rgb=rg; // Se asigna el valor de la salida del sistema
	
endmodule   
