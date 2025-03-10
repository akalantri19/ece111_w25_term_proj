module viterbi_tx_rx_2(
   input    clk,
   input    rst,
   input    encoder_i,
   input    enable_encoder_i,
   output   decoder_o);

   wire  [1:0] encoder_o;

   logic   [4:0] error_counter; //uncomment if error injection is 3% or adjacent 6% error or 9% 3-adjacent errors
   //logic   [3:0] error_counter; //uncomment if error injection is 6%
   //logic   [10:0] error_counter; //uncomment if error injection is single error throughout
   logic   [1:0] encoder_o_reg;
   
   logic       enable_decoder_in;
   wire        valid_encoder_o;
	initial begin
		//$display("Error injection once in 32 cycles");
		//$display("Error injection once in 16 cycles");
		//$display("Error injection of two adjacent bits in 32 cycles");
		//$display("Error injection of single bit throughout");
		$display("Error injection of three adjacent bits in 32 cycles");
	end
  
   always @ (posedge clk, negedge rst) 
      if(!rst) begin  
         error_counter  <= 5'd0; //uncomment if error injection is 3% or adjacent 6% error or 9% 3-adjacent errors
		 //error_counter     <= 4'd0; ////uncomment if error injection is 6%
		 error_counter     <= 11'd0; //uncomment if error injection is single error throughout
         encoder_o_reg     <= 2'b00;
         enable_decoder_in <= 1'b0;
      end
      else	   begin
	
         enable_decoder_in <= valid_encoder_o; 
         encoder_o_reg  <= 2'b00;
         error_counter  <= error_counter + 5'd1; //uncomment if error injection is 3% or adjacent 6% error or 9% 3-adjacent errors
		 //error_counter  <= error_counter + 4'd1; //uncomment if error injection is 6%
		 //error_counter  <= error_counter + 11'd1;  //uncomment if error injection is single error throughout
         //if(error_counter==5'b11111) //uncomment if error injection is 3% 
		 //if(error_counter==4'b1111)  //uncomment if error injection is 6%
		 //if(error_counter==5'b11111 || error_counter ==5'b11110) //uncomment if error injection is 6% adjacent bits
		 //if(error_counter==11'b00000001111) //uncomment if error injection is single error throughout @ 16th cycle
		 if(error_counter==5'b11111 || error_counter ==5'b11110 || error_counter ==5'b11101) //uncomment if 3-adjacent error injection in 32 cycles(9%)
            encoder_o_reg  <= {~encoder_o[1],encoder_o[0]};	 
		
         else
            encoder_o_reg  <= {encoder_o[1],encoder_o[0]};
      end   

// insert your convolutional encoder here
// change port names and module name as necessary/desired
   encoder encoder1	     (
      .clk,
      .rst,
      .enable_i(enable_encoder_i),
      .d_in(encoder_i),
      .valid_o(valid_encoder_o),
      .d_out(encoder_o)   );

// insert your term project code here 
   decoder decoder1	     (
      .clk,
      .rst,
      .enable(enable_decoder_in),
      .d_in(encoder_o_reg),
      .d_out(decoder_o)   );

endmodule
