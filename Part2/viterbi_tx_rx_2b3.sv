module viterbi_tx_rx_2b3 #(parameter N=4, parameter BURST_LEN=1) (
   input    clk,
   input    rst,
   input    encoder_i,
   input    enable_encoder_i,
   output   decoder_o);

   wire  [1:0] encoder_o;
   int           error_counter,
                 error_counterQ,
                 bad_bit_ct,
                 word_ct,
                 err_trig;
   logic   [1:0] encoder_o_reg0,
                 encoder_o_reg;
   logic         encoder_i_reg;
   logic         enable_decoder_in;
   logic         enable_encoder_i_reg;
   wire          valid_encoder_o;
   logic   [1:0] err_inj;
   logic         ERROR_INJECT_FLAG;
   int           err_burst_counter;

   always @ (posedge clk, negedge rst) 
      if(!rst) begin  
	  $display("viterbi_tx_rx2b3.sv");
         error_counter        <= 'd0;
         encoder_o_reg        <= 'b0;		 
		   encoder_o_reg0       <= 'b0;
         enable_decoder_in    <= 'b0;
		   enable_encoder_i_reg <= 'b0;
		   word_ct              <= 'b0;
         ERROR_INJECT_FLAG   <= 'b0;
         err_burst_counter     <= 'b0;
      end else begin 
         enable_encoder_i_reg <= enable_encoder_i;  
         enable_decoder_in    <= valid_encoder_o; 
         word_ct              <= word_ct + 1;			
         encoder_i_reg     <= encoder_i;
         encoder_o_reg0    <= encoder_o;
         err_trig <= $random;

         if((word_ct<256) && (err_trig[N-1:0]== '1) && !ERROR_INJECT_FLAG) begin
         ERROR_INJECT_FLAG <= 1'b1;
         err_burst_counter <= 'd0;
         
         end
         if(ERROR_INJECT_FLAG)begin
         error_counter <= error_counter + 1; // inject error
         err_inj <= 2'b11;
         encoder_o_reg  <= encoder_o^err_inj;
         err_burst_counter <= err_burst_counter + 1;
         if(err_burst_counter >= BURST_LEN-1) ERROR_INJECT_FLAG <= 1'b0;

         end else begin
            encoder_o_reg  <= encoder_o;
            err_inj        <= 2'b0;
         end

        if(word_ct<256) begin
          bad_bit_ct  <= bad_bit_ct + (encoder_o_reg0[1]^encoder_o_reg[1])
		                      + (encoder_o_reg0[0]^encoder_o_reg[0]);
		  $display("error_counter,err_inj = %h %b %d %d",
		         error_counter,err_inj,bad_bit_ct,word_ct);
        end
      end   

   encoder2 encoder1	     (
      .clk,
      .rst,
      .enable_i(enable_encoder_i),
      .d_in(encoder_i),
      .valid_o(valid_encoder_o),
      .d_out(encoder_o)   );

   decoder decoder1	     (
      .clk,
      .rst,
      .enable (enable_decoder_in),
      .d_in   (encoder_o_reg),
      .d_out  (decoder_o)   );

endmodule
