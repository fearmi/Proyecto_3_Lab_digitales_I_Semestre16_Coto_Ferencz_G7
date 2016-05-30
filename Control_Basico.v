`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:23:21 05/23/2016 
// Design Name: 
// Module Name:    Control_Basico 
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
module Control_Basico(
    input Clk,
	 input [7:0]Begin,
    inout [7:0] Data_Bus,
    output AD,CS,RD,WR,HSYNC,VSYNC,
	 output [7:0]RGB
    );
localparam B=8;
reg [B-1:0] Dato,Direccion;
reg [B-1:0]Inicie,CM;
reg [B-1:0] SegR,MinR,HorR,DiaF,MesF,YearF,SegT,MinT,HorT;
wire [B-1:0] datoleer,data_out;
wire WE;

wire ADf,SDF,SAF;
// declaraci�n de se�ales de pico_blaze
wire	[11:0]	address;
wire	[17:0]	instruction;
wire			bram_enable;
wire	[7:0]		port_id;
wire	[7:0]		out_port;
reg	[7:0]		in_port;
wire			write_strobe;
wire			k_write_strobe;
wire			read_strobe;
wire			interrupt;            //See note above
wire			interrupt_ack;
wire		kcpsm6_sleep;         //See note above
wire			kcpsm6_reset;         //See note above


assign kcpsm6_sleep = 1'b0;
assign interrupt = 1'b0;


//instancia bloque de kcpsm6
  kcpsm6 #(
	.interrupt_vector	(12'h3FF),
	.scratch_pad_memory_size(64),
	.hwbuild		(8'h00))
  processor (
	.address 		(address),
	.instruction 	(instruction),
	.bram_enable 	(bram_enable),
	.port_id 		(port_id),
	.write_strobe 	(write_strobe),
	.k_write_strobe 	(k_write_strobe),
	.out_port 		(out_port),
	.read_strobe 	(read_strobe),
	.in_port 		(in_port),
	.interrupt 		(interrupt),
	.interrupt_ack 	(interrupt_ack),
	.reset 		(kcpsm6_reset),
	.sleep		(kcpsm6_sleep),
	.clk 			(Clk)); 

//ahora, la memoria de programa 
//es un punto v generado con archivo .psm y el ejecutable de emsamblador, ademaas de ROM_form.v

  Pico #(
	.C_FAMILY		   ("S6"),   	//Family 'S6' or 'V6', serie 7 para nexys 4
	.C_RAM_SIZE_KWORDS	(2),  	//Program size '1', '2' or '4' tama�o de RAM se puede cambiar segun especificaciones
	.C_JTAG_LOADER_ENABLE	(1))  	//Include JTAG Loader when set to '1' 
  program_rom (    				//Name to match your PSM file
 	.rdl 			(kcpsm6_reset),
	.enable 		(bram_enable),
	.address 		(address),
	.instruction 	(instruction),
	.clk 			(Clk));

wire ADw,CSw,RDw,WRw,SAw,SDw;
wire ADr,CSr,RDr,WRr,SAr,SDr;
// Instantiate the module
Escribir_Escribir Write_Write (
    .Reset(Inicie[3]), 
    .ciclo(Inicie[0]), 
    .Clock_in(Clk), 
    .A_D1(ADw), 
    .CS1(CSw), 
    .WR1(WRw), 
    .RD1(RDw), 
    .Sent_A1(SAw), 
    .Fin1(Fin1), 
    .Sent_D1(SDw)
    );
// Instantiate the module
Write_Read Escribe_Lee(
    .Reset(Inicie[4]), 
    .ciclo(Inicie[1]), 
    .Fin1(Fin1), 
    .Clock_in(Clk), 
    .A_D1(ADr), 
    .CS1(CSr), 
    .WR1(WRr), 
    .RD1(RDr), 
    .Sent_A1(SAr), 
    .Sent_D1(SDr)
    );
Mux_Sig_Control SignalOut (
    .ADR(ADr), 
    .ADW(ADw), 
    .CSR(CSr), 
    .CSW(CSw), 
    .RDR(RDr), 
    .RDW(RDw), 
    .WRR(WRr), 
    .WRW(WRw), 
    .SDR(SDr), 
    .SDW(SDw), 
    .SAR(SAr), 
    .SAW(SAw), 
    .ADf(ADf), 
    .CSf(CS), 
    .RDf(RD), 
    .WRf(WR), 
    .SDF(SDF), 
    .SAF(SAF), 
    .Sel(Inicie[2])
    );

// Instantiate the module
Bus_Datos Bus_Bidireccional (
    .clk(Clk), 
    .leerdato(SDF), 
    .escribirdato(SAF), 
    .AD(ADf), 
    .direccion(Direccion), 
    .datoescribir(Dato), 
    .datoleer(datoleer), 
    .salient(Data_Bus)
    );

// Instantiate the module
Mux_Write_Enable WriteEnable (
    .P(SDF), 
    .P1(CM[0]), 
    .Select(CM[1]), 
    .WE(WE)
    );
// Instantiate the module
regfile Registros (
    .clock(Clk), 
    .address(CM[7:4]), 
    .en_write(WE), 
    .data_in(datoleer), 
    .data_out(data_out)
    );

// Instantiate the module
MainActivity VGA(
    .rgb(RGB), 
    .clk_i(Clk), 
    .reset_i(Inicie[5]), 
    .R_Dia_Fecha(DiaF), 
    .R_Mes_Fecha(MesF), 
    .R_Ano_Fecha(YearF), 
    .R_Hora_Hora(HorR), 
    .R_Hora_Minutos(MinR), 
    .R_Hora_Segundos(SegR), 
    .R_Cronometro_Hora(HorT), 
    .R_Cronometro_Minutos(MinT), 
    .R_Cronometro_Segundo(SegT), 
    .hsync_o(HSYNC), 
    .vsync_o(VSYNC)
    );
//logica para asignar entradas al puerto de entrada
  always @ (posedge Clk)
  begin

      case (port_id[2:0]) 
      
        // Read input_port_a at port address 00 hex
        3'b010 : in_port <= Begin ;// coindice con el archivo psm
        3'b100 : in_port <= data_out ;// coindice con el archivo psm
        default : in_port <= 8'bXXXXXXXX ;  

      endcase

  end
 //logica para asignacion de puertos de salida
  always @ (posedge Clk)
  begin

      // 'write_strobe' is used to qualify all writes to general output ports.
      if (write_strobe == 1'b1) begin

        // Write to output_port_w at port address 00 hex
        if (port_id[B-1:0] == 2'b00) begin // coindice con el archivo psm
         Dato <= out_port;
        end
        // Write to output_port_w at port address 01 hex
        if (port_id[B-1:0] == 2'b01) begin // coindice con el archivo psm
         Direccion <= out_port;
        end
        // Write to output_port_w at port address 03 hex
        if (port_id[B-1:0] == 8'h03) begin // coindice con el archivo psm
         Inicie <= out_port;
        end
        // Write to output_port_w at port address 04 hex		  
        if (port_id[B-1:0] == 8'h04) begin // coindice con el archivo psm
         SegR <= out_port;
        end
        // Write to output_port_w at port address 05 hex
        if (port_id[B-1:0] == 8'h05) begin // coindice con el archivo psm
         MinR <= out_port;
        end
        // Write to output_port_w at port address 06 hex
        if (port_id[B-1:0] == 8'h06) begin // coindice con el archivo psm
         HorR <= out_port;
        end
        // Write to output_port_w at port address 07 hex		  
        if (port_id[B-1:0] == 8'h07) begin // coindice con el archivo psm
         DiaF <= out_port;
        end
        // Write to output_port_w at port address 01 hex
        if (port_id[B-1:0] == 8'h08) begin // coindice con el archivo psm
         MesF <= out_port;
        end
        // Write to output_port_w at port address 01 hex
        if (port_id[B-1:0] == 8'h09) begin // coindice con el archivo psm
         YearF <= out_port;
        end
	        // Write to output_port_w at port address 04 hex		  
        if (port_id[B-1:0] == 8'h0A) begin // coindice con el archivo psm
         SegT <= out_port;
        end
        // Write to output_port_w at port address 01 hex
        if (port_id[B-1:0] == 8'h0B) begin // coindice con el archivo psm
         MinT <= out_port;
        end
        // Write to output_port_w at port address 01 hex
        if (port_id[B-1:0] == 8'h0C) begin // coindice con el archivo psm
         HorT <= out_port;
        end
        // Write to output_port_w at port address 01 hex
        if (port_id[B-1:0] == 8'h0D) begin // coindice con el archivo psm
         CM <= out_port;
        end
  end
end
assign AD = ADf;
endmodule
