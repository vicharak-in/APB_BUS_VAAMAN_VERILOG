
module slave(
input penable,
input [31:0] pwdata_in,
input clk,
input [1:0] psel,
input pready_tr_in,
input pwrite,
input [31:0] addr,
output reg [31:0] pwdata_out = 0,
output reg valid_fsm = 0,
output reg pready_out = 0,
output reg [31:0] addr_out = 0
);

reg [1:0] state;

  parameter IDLE = 2'b00;
  parameter NEXT = 2'b01;
  parameter WAIT_FOR_COMPLETION = 2'b10;
  parameter CLEANUP = 2'b11;
  
always @(posedge clk) begin
  case (state) 
  IDLE: begin
    pwdata_out <= 0;
    valid_fsm <= 0;
    pready_out <= 0;
    addr_out <= 0; 
      if(penable == 1'b1) begin
        state <= NEXT;
      end
   end   
  NEXT: begin   
        //if(psel == 2'b01) begin
          if(pwrite == 1'b1) begin
            pwdata_out <= pwdata_in;
            addr_out <= addr;
            valid_fsm <= 1'b1;
            pready_out <= 1'b1; //pready_tr_in;
            state <= WAIT_FOR_COMPLETION;
          end  
        //end 
  end
    
  WAIT_FOR_COMPLETION: begin
        if (pready_out)
          state <= CLEANUP;  
  end
    
  CLEANUP: begin
     valid_fsm <= 1'b0;
     pready_out <= 0;
     state <= IDLE;
  end
  endcase
end    
endmodule