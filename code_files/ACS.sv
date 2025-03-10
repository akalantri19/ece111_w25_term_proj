module ACS		                        // add-compare-select
(
   input       path_0_valid,
   input       path_1_valid,
   input [1:0] path_0_bmc,	            // branch metric computation
   input [1:0] path_1_bmc,				
   input [7:0] path_0_pmc,				// path metric computation
   input [7:0] path_1_pmc,

   output logic        selection,
   output logic        valid_o,
   output logic     [7:0] path_cost);  

   wire  [7:0] path_cost_0;			   // branch metric + path metric
   wire  [7:0] path_cost_1;

// Fill in the guts per ACS instructions
   assign path_cost_0 = path_0_bmc + path_0_pmc;
   assign path_cost_1 = path_1_bmc + path_1_pmc;

   always_comb begin
    case({path_0_valid, path_1_valid})
		2'b00: selection = 0;
		2'b01: selection = 1;
		2'b10: selection = 0;
		2'b11: selection = ((path_cost_0 > path_cost_1)? 1 : 0);
		
		//default: selection = 0;
	endcase
   end
   
   always_comb begin
	if((!path_0_valid) & (!path_1_valid)) begin
		valid_o = 0;
		end
	else begin
		valid_o = 1;
	end
   end		
   
   always_comb begin
	case ({valid_o, selection}) 
		2'b00: path_cost = 0;
		2'b01: path_cost = 0;
		2'b10: path_cost = path_cost_0;
		2'b11: path_cost = path_cost_1;
	endcase
   end
endmodule
