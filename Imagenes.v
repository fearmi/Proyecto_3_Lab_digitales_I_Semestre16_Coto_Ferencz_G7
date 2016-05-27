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
	//input wire [7:0] R_Dia_Fecha,R_Mes_Fecha,R_Ano_Fecha,R_Hora_Hora,R_Hora_Minutos,R_Hora_Segundos,R_Cronometro_Hora,R_Cronometro_Minutos,R_Cronometro_Segundo,
	output wire hsync_o, vsync_o
	);
	reg clk1 = 0;		//need a downcounter to 25MHz
	parameter Gimpy = 13'd6400;	//overall there are 6400 pixels
	parameter GimpyXY = 7'd80;	//Gimp has 80x80 pixels
   // signal declaration
  wire [9:0]pixel_x_o,pixel_y_o;
  wire[7:0] text_rgb;
  wire Mux;
//Divisor de frecuecnia.
always @(posedge clk_i)begin     
		clk1 <= ~clk1;	//Slow down the counter to 25MHz
	end	
//===========================
//instacicion de modulos requeridos
 vga_sync vga (	
 //=========================
 .clk_i(clk1), .reset_i(reset_i),.hsync_o(hsync_o), .vsync_o(vsync_o),.pixel_x_o(pixel_x_o), .pixel_y_o(pixel_y_o));
//======================================= 

//=======================
localparam R_Dia_Fecha = 8'h01;
localparam R_Mes_Fecha = 8'h02;
localparam R_Ano_Fecha = 8'h03;
localparam R_Hora_Hora = 8'h04;
localparam R_Hora_Minutos = 8'h05;
localparam R_Hora_Segundos = 8'h06;
localparam R_Cronometro_Hora = 8'h07;
localparam R_Cronometro_Minutos = 8'h08;
localparam R_Cronometro_Segundo =8'h09;
/*
Generador Numeros (
    .clk(clk_i), 
    .pixel_x_o(pixel_x_o), 
    .pixel_y_o(pixel_y_o), 
    .R_Dia_Fecha(Ra_Dia_Fecha), 
    .R_Mes_Fecha(Ra_Mes_Fecha), 
    .R_Ano_Fecha(Ra_Ano_Fecha), 
    .R_Hora_Hora(Ra_Hora_Hora), 
    .R_Hora_Minutos(Ra_Hora_Minutos), 
    .R_Hora_Segundos(Ra_Hora_Segundos), 
    .R_Cronometro_Hora(Ra_Cronometro_Hora), 
    .R_Cronometro_Minutos(Ra_Cronometro_Minutos), 
    .R_Cronometro_Segundo(Ra_Cronometro_Segundo), 
    .text_rgb(text_rgb), 
    .Mux(Mux)
    );
 
 */
	//Registros y wire neceista numeros 
	/* wire [10:0] rom_addr;
   reg [6:0] char_addr, char_addr_M_F, char_addr_D_F,char_addr_A_F,char_addr_H_H,char_addr_H_M, char_addr_H_S,char_addr_C_H,char_addr_C_M,char_addr_C_S;
   reg [3:0] row_addr;
   wire [3:0] row_addr_D_F,row_addr_M_F,row_addr_A_F,row_addr_H_H, row_addr_H_M,row_addr_C_H,row_addr_H_S,row_addr_C_M,row_addr_C_S;
   reg [2:0] bit_addr;
   wire [2:0] bit_addr_D_F,bit_addr_M_F,bit_addr_A_F,bit_addr_H_H, bit_addr_H_M, bit_addr_C_H,bit_addr_H_S,bit_addr_C_M,bit_addr_C_S;
   wire [7:0] font_word;
   wire font_bit, score_on, logo_on, rule_on, Fecha;
	wire Mes_Fecha, Hora,Ano_Fecha,Hora_H,Hora_M;*/
	wire [10:0] rom_addr;
   reg [6:0] char_addr, char_addr_r, char_addr_s, char_addr_g;//
   reg [3:0] row_addr;
   wire [3:0] row_addr_r, row_addr_s, row_addr_g;//
   reg [2:0] bit_addr;
   wire [2:0] bit_addr_r, bit_addr_s, bit_addr_g;//,
   wire [7:0] font_word;
   wire font_bit, rule_on, score_on, cron_on;//
   wire [7:0] rule_rom_addr, cron_rom_addr;
	
   // instantiate font ROM
//==================================================================================	
//instancia la rom
ROM_masres instance_name (
    .clk_i(clk1), .addr(rom_addr), .data(font_word));

//==========================================


