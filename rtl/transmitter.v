`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.10.2023 09:12:55
// Design Name: 
// Module Name: transmitter
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


module transmitter #(parameter clks_per_bit = 50)(
  input clk,
  input valid,
  input [7:0] din,
  output reg dout = 0,
  output reg done = 0,
  output reg tx_busy = 0,
  output reg valid_test = 0
    );
  reg [3:0] state = 0;
  reg [13:0] counter1 = 0;
  reg [3:0] counter2 = 0;
  reg [7:0] r_din = 0;
  
  parameter IDLE = 3'b000;
  parameter START_BIT = 3'b001;
  parameter DATA_BIT = 3'b010;
  parameter STOP_BIT = 3'b011;
  
  
  always @(posedge clk) begin
//    if(~rst) begin
    //state = IDLE;   
//    end
//    else begin
//       done = 1'b0;
//    end
    case (state)
    IDLE: begin
      counter2 <= 0;
      dout <= 1'b1;
      counter1 <= 0;
      done <= 0;
      valid_test = 0;
        if(valid) begin 
          state <= START_BIT;
          r_din <= din;
          tx_busy <= 1;
        end
        else begin
          state <= IDLE;
        end 
    end   
    START_BIT: begin
      if(counter1 <= clks_per_bit-1) begin
        counter1 <= counter1 + 1;
        state <= START_BIT;
      end
      else begin
        dout <= 1'b0;
        counter1 <= 0;
        state <= DATA_BIT;
      end
    end
    DATA_BIT: begin
      if(counter1 <= clks_per_bit-1) begin
        counter1 <= counter1 + 1;
        state <= DATA_BIT; 
      end 
      else begin
        counter1 <= 0;
        if(counter2 <= 4'b0111) begin
            dout <= r_din[counter2];
            counter2 <= counter2 + 1;
            state <= DATA_BIT;
          end 
          else begin
            counter2 <= 0;
            state <= STOP_BIT;
          end
      end        
    end    
    STOP_BIT: begin
      if(counter1 <= clks_per_bit-1) begin
        dout <= 1'b1;
        counter1 <= counter1 + 1;
        done <= 1'b0;/////////////////
        state <= STOP_BIT;
      end
      else begin
        counter1 <= 0;
        done <= 1'b1;/////////////////
        state <= IDLE;
        tx_busy <= 0;
      end
    end
    endcase  
  end  
endmodule
