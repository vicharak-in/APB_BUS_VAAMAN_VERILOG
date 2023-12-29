`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.10.2023 12:39:33
// Design Name: 
// Module Name: connection_receiver_master
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module connection_receiver_master(
  input clk,
  input valid_tx,
  input [7:0] dout,
  input pready,
  output reg [1:0] pselx_m = 0,
  output reg [31:0] pwdata_m = 0,
  output reg [31:0] paddr_m = 0,
  output reg pwrite_m = 0,
  output reg valid = 0
    );
 
  reg [2:0] state = 0;
  reg [2:0] count1 = 0;
  reg [2:0] count2 = 0;
    
  parameter IDLE = 3'b000;
  parameter SEL = 3'b001;
  parameter WR_EN = 3'b010;
  parameter DATA = 3'b011;
  parameter ADDR = 3'b100;
  parameter WAIT = 3'b101;
  
  
always @(posedge clk) begin
case(state)
IDLE: begin
  pselx_m <= 0;
  pwdata_m <= 0;
  paddr_m <= 0;
  pwrite_m <= 0;
  valid <= 0;
  count1 <= 0;
  count2 <= 0; 
  state <= SEL;           
end

SEL: begin
  if(valid_tx == 1'b1) begin
    pselx_m <= dout[1:0];
    state <= WR_EN;
  end
  else
    state <= SEL;
end

WR_EN: begin
  if(valid_tx == 1'b1)begin
    pwrite_m <= dout[0];
    state <= DATA; 
  end
  else
    state <= WR_EN;  
end

DATA: begin
  if(valid_tx == 1'b1) begin 
    if(count1 < 3)begin
      pwdata_m[32-(count1*8)-1 -:8] <= dout;
      count1 <= count1+1;
      state <= DATA;  
    end else begin
      pwdata_m[32-(count1*8)-1 -:8] <= dout;
      count1 <= 0;
      state <= ADDR;  
    end
  end
end

ADDR: begin
  if(valid_tx == 1'b1) begin
   // paddr_m <= dout;
    if(count2 < 3)begin
      paddr_m[32-(count2*8)-1 -:8] <= dout;
      count2 <= count2+1; 
      state <= ADDR;
      valid <= 1'b0;
    end else begin
      paddr_m[32-(count2*8)-1 -:8] <= dout;
      count2 <= 0;
      valid <= 1'b1;
      state <= WAIT;      
    end
  end 
 end

WAIT: begin
    valid <= 0;
    if(pready) begin
      state <= IDLE;
    end
end 
  //else
    //state <= IDLE;
    //valid <= 1'b1;
//end
endcase
end   
    
endmodule
