module viterbi_tx_rx(
   input    clk,
   input    rst,
   input    encoder_i,
   input    enable_encoder_i,
   output   decoder_o);

   wire  [1:0] encoder_o;

   logic   [13:0] error_counter;
   
   logic   [13:0] count[0:1023];
   integer random_set;
   integer value;
   integer i;
   integer index = 0;
   //integer error_counter = 0;
   ///
   logic   [1:0] encoder_o_reg;
   
   logic       enable_decoder_in;
   wire        valid_encoder_o;
   
function [13:0] dec_2_bin;
	input integer dec_value;
	begin
	
	if(dec_value >= 8192 && dec_value <=16383) begin
		dec_2_bin[13] = 1;
		dec_value = dec_value - 8192;
	end
	else dec_2_bin[13] = 0;
	
	if(dec_value >= 4096) begin
		dec_2_bin[12] = 1;
		dec_value = dec_value - 4096;
	end
	else dec_2_bin[12] = 0;
	//
	if(dec_value >= 2048) begin
		dec_2_bin[11] = 1;
		dec_value = dec_value - 2048;
	end
	else dec_2_bin[11] = 0;
	
	if(dec_value >= 1024) begin
		dec_2_bin[10] = 1;
		dec_value = dec_value - 1024;
	end
	else dec_2_bin[10] = 0;
	
	if(dec_value >= 512) begin
		dec_2_bin[9] = 1;
		dec_value = dec_value - 512;
	end
	else dec_2_bin[9] = 0;
	
	if(dec_value >= 256) begin
		dec_2_bin[8] = 1;
		dec_value = dec_value - 256;
	end
	else dec_2_bin[8] = 0;
	
	if(dec_value >= 128) begin
		dec_2_bin[7] = 1;
		dec_value = dec_value - 128;
	end
	else dec_2_bin[7] = 0;
	
	if(dec_value >= 64) begin
		dec_2_bin[6] = 1;
		dec_value = dec_value - 64;
	end
	else dec_2_bin[6] = 0;
	
	if(dec_value >= 32) begin
		dec_2_bin[5] = 1;
		dec_value = dec_value - 32;
	end
	else dec_2_bin[5] = 0;
	
	if(dec_value >= 16) begin
		dec_2_bin[4] = 1;
		dec_value = dec_value - 16;
	end
	else dec_2_bin[4] = 0;
	
	if(dec_value >= 8) begin
		dec_2_bin[3] = 1;
		dec_value = dec_value - 8;
	end
	else dec_2_bin[3] = 0;
	
	if(dec_value >= 4) begin
		dec_2_bin[2] = 1;
		dec_value = dec_value - 4;
	end
	else dec_2_bin[2] = 0;
	
	if(dec_value >= 2) begin
		dec_2_bin[1] = 1;
		dec_value = dec_value - 2;
	end
	else dec_2_bin[1] = 0;
	
	if(dec_value >= 1) begin
		dec_2_bin[0] = 1;
	end
	else dec_2_bin[0] = 0;
   end
  endfunction
   
   //Logic for generating random error values
	initial begin
	$display("Random error spacing with average error injection rate = 6 percent");
		for(i=0; i<1024; i=i+1)begin
			random_set = $urandom_range(0,15);
			value = (16*i) + random_set;
			count[i] = dec_2_bin(value);
			//$display("bin=%b, dec=%d",count[i],value);
		end
	end
   
   always @ (posedge clk, negedge rst) 
      if(!rst) begin  
         error_counter     <= 14'd0;
         encoder_o_reg     <= 2'b00;
         enable_decoder_in <= 1'b0;
		
      end
	  /*
	  else	   begin   
         enable_decoder_in <= valid_encoder_o; 
         encoder_o_reg  <= 2'b00;
         error_counter  <= error_counter + 4'd1;
         if(error_counter==5'b11111)
            encoder_o_reg  <= {~encoder_o[1],encoder_o[0]};	 // inject one bad bit out of every 32
         else
            encoder_o_reg  <= {encoder_o[1],encoder_o[0]};
      end
      */
	  else begin   
         enable_decoder_in <= valid_encoder_o; 
         encoder_o_reg     <= 2'b00;
         error_counter     <= error_counter + 14'd1;
		
		 
		 
         if(error_counter==count[index]) begin
            encoder_o_reg  <= {~encoder_o[1],encoder_o[0]};	 // inject one bad bit out of every 32
			index          <= index + 1;
			$display("cycles_range:(%d-%d), error_injection @cycle:",16*index, 16*(index+1)-1, error_counter);
		 end
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
