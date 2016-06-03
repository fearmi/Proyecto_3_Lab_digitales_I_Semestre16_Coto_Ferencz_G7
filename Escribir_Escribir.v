`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:25:50 04/14/2016 
// Design Name: 
// Module Name:    Escribir_Escribir 
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
module Escribir_Escribir(
     input Reset,
     input ciclo,
    input Clock_in, //señal de reloj 100MHz
    output  A_D1, //Señal de control de A/D (dirección/dato)
    output   CS1, // Habilitador de V3023
    output  WR1, //Write en RAM
    output  RD1, // Read en RAM
    output   Sent_A1, output Fin1, //Leer dato
    output   Sent_D1 //escribir dirección o dato
    );
	 
localparam B=7;
wire [B-1:0] t;

reg A_D,CS,WR,RD,Sent_A,Sent_D,Fin;
// Instantiate the module

Timer Generador_Pulsos(
    .clock(Clock_in), 
    .reset(Reset), 
    .pulse(t)
    );
     
localparam [3:0] a = 4'd0,
                      b = 4'd1,
                      c = 4'd2,
                      d = 4'd3,
                      e = 4'd4,
                      f = 4'd5,
                      g = 4'd6,
                      h = 4'd7,
                      i = 4'd8,
                      j = 4'd9,
                      k = 4'd10,
                      l = 4'd11,
                      m = 4'd12,
							 n = 4'd13;
                      
reg [3:0] state_reg, state_next;

always @(posedge Clock_in) 

    if (Reset)
        state_reg <= a;
    else 
        state_reg <= state_next;
        

//lógica de estado siguiente
always @*
begin
    state_next=state_reg;
    RD = 1'b1;
    WR = 1'b1;
    CS = 1'b1;
    A_D = 1'b1;
    Sent_A = 1'b0;
    Sent_D = 1'b0;
	 Fin = 1'b0;
    
    case (state_reg)
        a: begin
            if (ciclo) 
                state_next = b;  
                 
            else 
                state_next = a; 
                
            end
        b: begin
            if (t==7'd2) begin //bajo A/D
                state_next = c;
                //CS = 1'b1;
                //WR = 1'b1;
                //Sent_A = 1'b0;
                //Sent_D = 1'b0;
                A_D = 1'b0; end
            else 
                state_next = b; 
            end
        c: begin
            if (t==7'd5) begin //bajo CS y WR
                state_next = d;
                //Sent_A = 1'b1;
                //Sent_D = 1'b0;
                CS = 1'b0;
                A_D = 1'b0;
                WR = 1'b0; end
            else begin
                state_next = c; A_D = 1'b0; end
            end
            
        d: begin
            if (t==7'd11) begin //habilito el envio del dato
                state_next = e;
                CS = 1'b0;
                //Sent_1'b0;
                A_D = 1'b0;
                WR = 1'b0;
               Sent_A = 1'b1; end
            else begin
                state_next = d;
                CS = 1'b0;
                WR = 1'b0;
                A_D = 1'b0; end
            end    
        e: begin
            if (t==7'd20)begin // pongo AD en alto
                state_next = f;CS = 1'b1;
                WR = 1'b1;Sent_A = 1'b1; A_D = 1'b0;end
                
                
            else begin
                state_next = e;
                
                A_D= 1'b0;
                CS = 1'b0;
                WR = 1'b0;Sent_A = 1'b1;end
                
            end
        f: begin
            if (t==7'd22) begin
                state_next = g; Sent_A = 1'b1; A_D= 1'b0;end
            else begin
                state_next = f;
                A_D=1'b0;
                Sent_A = 1'b1;end
            end
        g:begin
            if (t==7'd23) begin
                state_next = h; Sent_A = 1'b0; end
                
            else begin
                state_next = g ; Sent_A = 1'b1;A_D=1'b0;end
            end
        h: begin
            if (t==7'd38) 
                state_next = i;
            else 
                state_next = h; 
                
            end
        i: begin
            if (t==7'd40)  begin
                state_next = j; CS = 1'b0; WR = 1'b0; end 
            else 
                state_next = i; 
            end
        j: begin
            if (t==7'd47) begin
                state_next = k;
                Sent_D = 1'b1;
                CS = 1'b0;
                
                WR = 1'b0; end
            else begin
                state_next = j;CS = 1'b0; WR = 1'b0; end 
            end
            
        k: begin
            if (t==7'd53) begin
                state_next = l;
                CS = 1'b1;
                //Sent_1'b0;
                
                WR = 1'b1;
               Sent_D = 1'b1; end
            else begin
                state_next = k;
                
                Sent_D=1'b1;
                CS = 1'b0;
                WR = 1'b0;
                 end
            end    
        l: begin
            if (t==7'd56)begin
                state_next = m;CS = 1'b1;
                WR = 1'b1;Sent_D = 1'b1; end
                
                
            else begin
                state_next = l;
                CS = 1'b1;
                WR = 1'b1;Sent_D = 1'b1;end
                
            end
        m: begin
            if (t==7'd57) begin
                state_next = n;Sent_D = 1'b0;end 
            else begin
                state_next = m;
                Sent_D = 1'b1;end
            end
		 n: begin
            if (t==7'd127) begin
                state_next = a; Fin = 1'b1;  end
            else 
                state_next = n;
              
            end
        default : state_next = a;
    endcase
end
assign A_D1 = A_D;
assign CS1 = CS, RD1 = RD , WR1 = WR, Sent_A1 = Sent_A, Sent_D1 = Sent_D,Fin1 = Fin ;
endmodule



