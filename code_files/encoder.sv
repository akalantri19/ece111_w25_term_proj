// figure out what this encoder does -- differs a bit from Homework 7
module encoder                    // use this one
(  input             clk,
   input             rst,
   input             enable_i,
   input             d_in,
   output logic      valid_o,
   output      [1:0] d_out);
   
   logic         [2:0] cstate;
   logic         [2:0] nstate;
   
   logic         [1:0] d_out_reg;

   assign   d_out    =  (enable_i)? d_out_reg:2'b00;

   always_comb begin
      valid_o  =   enable_i;
      case (cstate) 
	  // fill in the guts
	  3'd0: begin
		if(!d_in) begin nstate = 3'd0; d_out_reg = 2'b00; end
		else      begin nstate = 3'd4; d_out_reg = 2'b11; end
	  end
	  
	  3'd1: begin
		if(!d_in) begin nstate = 3'd4; d_out_reg = 2'b00; end
		else      begin nstate = 3'd0; d_out_reg = 2'b11; end
	  end
	  
	  3'd2: begin
		if(!d_in) begin nstate = 3'd5; d_out_reg = 2'b10; end
		else      begin nstate = 3'd1; d_out_reg = 2'b01; end
	  end
	  
	  3'd3: begin
		if(!d_in) begin nstate = 3'd1; d_out_reg = 2'b10; end
		else      begin nstate = 3'd5; d_out_reg = 2'b01; end
	  end
	  
	  3'd4: begin
		if(!d_in) begin nstate = 3'd2; d_out_reg = 2'b10; end
		else      begin nstate = 3'd6; d_out_reg = 2'b01; end
	  end
	  
	  3'd5: begin
		if(!d_in) begin nstate = 3'd6; d_out_reg = 2'b10; end
		else      begin nstate = 3'd2; d_out_reg = 2'b01; end
	  end
	  
	  3'd6: begin
		if(!d_in) begin nstate = 3'd7; d_out_reg = 2'b00; end
		else      begin nstate = 3'd3; d_out_reg = 2'b11; end
	  end	
	  
	  3'd7: begin
		if(!d_in) begin nstate = 3'd3; d_out_reg = 2'b00; end
		else      begin nstate = 3'd7; d_out_reg = 2'b11; end
	  end
	  
     endcase
   end								   

   always @ (posedge clk,negedge rst)   begin
//      $display("data in=%d state=%b%b%b data out=%b%b",d_in,reg_1,reg_2,reg_3,d_out_reg[1],d_out_reg[0]);
      if(!rst)
         cstate   <= 3'b000;
      else if(!enable_i)
         cstate   <= 3'b000;
      else
         cstate   <= nstate;
   end

endmodule