//=================================================================================
//Interface de imagenes
	parameter X0 = 10'd100-10'd25;//poscion inicial para titulo
	parameter X1 = 10'd200-10'd25;//Posicion incial para la primer columna 
	parameter X2 = 10'd280-10'd25;//posicion inicial para la segunda columna
	parameter X3 = 10'd360-10'd25;//posicion inicial para la tercer columna
	parameter Y = 9'd0;//posicion de la primera fila
	parameter Y1 = 9'd160;//posicion de la segunda fila
	parameter Y2 = 9'd320;//posicion de la tercer fila
	wire [12:0] STATE1,STATE2,STATE3,STATE4,STATE5,STATE6,STATE7,STATE8;
	reg [7:0] COLOUR_DATA1 [0:Gimpy-1];
	reg [7:0] COLOUR_DATA2 [0:Gimpy-1];
	reg [7:0] COLOUR_DATA3 [0:Gimpy-1];
	reg [7:0] COLOUR_DATA4 [0:Gimpy-1];
	reg [7:0] COLOUR_DATA5 [0:Gimpy-1];
	reg [7:0] COLOUR_DATA6 [0:Gimpy-1];
	reg [7:0] COLOUR_DATA7 [0:Gimpy-1];
	reg [7:0] COLOUR_DATA8 [0:Gimpy-1];
	reg [7:0] rg;// registro máscara de la salida de rgb

	//initial
	//$readmemh ("RTC.list", COLOUR_DATA);//Lee la imagen en hexadecimal
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
	
	assign STATE1 = (pixel_x_o-X1)*GimpyXY+pixel_y_o-Y;//Dia
	assign STATE2 = (pixel_x_o-X2)*GimpyXY+pixel_y_o-Y;//Mes
	assign STATE3 = (pixel_x_o-X3)*GimpyXY+pixel_y_o-Y;//Ano
	assign STATE4 = (pixel_x_o-X1)*GimpyXY+pixel_y_o-Y1;//Hora
	assign STATE5 = (pixel_x_o-X2)*GimpyXY+pixel_y_o-Y1;//Min
	assign STATE6 = (pixel_x_o-X3)*GimpyXY+pixel_y_o-Y1;//Seg
	assign STATE7 = (pixel_x_o-X2)*GimpyXY+pixel_y_o-Y2;//Crono
	assign STATE8 = (pixel_x_o-X0)*GimpyXY+pixel_y_o-Y2;//instrucciones
//=======================================
//numeros
//=======================================
  assign fecha =  (pixel_x_o>=192)&&(pixel_x_o<450)&&(pixel_y_o>=96)&&(pixel_y_o<128);
   assign row_addr_s = pixel_y_o[4:1];
   assign bit_addr_s = pixel_x_o[3:1];
   always @* 
      case (pixel_x_o[7:4])
         4'h0: char_addr_s = {3'b011,R_Mes_Fecha[7:4]}; // S
         4'h1: char_addr_s = {3'b011,R_Mes_Fecha[3:0]}; // c
			4'h2: char_addr_s = 7'h00; // a
			4'h3: char_addr_s = 7'h00; // a
			4'h4: char_addr_s = 7'h32; // a
			4'h5: char_addr_s = 7'h30; // a
         4'h6: char_addr_s = {3'b011,R_Ano_Fecha[7:4]}; // digit 10
         4'h7: char_addr_s = {3'b011,R_Ano_Fecha[3:0]};// digit 1
			4'h8: char_addr_s = 7'h00; // a
			4'h9: char_addr_s = 7'h00; // a
			4'ha: char_addr_s = 7'h00; // a
			4'hb: char_addr_s = 7'h00; // a
         4'hc: char_addr_s = {3'b011,R_Dia_Fecha[7:4]};// l
         4'hd: char_addr_s = {3'b011,R_Dia_Fecha[3:0]}; // l
			4'he: char_addr_s = 7'h00; // B
         4'hf: char_addr_s = 7'h00; // a
         
      endcase
