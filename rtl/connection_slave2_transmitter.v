
module connection_slave2_transmitter(
  input [31:0] data_in_s,
  input clk,
  input valid_fsm_s,
  input done,
  input tx_busy,
  input [31:0] addr_s,
  output reg valid = 0,
  output reg [7:0] data_out = 0,
  output reg pready_slave = 0,
  output reg [31:0] addr_out = 0
    );
   reg [3:0] counter = 0;
   
   reg [1:0] state = 0;
   
   reg r_check_last = 0;
   
    always @(posedge clk) begin
      case(state)
        //  0: begin
        //     valid <= 1'b0;
        //     //data_out <= 8'd0;
        //     pready_slave <= 1'b0;
        //     if (valid_fsm_s) begin
        //       valid <= 1'b1;
        //       addr_out <= addr_s;
        //       if(counter < 3)begin
        //         data_out <= data_in_s[32-(counter*8)-1 -:8];
        //         counter <= counter+1;
        //         state <= 0;
        //       end else begin
        //         data_out <= data_in_s[32-(counter*8)-1 -:8];
        //         r_check_last <= 1'b1;
        //         counter <= 0;
        //         state <= 1;
        //       end 
        //     end 
        //  end
        //  1: begin
        //     valid <= 0;      
        //     if (done) begin ///////(~tx_busy)
        //         if (r_check_last) begin
        //             state <= 2;
        //             pready_slave <= 1;
        //         end else
        //             state <= 0;
        //     end
        //  end
         
        //  2: begin
        //     r_check_last <= 0;
        //     state <= 0;
        //     pready_slave <= 0;
        //  end

        0: begin
          valid <= 1'b0;
          pready_slave <= 1'b0;
          if(valid_fsm_s) begin
            state <= 1;
          end
          else begin
            state <= 0;
          end
        end

        1: begin
          addr_out <= addr_s;
          if(counter < 3) begin
            data_out <= data_in_s[32-(counter*8)-1 -:8];
            counter <= counter+1; 
            valid <= 1'b1;
            state <= 2;
          end
          else begin
            data_out <= data_in_s[32-(counter*8)-1 -:8];
            counter <= 0; 
            state <= 0;
          end
        end

        2: begin
          valid <= 1'b0;
          if(done) begin
            pready_slave <= 1'b1;
            state <= 1;
          end
          else begin
            state <= 2;
            pready_slave <= 1'b0;
          end
        end

       endcase      
    end
endmodule