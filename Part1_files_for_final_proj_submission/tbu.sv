module tbu
(
   input       clk,
   input       rst,
   input       enable,
   input       selection,
   input [7:0] d_in_0,
   input [7:0] d_in_1,
   output logic  d_o,
   output logic  wr_en);

   logic         d_o_reg;
   logic         wr_en_reg;
   
   logic   [2:0] pstate;
   logic   [2:0] nstate;

   logic         selection_buf;

   always @(posedge clk)    begin
      selection_buf  <= selection;
      wr_en          <= wr_en_reg;
      d_o            <= d_o_reg;
   end
   always @(posedge clk, negedge rst) begin
      if(!rst)
         pstate   <= 3'b000;
      else if(!enable)
         pstate   <= 3'b000;
      else if(selection_buf && !selection)
         pstate   <= 3'b000;
      else
         pstate   <= nstate;
   end

/*  combinational logic drives:
wr_en_reg, d_o_reg, nstate (next state)
from selection, d_in_1[pstate], d_in_0[pstate]
See assignment text for details
*/

/* modified below as per truth table in instructions*/
	always_comb begin
		wr_en_reg = selection;
		
		
		case(pstate) 
			3'd0: begin
				if(!selection) begin
					if(!d_in_0[0]) begin nstate = 3'd0; d_o_reg = 0; end
					else           begin nstate = 3'd1; d_o_reg = 0; end
				end
				else begin
					if(!d_in_1[0]) begin nstate = 3'd0; d_o_reg = d_in_1[0]; end
					else           begin nstate = 3'd1; d_o_reg = d_in_1[0]; end
				end
			end	
			
			3'd1: begin
				if(!selection) begin
					if(!d_in_0[1]) begin nstate = 3'd3; d_o_reg = 0; end
					else           begin nstate = 3'd2; d_o_reg = 0; end
				end
				else begin
					if(!d_in_1[1]) begin nstate = 3'd3; d_o_reg = d_in_1[1]; end
					else           begin nstate = 3'd2; d_o_reg = d_in_1[1]; end
				end
			end
			
		    3'd2: begin
				if(!selection) begin
					if(!d_in_0[2]) begin nstate = 3'd4; d_o_reg = 0; end
					else           begin nstate = 3'd5; d_o_reg = 0; end
				end
				else begin
					if(!d_in_1[2]) begin nstate = 3'd4; d_o_reg = d_in_1[2]; end
					else           begin nstate = 3'd5; d_o_reg = d_in_1[2]; end
				end
			end
		    
			3'd3: begin
				if(!selection) begin
					if(!d_in_0[3]) begin nstate = 3'd7; d_o_reg = 0; end
					else           begin nstate = 3'd6; d_o_reg = 0; end
				end
				else begin
					if(!d_in_1[3]) begin nstate = 3'd7; d_o_reg = d_in_1[3]; end 
					else           begin nstate = 3'd6; d_o_reg = d_in_1[3]; end
				end
			end
		
		    3'd4: begin
				if(!selection) begin
					if(!d_in_0[4]) begin nstate = 3'd1; d_o_reg = 0; end
					else           begin nstate = 3'd0; d_o_reg = 0; end
				end
				else begin
					if(!d_in_1[4]) begin nstate = 3'd1; d_o_reg = d_in_1[4]; end
					else           begin nstate = 3'd0; d_o_reg = d_in_1[4]; end
				end
			end
		
		    3'd5: begin
				if(!selection) begin
					if(!d_in_0[5]) begin nstate = 3'd2; d_o_reg = 0; end
					else           begin nstate = 3'd3; d_o_reg = 0; end
				end
				else begin
					if(!d_in_1[5]) begin nstate = 3'd2; d_o_reg = d_in_1[5]; end
					else           begin nstate = 3'd3; d_o_reg = d_in_1[5]; end
				end
			end
		
		    3'd6: begin
				if(!selection) begin
					if(!d_in_0[6]) begin nstate = 3'd5; d_o_reg = 0; end
					else           begin nstate = 3'd4; d_o_reg = 0; end
				end
				else begin
					if(!d_in_1[6]) begin nstate = 3'd5; d_o_reg = d_in_1[6]; end
					else           begin nstate = 3'd4; d_o_reg = d_in_1[6]; end
				end
			end
		
		    3'd7: begin
				if(!selection) begin
					if(!d_in_0[7]) begin nstate = 3'd6; d_o_reg = 0; end
					else           begin nstate = 3'd7; d_o_reg = 0; end
				end
				else begin
					if(!d_in_1[7]) begin nstate = 3'd6; d_o_reg = d_in_1[7]; end
					else           begin nstate = 3'd7; d_o_reg = d_in_1[7]; end
				end
			end
			
			default: begin
			       nstate  = pstate;
				   d_o_reg = ((selection)?d_in_1[pstate]:2'b00);
			end
		endcase	
	end	
	

endmodule
