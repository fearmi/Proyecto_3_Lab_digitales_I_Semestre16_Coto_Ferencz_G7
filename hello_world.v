`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:43:34 05/04/2016 
// Design Name: 
// Module Name:    hello_world 
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
module hello_world(
    input wire clk, //entrada de clock
    output reg [7:0] Seg, //salida a 7 segmentos
	 output  [7:0] An,
    input wire [7:0] Switch_port // entrada de interruptores
    );
// declaración de señales de pico_blaze
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
assign An = 8'hFE;

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
	.clk 			(clk)); 

//ahora, la memoria de programa 
//es un punto v generado con archivo .psm y el ejecutable de emsamblador, ademaas de ROM_form.v

  seg #(
	.C_FAMILY		   ("7S"),   	//Family 'S6' or 'V6', serie 7 para nexys 4
	.C_RAM_SIZE_KWORDS	(2),  	//Program size '1', '2' or '4' tamaño de RAM se puede cambiar segun especificaciones
	.C_JTAG_LOADER_ENABLE	(1))  	//Include JTAG Loader when set to '1' 
  program_rom (    				//Name to match your PSM file
 	.rdl 			(kcpsm6_reset),
	.enable 		(bram_enable),
	.address 		(address),
	.instruction 	(instruction),
	.clk 			(clk));
	
//logica para asignar entradas al puerto de entrada
  always @ (posedge clk)
  begin

      case (port_id[1:0]) 
      
        // Read input_port_a at port address 00 hex
        2'b00 : in_port <= Switch_port;// coindice con el archivo psm

        default : in_port <= 8'bXXXXXXXX ;  

      endcase

  end
 //logica para asignacion de puertos de salida
  always @ (posedge clk)
  begin

      // 'write_strobe' is used to qualify all writes to general output ports.
      if (write_strobe == 1'b1) begin

        // Write to output_port_w at port address 01 hex
        if (port_id[1:0] == 2'b01) begin // coindice con el archivo psm
         Seg <= out_port;
        end
  end
  end
endmodule
