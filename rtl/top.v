`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.10.2023 15:33:47
// Design Name: 
// Module Name: top
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



module top(
  input clk,
  input din_rx,
  output dout_tx_s1,
  output dout_tx_s2,
  output [31:0] addr_tx_s1,
  output [31:0] addr_tx_s2
    );
  wire [7:0] dout_rx;
  wire valid_rx;
  wire [1:0] sel;
  wire [31:0] data;
  wire [31:0] addr_rx;
  wire en;
  wire valid_master;
  wire penable;
  wire pwrite_slave;
  wire pready_fsm;
  wire [1:0] psel_slave;
  wire pready_master;
  wire valid_slave;
  wire [31:0] addr_slave;
  wire test_valid;
  wire [31:0] din_tx;
  wire [31:0] data_fsm1;
  wire [31:0] data_fsm2;
  wire valid_fsm_s1;
  wire valid_fsm_s2;
  wire valid_tx;
  wire [7:0] data_tx;
  wire dout_tx_in;
  wire done;
  wire [31:0] addr_fsm1;
  wire [31:0] addr_fsm2;
  wire tx_busy;
  wire [65:0] psel_slave1;
  wire [65:0] psel_slave2;
  wire valid_tx2;
  wire [7:0] data_tx2;
  wire done2;
  wire tx_busy2;
  wire pready_fsm2;
  wire pready_fsm1;
  wire pready_fsm_mas;
    
  receiver dut0(
  .clk(clk),
  .din(din_rx),
  .dout(dout_rx),
  .valid(valid_rx)
  );
  
  connection_receiver_master dut1(
  .clk(clk),
  .valid_tx(valid_rx),
  .dout(dout_rx),
  .pselx_m(sel),
  .pwdata_m(data),
  .paddr_m(addr_rx),
  .pwrite_m(en),
  .pready(pready_fsm),
  .valid(valid_master)
  );
  
  apb_master dut2(
  .pclk(clk),
  .pwrite_m(en),
  .pwdata_m(data),
  .paddr_m(addr_rx),
  .pselx_m(sel),
  .pready(pready_fsm_mas),
  .valid(valid_master),
  .pwrite_s(pwrite_slave),
  .pselx_s(psel_slave),
  .penable(penable),
  .paddr_s(addr_slave),
  .pwdata_s(din_tx)
  );
  
  demux_slave dut3(
  .clk(clk),
  .sel(psel_slave),
  .data(din_tx),
  .addr(addr_slave),
  .psel_s1(psel_slave1),
  .psel_s2(psel_slave2)
  );
  
  mux_pready dut4(
  .sel(psel_slave),
  .pready(pready_fsm_mas),
  .pready_mas1(pready_fsm1),
  .pready_mas2(pready_fsm2)
  );
    
  slave dut5 (
  .penable(penable),
  .pwdata_in(psel_slave1[65:34]),
  .clk(clk),
  .addr(psel_slave1[31:0]),
  .psel(psel_slave1[33:32]),
  .pready_tr_in(),
  .pwdata_out(data_fsm1),
  .valid_fsm(valid_fsm_s1),
  .pready_out(),
  .pwrite(pwrite_slave),
  .addr_out(addr_fsm1)
  );
  
  slave dut6 (
  .penable(penable),
  .pwdata_in(psel_slave2[65:34]),
  .clk(clk),
  .addr(psel_slave2[31:0]),
  .psel(psel_slave2[33:32]),
  .pready_tr_in(),
  .pwdata_out(data_fsm2),
  .valid_fsm(valid_fsm_s2),
  .pready_out(),
  .pwrite(pwrite_slave),
  .addr_out(addr_fsm2)
  );
    
  connection_slave2_transmitter dut7(
  .data_in_s(data_fsm1),
  .clk(clk),
  .addr_s(addr_fsm1),
  .valid_fsm_s(valid_fsm_s1),
  .valid(valid_tx),
  .data_out(data_tx),
  .done(done),
  .addr_out(addr_tx_s1),
  .tx_busy(tx_busy),
  .pready_slave(pready_fsm1)
    );
    
  connection_slave2_transmitter dut8(
  .data_in_s(data_fsm2),
  .clk(clk),
  .addr_s(addr_fsm2),
  .valid_fsm_s(valid_fsm_s2),
  .valid(valid_tx2),
  .data_out(data_tx2),
  .done(done2),
  .addr_out(addr_tx_s2),
  .tx_busy(tx_busy2),
  .pready_slave(pready_fsm2)
    );    
  
  transmitter dut9(
  .clk(clk),
  .valid(valid_tx),
  .din(data_tx),
  .dout(dout_tx_s1),
  .valid_test(),
  .tx_busy(tx_busy),
  .done(done)
  );
  
  transmitter dut10(
  .clk(clk),
  .valid(valid_tx2),
  .din(data_tx2),
  .dout(dout_tx_s2),
  .valid_test(),
  .tx_busy(tx_busy2),
  .done(done2)
  );
      
endmodule