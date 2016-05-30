`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:18:56 03/31/2016 
// Design Name: 
// Module Name:    Write_Read 
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
module Write_Read(
     input Reset,
     input ciclo,
	  output Fin1,
    input Clock_in, //señal de reloj 100MHz
    output  A_D1, //Señal de control de A/D (dirección/dato)
    output   CS1, // Habilitador de V3023
    output  WR1, //Write en RAM
    output  RD1, // Read en RAM
    output   Sent_A1, //enviar  direccion
    output   Sent_D1 //leer dato
    );

wire [6:0] t;
reg reset_t;
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
            if (ciclo) begin
                state_next = b; reset_t=1'b0; end
                 
            else begin
                state_next = a; reset_t=1'b1; end
                
            end
        b: begin
            if (t==7'd2) begin //bajo AD
                state_next = c;
                //CS = 1'b1;
                //WR = 1'b1;
                //Sent_A = 1'b0;
                //Sent_D = 1'b0;
                A_D = 1'b0; end
            else begin
                state_next = b; reset_t = 1'b0;end
            end
        c: begin
            if (t==7'd5) begin //bajo el write y el chip select
                state_next = d;
                //Sent_A = 1'b1;
                //Sent_D = 1'b0;
                CS = 1'b0;
                A_D = 1'b0;
                WR = 1'b0; end
            else begin
                state_next = c; A_D = 1'b0; reset_t=1'b0; end
            end
            
        d: begin
            if (t==7'd11) begin //habilito el dato, le doy 60ns para que pueda accesar a la memoria
                state_next = e;
                CS = 1'b0;
                
                A_D = 1'b0;
                WR = 1'b0;
					 Sent_A = 1'b1; end
            else begin
                state_next = d;
                reset_t = 1'b0;
                CS = 1'b0;
                WR = 1'b0;
                A_D = 1'b0; end
            end    
        e: begin
            if (t==7'd20)begin // subo Chip select y write
                state_next = f;CS = 1'b1;A_D = 1'b0;
                WR = 1'b1;Sent_A = 1'b1; end
                
                
            else begin
                state_next = e;
                reset_t=1'b0;
                A_D= 1'b0;
                CS = 1'b0;
                WR = 1'b0;Sent_A = 1'b1;end
                
            end
        f: begin
            if (t==7'd22) begin //subo el A/D
                state_next = g; Sent_A = 1'b1; A_D=1'b0; end
            else begin
                state_next = f;
                A_D=1'b0;
                CS=1'b1;
                WR=1'b1;
                Sent_A = 1'b1;end
            end
        g:begin //deshabilito el dato
            if (t==7'd24)
                state_next = h;
                
            else begin
                state_next = g ; reset_t = 1'b0; Sent_A = 1'b1; A_D=1'b0;end
            end
        h: begin
            if (t==7'd38) 
                state_next = i;
            else begin
                state_next = h; 
                reset_t = 1'b0; end
            end
        i: begin
            if (t==7'd40) begin
                state_next = j;
                //CS = 1'b1;
                //WR = 1'b1;
                //Sent_A = 1'b0;
                //Sent_D = 1'b0;
                A_D = 1'b1; end
            else begin
                state_next = i; reset_t = 1'b0;end
            end
        j: begin
            if (t==7'd42) begin //bajo el RD y el Chip Select
                state_next = k;
                //Sent_A = 1'b0;
                //Sent_D = 1'b1;
                CS = 1'b0;
                A_D = 1'b1;
                RD = 1'b0; end
            else begin
                state_next = j; A_D = 1'b1; reset_t=1'b0; end
            end
            
        k: begin
            if (t==7'd49) begin //le doy 60 ns para acceder a la memoria
                state_next = l;
                CS = 1'b0;
                //Sent_1'b0;
               // A_D = 1'b0;
                RD = 1'b0;
					 Sent_D = 1'b1; end
            else begin
                state_next = k;
                reset_t = 1'b0;
                CS = 1'b0;
                RD = 1'b0;
               // A_D = 1'b0; 
					 end
            end    
        l: begin
            if (t==7'd57)begin
                state_next = m;CS = 1'b1;
                RD = 1'b1;Sent_D = 1'b1; end
                
                
            else begin
                state_next = l;
                reset_t=1'b0;
                
                CS = 1'b0;
                RD = 1'b0;Sent_D = 1'b1;end
                
            end
        m: begin
            if (t==7'd61) // deshabilito el dato
                state_next = n; 
            else begin
                state_next = m;
                reset_t=1'b0;
                
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