//============================
   assign hora = (pixel_x_o>=192)&&(pixel_x_o<450)&&(pixel_y_o>=256)&&(pixel_y_o<288);
	assign row_addr_r = pixel_y_o[4:1];
   assign bit_addr_r = pixel_x_o[3:1];
	
   always @*
      case (pixel_x_o[7:4])
			4'hc: char_addr_r = {3'b011,R_Hora_Hora[7:4]}; // hora
         4'hd: char_addr_r = {3'b011,R_Hora_Hora[3:0]}; // hora
         4'h2: char_addr_r = 7'h00; // 0
         4'h3: char_addr_r = 7'h00; // 0
         4'h4: char_addr_r = 7'h00; // 0
         4'h5: char_addr_r = 7'h00; // 0
         4'h0: char_addr_r = {3'b011,R_Hora_Minutos[7:4]}; // mimutos
         4'h1: char_addr_r = {3'b011,R_Hora_Minutos[3:0]}; // minutos
         4'h8: char_addr_r = 7'h00; //
         4'h9: char_addr_r = 7'h00; //
         4'ha: char_addr_r = 7'h00; // B
         4'hb: char_addr_r = 7'h00; // a
         4'h6: char_addr_r = {3'b011,R_Hora_Segundos[7:4]}; // l
         4'h7: char_addr_r = {3'b011,R_Hora_Segundos[3:0]}; // l
			4'he: char_addr_r = 7'h00;
			4'hf: char_addr_r = 7'h00; // 
 endcase
 //======================================
 assign crono =(pixel_x_o>=192)&&(pixel_x_o<450)&&(pixel_y_o>=416)&&(pixel_y_o<448);

   assign row_addr_g = pixel_y_o[4:1];
   assign bit_addr_g = pixel_x_o[3:1];
	
   always @*
        case (pixel_x_o[7:4])
         4'hc: char_addr_g = {3'b011, R_Cronometro_Hora[7:4]};
         4'hd: char_addr_g = {3'b011, R_Cronometro_Hora[3:0]};
         4'h2: char_addr_g = 7'h00;// C
         4'h3: char_addr_g = 7'h00;// H
         4'h4: char_addr_g = 7'h00;// A
         4'h5: char_addr_g = 7'h00;
         4'h0: char_addr_g = {3'b011, R_Cronometro_Minutos[7:4]}; // digit 10
         4'h1: char_addr_g = {3'b011,R_Cronometro_Minutos[3:0]};// digit 10
         4'h8: char_addr_g = 7'h00;
         4'h9: char_addr_g = 7'h00; 
         4'ha: char_addr_g = 7'h00; 
         4'hb: char_addr_g = 7'h00;
         4'h6: char_addr_g = {3'b011, R_Cronometro_Segundo[7:4]};// digit 10
         4'h7: char_addr_g = {3'b011, R_Cronometro_Segundo[3:0]};// digit 10 
	   	4'he: char_addr_g = 7'h00;
		   4'hf: char_addr_g = 7'h00; // 
			endcase
