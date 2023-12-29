module mux_pready(
  input clk,
  input [1:0] sel,
  input pready_mas1,
  input pready_mas2,
  output reg pready = 0
  );
  
  always @(posedge clk) begin
    if (sel == 2'b10)
        pready <= pready_mas1;
    else
        pready <= pready_mas2;
  end
  
  endmodule
    
    