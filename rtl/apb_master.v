`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.10.2023 14:32:03
      
// Design Name: 
// Module Name: apb_master
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


module apb_master(
  input pclk,
  input prst,
  input pwrite_m,
  input [31:0] pwdata_m,
  input [31:0] paddr_m,
  input [1:0] pselx_m,
  //input pready_s1,
  //input pready_s2,
  input pready, //_s2,
  input valid,
  output pwrite_s,
  output [1:0] pselx_s,
  output reg penable = 0,
  output [31:0] paddr_s,
  output [31:0] pwdata_s
    );
    
  reg [31:0] paddr_reg=0;
  reg pwrite_reg=0;
  reg [31:0] pwdata_reg=0;
  reg [1:0] pselx_reg=0;
  
  parameter IDLE = 2'b00;
  parameter SETUP = 2'b01;
  parameter ACCESS = 2'b10;
    
  reg [1:0] state = 2'b00;

always @(posedge pclk) begin
case(state)
IDLE: begin
  pselx_reg <= 0;
  penable <= 0;
    if(valid)begin
      state <= SETUP;
    end
    else
    state <= IDLE;
end

SETUP: begin
  pselx_reg <= pselx_m;
  penable <= 1'b0;
  state <= ACCESS;
end

ACCESS: begin
 /*   if(pready_s1) begino
     state <= IDLE;
    end
    else if ((pready_s1 == 1) && (valid == 1)) begin
      state <= SETUP;
    end else if (pready_s2) begin
      state <= IDLE;
    end else if ((pready_s2 == 1) && (valid == 1)) begin
      state <= SETUP;
    end */
    penable <= 1'b1;
    if(pwrite_m == 1) begin   
      paddr_reg <= paddr_m;
      pwrite_reg <= pwrite_m;
      pwdata_reg <= pwdata_m;
    end
    if(pready) begin
     state <= IDLE;
     penable <= 1'b0;
    end
    else begin
      state <= ACCESS;
    end
   /* else if (pready_s2) begin
      penable <= 0;
      state <= IDLE;
    end
    else
    state <= ACCESS;
    else if ((pready == 1) && (valid == 1)) begin
      state <= SETUP;
    end */
end
endcase
end

  assign paddr_s = paddr_reg;
  assign pwrite_s = pwrite_reg;
  assign pwdata_s = pwdata_reg;
  assign pselx_s = pselx_reg;
     
endmodule
