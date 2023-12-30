`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.10.2023 16:34:25
// Design Name: 
// Module Name: receiver
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


module receiver #(parameter clks_per_bit = 50)(
  input clk,
  input din,
  output reg [7:0] dout = 0,
  output reg valid = 0
    );
  reg [3:0] state = 0;
  reg [13:0] counter1 = 0;
  reg [3:0] counter2 = 0;
  
  parameter IDLE = 3'b000;
  parameter START_BIT = 3'b001;
  parameter DATA_BIT = 3'b010;
  parameter STOP_BIT = 3'b011;
  
  always @(posedge clk) begin
  case(state)
  IDLE: begin
    counter1 <= 0;
    counter2 <= 0;
    valid <= 1'b0;
    if(din == 1'b0) begin
      state <= START_BIT;
    end
    else begin
      state <= IDLE;
    end  
  end
  START_BIT: begin
    if(counter1 < clks_per_bit/2) begin
      counter1 <= counter1+1;
      state <= START_BIT; 
    end
    else begin
      counter1 <= 0;
      state <= DATA_BIT;
    end
  end
  DATA_BIT: begin
    if(counter1 <= clks_per_bit)begin
      counter1 <= counter1+1;
      state <= DATA_BIT;
    end
    else begin
      counter1 <= 0;
      if(counter2 <= 4'b0111)begin
        dout[counter2] <= din;
        counter2 <= counter2+1;
      end
      else begin
        counter2 <= 0;
        state <= STOP_BIT;
      end
    end
  end
  STOP_BIT: begin
  if (din == 1'b1) begin
    if(counter1 <= clks_per_bit)begin
      valid <= 1'b0;
      counter1 <= counter1+1;
      state <= STOP_BIT;
    end
    else begin
      valid <= 1'b1;
      state <= IDLE;
    end
  end
  else begin
    //valid <= 1'b0;
    state <= STOP_BIT;
  end
 end 
  endcase
  end  
endmodule
