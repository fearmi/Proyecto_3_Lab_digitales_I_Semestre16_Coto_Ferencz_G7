`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:25:57 05/31/2016 
// Design Name: 
// Module Name:    PS2 
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
//Listing 9.3
module PS2
    // 2^W_SIZE words in FIFO
   (
    input wire clk, reset, 
	 input wire [7:0]var,
    input wire ps2d, ps2c,
    output reg [7:0] key_code,
	 output reg [7:0]listo
   );
	
	
	//reg listo1;
	//reg [7:0] key_code1;
	//assign key_code =  key_code1;
	//assign listo = listo1;
   // constant declaration
   localparam BRK = 8'hf0; // break code

   // symbolic state declaration
   localparam
      wait_brk = 2'b00,
      get_code = 2'b01,
		espere_code = 2'b10;

   // signal declaration
   reg [1:0] state_reg, state_next;
   wire [7:0] scan_out;
   reg got_code_tick;
   wire scan_done_tick, rx_en;

   // body
   //====================================================
   // instantiation
   //====================================================
   // instantiate ps2 receiver
   ps2_rx ps2_rx_unit
      (.clk(clk), .reset(reset), .rx_en(1'b1),
       .ps2d(ps2d), .ps2c(ps2c),
       .rx_done_tick(scan_done_tick), .dout(scan_out));
		 
  always @(posedge clk)
      if (got_code_tick)
        key_code <= 8'h00;
      else
         key_code <= scan_out;

   //=======================================================
   // FSM to get the scan code after F0 received
   //=======================================================
   // state registers
   always @(posedge clk, posedge reset)
      if (reset)
         state_reg <= wait_brk;
      else
         state_reg <= state_next;

   // next-state logic
   always @*
   begin
   got_code_tick = 1'b0;
   state_next = state_reg;
	listo=1'b0;


    case (state_reg)
       wait_brk:  // wait for F0 of break code
           if (scan_done_tick==1'b1 && scan_out==BRK)
			  
               state_next = get_code;
		 
       get_code:  // get the following scan code

           if (scan_done_tick)
              begin
                  got_code_tick =1'b1;
						listo = 1'b1;
                  state_next = espere_code;
					end
		espere_code:
	   if (var==8'h01)
			  begin
		         listo = 1'b0;
					state_next = wait_brk;
			  end
		else begin
				listo=8'h01;
			  state_next = espere_code;
    end
	 endcase
   end	
endmodule