/*assign Dia_Fecha =(pixel_x_o>=208)&&(pixel_x_o<240)&&(pixel_y_o>=96)&&(pixel_y_o<128);
   assign row_addr_D_F = pixel_y_o[4:1];
   assign bit_addr_D_F = pixel_x_o[3:1];
   always @*
      case(pixel_x_o[7:4])
         4'h1: char_addr_D_F = {3'b011,R_Dia_Fecha[7:4]}; // Decenas dias
			4'h2: char_addr_D_F = {3'b011,R_Dia_Fecha[3:0]};// Unidades dias
      endcase	
assign Mes_Fecha = (pixel_x_o>=288)&&(pixel_x_o<320)&&(pixel_y_o>=96)&&(pixel_y_o<128);//margen + 32
   assign row_addr_M_F = pixel_y_o[4:1];
   assign bit_addr_M_F = pixel_x_o[3:1];
   always @*
      case(pixel_x_o[7:4])
         4'h3: char_addr_M_F = {3'b011,R_Mes_Fecha[7:4]}; // Decenas Mes
         4'h4: char_addr_M_F = {3'b011,R_Mes_Fecha[3:0]}; // Unidades Mes 
      endcase
assign Ano_Fecha =(pixel_x_o>=336)&&(pixel_x_o<400)&&(pixel_y_o>=96)&&(pixel_y_o<128);
   assign row_addr_A_F = pixel_y_o[4:1];
   assign bit_addr_A_F = pixel_x_o[3:1];
   always @*
      case(pixel_x_o[7:4])
			4'h5: char_addr_A_F = 7'h32;//2
			4'h6: char_addr_A_F = 7'h30;//0
         4'h7: char_addr_A_F = {3'b011,R_Ano_Fecha[7:4]}; // Decenas Ano
         4'h8: char_addr_A_F = {3'b011,R_Ano_Fecha[3:0]}; // Unidades Ano
         default: char_addr_A_F = 7'h00; // 
      endcase


assign Hora_H = (pixel_x_o>=208)&&(pixel_x_o<240)&&(pixel_y_o>=256)&&(pixel_y_o<288);
   assign row_addr_H_H = pixel_y_o[4:1];
   assign bit_addr_H_H = pixel_x_o[3:1];
   always @*
      case(pixel_x_o[7:4])
         4'h0: char_addr_H_H = {3'b011,R_Hora_Hora[7:4]}; // Decenas horas
         4'h1: char_addr_H_H = {3'b011,R_Hora_Hora[3:0]}; // Unidades horas
      endcase

assign Hora_M = (pixel_x_o>=272)&&(pixel_x_o<320)&&(pixel_y_o>=256)&&(pixel_y_o<288);
   assign row_addr_H_M = pixel_y_o[4:1];
   assign bit_addr_H_M = pixel_x_o[3:1];
   always @*
      case(pixel_x_o[7:4])
			4'h0: char_addr_H_M = 7'h3a;//:
         4'h1: char_addr_H_M = {3'b011,R_Hora_Minutos[7:4]}; // Decenas minutos
         4'h2: char_addr_H_M = {3'b011,R_Hora_Minutos[3:0]}; // Unidades minutos
         default: char_addr_H_M = 7'h00; // 
      endcase
				
		
assign Hora_S = (pixel_x_o>=336)&&(pixel_x_o<400)&&(pixel_y_o>=256)&&(pixel_y_o<288);
   assign row_addr_H_S = pixel_y_o[4:1];
   assign bit_addr_H_S = pixel_x_o[3:1];
   always @*
      case(pixel_x_o[7:4])
			4'h3: char_addr_H_S = 7'h3a;//:
         4'h4: char_addr_H_S = {3'b011,R_Hora_Segundos[7:4]}; // Decenas segundos
         4'h5: char_addr_H_S = {3'b011,R_Hora_Segundos[3:0]}; // Unidades segundo
         default: char_addr_H_S = 7'h00; // 
      endcase		

assign CRONOMETRO_H = (pixel_x_o>=208)&&(pixel_x_o<240)&&(pixel_y_o>=416)&&(pixel_y_o<448);
   assign row_addr_C_H = pixel_y_o[4:1];
   assign bit_addr_C_H = pixel_x_o[3:1];
   always @*
      case(pixel_x_o[7:4])
			4'h1: char_addr_C_H = {3'b011,R_Cronometro_Hora[7:4]}; // Decenas horas
         4'h0: char_addr_C_H = {3'b011,R_Cronometro_Hora[3:0]}; // Unidades horas
         default: char_addr_C_H = 7'h00; // 
      endcase	
assign CRONOMETRO_M = (pixel_x_o>=272)&&(pixel_x_o<324)&&(pixel_y_o>=416)&&(pixel_y_o<448);
   assign row_addr_C_M = pixel_y_o[4:1];
   assign bit_addr_C_M = pixel_x_o[3:1];
   always @*
      case(pixel_x_o[7:4])
			4'h0: char_addr_C_M = 7'h3a;//:
			4'h1: char_addr_C_M = {3'b011,R_Cronometro_Minutos[7:4]}; // Decenas minutos
         4'h2: char_addr_C_M = {3'b011,R_Cronometro_Minutos[3:0]}; // Unidades minutos
         default: char_addr_C_M = 7'h00; // 
      endcase
assign CRONOMETRO_S = (pixel_x_o>=336)&&(pixel_x_o<400)&&(pixel_y_o>=416)&&(pixel_y_o<448); 
   assign row_addr_C_S = pixel_y_o[4:1];
   assign bit_addr_C_S = pixel_x_o[3:1];
   always @*
      case(pixel_x_o[7:4])
			4'h3: char_addr_C_S = 7'h3a;//:
			4'h4: char_addr_C_S = {3'b011,R_Cronometro_Segundo[7:4]}; // Decenas segundo
         4'h5: char_addr_C_S = {3'b011,R_Cronometro_Segundo[3:0]}; // Unidades segundo
         default: char_addr_C_S = 7'h00; // 
      endcase			
*/
//======================================================================================
//Mux imagenres
	always @*
	begin
		char_addr=7'b0000000;
		row_addr=4'b0000; 
		bit_addr=3'b000;
      rg = 8'b00000000; 
		
		//if (pixel_x_o>=X0 && pixel_x_o<X0+GimpyXY//RTC
			//&& pixel_y_o>=Y && pixel_y_o<Y+GimpyXY)
				//rg = COLOUR_DATA[{STATE}];
		if (pixel_x_o>=X1 && pixel_x_o<X1+GimpyXY//Dia
			&& pixel_y_o>=Y && pixel_y_o<Y+GimpyXY)
				rg = COLOUR_DATA1[{STATE1}];
		else if (pixel_x_o>=X2 && pixel_x_o<X2+GimpyXY//Mes
			&& pixel_y_o>=Y && pixel_y_o<Y+GimpyXY)
				rg = COLOUR_DATA2[{STATE2}];
		else if (pixel_x_o>=X3 && pixel_x_o<X3+GimpyXY//Ano
			&& pixel_y_o>=Y && pixel_y_o<Y+GimpyXY)
				rg = COLOUR_DATA3[{STATE3}];
		else if (pixel_x_o>=X1 && pixel_x_o<X1+GimpyXY//Hora
			&& pixel_y_o>=Y1 && pixel_y_o<Y1+GimpyXY)
				rg = COLOUR_DATA4[{STATE4}];
		else if (pixel_x_o>=X2 && pixel_x_o<X2+GimpyXY//Min
			&& pixel_y_o>=Y1 && pixel_y_o<Y1+GimpyXY)
				rg = COLOUR_DATA5[{STATE5}];
		else if (pixel_x_o>=X3 && pixel_x_o<X3+GimpyXY//Seg
			&& pixel_y_o>=Y1 && pixel_y_o<Y1+GimpyXY)
				rg = COLOUR_DATA6[{STATE6}];
		else if (pixel_x_o>=X2 && pixel_x_o<X2+GimpyXY//Crono
			&& pixel_y_o>=Y2 && pixel_y_o<Y2+GimpyXY)
				rg = COLOUR_DATA7[{STATE7}];
		else if (pixel_x_o>=X0 && pixel_x_o<X0+GimpyXY//instrucciones
			&& pixel_y_o>=Y2 && pixel_y_o<Y2+GimpyXY)
				rg= COLOUR_DATA8[{STATE8}];
