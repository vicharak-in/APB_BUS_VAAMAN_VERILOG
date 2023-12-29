module demux_slave(
  input clk,
  input [1:0] sel,
  input [31:0] data,
  input [31:0] addr,
  output [65:0] psel_s1,
  output [65:0] psel_s2
);

assign psel_s1 = (sel == 2'b10)? {data, sel, addr} : 66'd0;
assign psel_s2 = (sel == 2'b01)? {data, sel, addr} : 66'd0;

endmodule