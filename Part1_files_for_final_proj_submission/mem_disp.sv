/* This was originally code for mem_1x1024 which was modified since name was different in decoder */

module mem_disp	   (
   input          clk,
   input          wr,
   input [9:0]    addr,
   input          d_i,
   output logic     d_o);
   
   logic            mem   [1024];

   always @ (posedge clk) begin
      if(wr)
         mem[addr]   <= d_i;
      d_o  <=  mem[addr];
  end
endmodule