/*		else if (Dia_Fecha)
         begin
            char_addr = char_addr_D_F;
            row_addr = row_addr_D_F;
            bit_addr = bit_addr_D_F;
            if (font_bit)
               rg = 8'h11;
         end
		else if (Mes_Fecha)
         begin
            char_addr = char_addr_M_F;
            row_addr = row_addr_M_F;
            bit_addr = bit_addr_M_F;
            if (font_bit)
               rg = 8'h11;
        end
		  	else if (Ano_Fecha)
         begin
            char_addr = char_addr_A_F;
            row_addr = row_addr_A_F;
            bit_addr = bit_addr_A_F;
            if (font_bit)
               rg = 8'h11;
        end
		 else if (Hora_H)
         begin
            char_addr = char_addr_H_H;
            row_addr = row_addr_H_H;
            bit_addr = bit_addr_H_H;
            if (font_bit)
               rg =8'h11;
         end
		 else if (Hora_S)
         begin
            char_addr = char_addr_H_S;
            row_addr = row_addr_H_S;
            bit_addr = bit_addr_H_S;
            if (font_bit)
               rg = 8'h11;
         end
		 else if (Hora_M)
         begin
            char_addr = char_addr_H_M;
            row_addr = row_addr_H_M;
            bit_addr = bit_addr_H_M;
            if (font_bit)
               rg = 8'h11;
         end
	
      else if (CRONOMETRO_H)
         begin
            char_addr = char_addr_C_H;
            row_addr = row_addr_C_H;
            bit_addr = bit_addr_C_H;
            if (font_bit)
               rg = 8'h11;
         end
		else if (CRONOMETRO_M)
         begin
            char_addr = char_addr_C_M;
            row_addr = row_addr_C_M;
            bit_addr = bit_addr_C_M;
            if (font_bit)
               rg =8'h11;
         end
		else if (CRONOMETRO_S)
         begin
            char_addr = char_addr_C_S;
            row_addr = row_addr_C_S;
            bit_addr = bit_addr_C_S;
            if (font_bit)
               rg = 8'h11;
         end*/
			else if (fecha)
         begin
            char_addr = char_addr_s;
            row_addr = row_addr_s;
            bit_addr = bit_addr_s;
            if (font_bit)
               rg = 8'b00000111;
         end

      else if (hora)
         begin
            char_addr = char_addr_r;
            row_addr = row_addr_r;
            bit_addr = bit_addr_r;
            if (font_bit)
               rg = 8'b00000111;
         end
		else if (crono)
         begin
            char_addr = char_addr_g;
            row_addr = row_addr_g;
            bit_addr = bit_addr_g;
            if (font_bit)
               rg = 8'b00000111;
         end
		else
				rg = 8'h10;
				
	end 
assign rom_addr = {char_addr, row_addr};
assign font_bit = font_word[~bit_addr];
assign rgb = rg;

endmodule 