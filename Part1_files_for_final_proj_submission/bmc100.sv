/* for our constraint length = 3, there will be 2**3 = 8
of these*/


module bmc100				  // branch metric computation
(
   input    [1:0] rx_pair,
   output   [1:0] path_0_bmc,
   output   [1:0] path_1_bmc);

/* Fill in the guts per BMC instructions
*/

   wire     tmp00;
   wire     tmp01;
   wire     tmp10;
   wire     tmp11;
   
   assign tmp00 = rx_pair[0];
   assign tmp01 = rx_pair[1];
   assign tmp10 = !tmp00;
   assign tmp11 = !tmp01;
   
   assign path_0_bmc[1] = tmp00 & tmp01;
   assign path_0_bmc[0] = tmp00 ^ tmp01;
   
   assign path_1_bmc[1] = tmp10 & tmp11;
   assign path_1_bmc[0] = tmp10 ^ tmp11;
   
endmodule
