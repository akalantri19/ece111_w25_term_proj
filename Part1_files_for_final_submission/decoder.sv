module decoder
(
   input             clk,
   input             rst,
   input             enable,
   input [1:0]       d_in,
   output logic      d_out);

//bmc module signals
   wire  [1:0]       bmc000_path_0_bmc;
   wire  [1:0]       bmc001_path_0_bmc;
   wire  [1:0]       bmc010_path_0_bmc;
   wire  [1:0]       bmc011_path_0_bmc;
   wire  [1:0]       bmc100_path_0_bmc;
   wire  [1:0]       bmc101_path_0_bmc;
   wire  [1:0]       bmc110_path_0_bmc;
   wire  [1:0]       bmc111_path_0_bmc;

   wire  [1:0]       bmc000_path_1_bmc;
   wire  [1:0]       bmc001_path_1_bmc;
   wire  [1:0]       bmc010_path_1_bmc;
   wire  [1:0]       bmc011_path_1_bmc;
   wire  [1:0]       bmc100_path_1_bmc;
   wire  [1:0]       bmc101_path_1_bmc;
   wire  [1:0]       bmc110_path_1_bmc;
   wire  [1:0]       bmc111_path_1_bmc;

//ACS modules signals
   logic   [7:0]       validity;
   logic   [7:0]       selection;
   logic   [7:0]       path_cost   [8];
   wire    [7:0]       validity_nets;
   wire    [7:0]       selection_nets;

   wire              ACS000_selection;
   wire              ACS001_selection;
   wire              ACS010_selection;
   wire              ACS011_selection;
   wire              ACS100_selection;
   wire              ACS101_selection;
   wire              ACS110_selection;
   wire              ACS111_selection;

   wire              ACS000_valid_o;
   wire              ACS001_valid_o;
   wire              ACS010_valid_o;
   wire              ACS011_valid_o;
   wire              ACS100_valid_o;
   wire              ACS101_valid_o;
   wire              ACS110_valid_o;
   wire              ACS111_valid_o;

   wire  [7:0]       ACS000_path_cost;
   wire  [7:0]       ACS001_path_cost;
   wire  [7:0]       ACS010_path_cost;
   wire  [7:0]       ACS011_path_cost;
   wire  [7:0]       ACS100_path_cost;
   wire  [7:0]       ACS101_path_cost;
   wire  [7:0]       ACS110_path_cost;
   wire  [7:0]       ACS111_path_cost;

//Trelis memory write operation, pipeline delay
   logic   [1:0]       mem_bank;
   logic   [1:0]       mem_bank_Q1;
   logic   [1:0]       mem_bank_Q2;
   logic               mem_bank_Q3;
   logic               mem_bank_Q4;
   logic               mem_bank_Q5;
   logic   [9:0]       wr_mem_counter;
   logic   [9:0]       rd_mem_counter;

// 4 memory banks -- address pointers 
   logic   [9:0]       addr_mem_A;
   logic   [9:0]       addr_mem_B;
   logic   [9:0]       addr_mem_C;
   logic   [9:0]       addr_mem_D;

// write enables
   logic               wr_mem_A;
   logic               wr_mem_B;
   logic               wr_mem_C;
   logic               wr_mem_D;

// data to memories
   logic   [7:0]       d_in_mem_A;
   logic   [7:0]       d_in_mem_B;
   logic   [7:0]       d_in_mem_C;
   logic   [7:0]       d_in_mem_D;

// data from memories
   wire    [7:0]       d_o_mem_A;
   wire    [7:0]       d_o_mem_B;
   wire    [7:0]       d_o_mem_C;
   wire    [7:0]       d_o_mem_D;
		  
//Trace back module signals
   logic               selection_tbu_0;
   logic               selection_tbu_1;

   logic   [7:0]       d_in_0_tbu_0;
   logic   [7:0]       d_in_1_tbu_0;
   logic   [7:0]       d_in_0_tbu_1;
   logic   [7:0]       d_in_1_tbu_1;

   wire                d_o_tbu_0;
   wire                d_o_tbu_1;

   logic               enable_tbu_0;
   logic               enable_tbu_1;

//Display memory operations 
   wire                wr_disp_mem_0;
   wire                wr_disp_mem_1;

   wire                d_in_disp_mem_0;
   wire                d_in_disp_mem_1;

// Added by Akalantri - validate output and increase output efficiency
   wire                d_o_disp_mem_0;
   wire                d_o_disp_mem_1;

   logic   [9:0]       wr_mem_counter_disp;
   logic   [9:0]       rd_mem_counter_disp;

   logic   [9:0]       addr_disp_mem_0;
   logic   [9:0]       addr_disp_mem_1;

//Branch matrc calculation modules
   bmc001   bmc001_inst(d_in,bmc001_path_0_bmc,bmc001_path_1_bmc);
   bmc010   bmc010_inst(d_in,bmc010_path_0_bmc,bmc010_path_1_bmc);
   bmc011   bmc011_inst(d_in,bmc011_path_0_bmc,bmc011_path_1_bmc);
   bmc100   bmc100_inst(d_in,bmc100_path_0_bmc,bmc100_path_1_bmc);
   bmc101   bmc101_inst(d_in,bmc101_path_0_bmc,bmc101_path_1_bmc);
   bmc110   bmc110_inst(d_in,bmc110_path_0_bmc,bmc110_path_1_bmc);
   bmc111   bmc111_inst(d_in,bmc111_path_0_bmc,bmc111_path_1_bmc);


//Add Compare Select Modules
   ACS      ACS0(validity[0],validity[1],bmc0_path_0_bmc,bmc0_path_1_bmc,path_cost[0],path_cost[1],ACS0_selection,ACS0_valid_o,ACS0_path_cost);
   ACS      ACS1(validity[3],validity[2],bmc1_path_0_bmc,bmc1_path_1_bmc,path_cost[3],path_cost[2],ACS1_selection,ACS1_valid_o,ACS1_path_cost);
   ACS      ACS2(validity[4],validity[5],bmc2_path_0_bmc,bmc2_path_1_bmc,path_cost[4],path_cost[5],ACS2_selection,ACS2_valid_o,ACS2_path_cost);
   ACS      ACS3(validity[7],validity[6],bmc3_path_0_bmc,bmc3_path_1_bmc,path_cost[7],path_cost[6],ACS3_selection,ACS3_valid_o,ACS3_path_cost);
   ACS      ACS4(validity[1],validity[0],bmc4_path_0_bmc,bmc4_path_1_bmc,path_cost[1],path_cost[0],ACS4_selection,ACS4_valid_o,ACS4_path_cost);
   ACS      ACS5(validity[2],validity[3],bmc5_path_0_bmc,bmc5_path_1_bmc,path_cost[2],path_cost[3],ACS5_selection,ACS5_valid_o,ACS5_path_cost);
   ACS      ACS6(validity[5],validity[4],bmc6_path_0_bmc,bmc6_path_1_bmc,path_cost[5],path_cost[4],ACS6_selection,ACS6_valid_o,ACS6_path_cost);
   ACS      ACS7(validity[6],validity[7],bmc7_path_0_bmc,bmc7_path_1_bmc,path_cost[6],path_cost[7],ACS7_selection,ACS7_valid_o,ACS7_path_cost);
   
   // selection_nets  = // concatenate ACS7 ,,, ACS0 _selections 
   // validity_nets   = // same for ACSK_valid_os 

   always @ (posedge clk, negedge rst) begin
      if(!rst)  begin
         validity          <= 8'b1;
         selection         <= 8'b0;
/* clear all 8 path costs
*/
      path_cost[0]      <= 8'd0;
		path_cost[1]      <= 8'd0;
		path_cost[2]      <= 8'd0;
		path_cost[3]      <= 8'd0;
		path_cost[4]      <= 8'd0;
		path_cost[5]      <= 8'd0;
		path_cost[6]      <= 8'd0;
		path_cost[7]      <= 8'd0;

      end
      else if(!enable)   begin
         validity          <= 8'b1;
         selection         <= 8'b0;
/* clear all 8 path costs
         path_cost[i]      <= 8'd0;
*/
      path_cost[0]      <= 8'd0;
		path_cost[1]      <= 8'd0;
		path_cost[2]      <= 8'd0;
		path_cost[3]      <= 8'd0;
		path_cost[4]      <= 8'd0;
		path_cost[5]      <= 8'd0;
		path_cost[6]      <= 8'd0;
		path_cost[7]      <= 8'd0;

      end
      else if( path_cost[0][7] && path_cost[1][7] && path_cost[2][7] && path_cost[3][7] &&
             path_cost[4][7] && path_cost[5][7] && path_cost[6][7] && path_cost[7][7] )
      begin

         validity          <= validity_nets;
         selection         <= selection_nets;
         
         path_cost[0]      <= 8'b01111111 & ACS000_path_cost;
         path_cost[1]      <= 8'b01111111 & ACS001_path_cost;
		   path_cost[2]      <= 8'b01111111 & ACS010_path_cost;
		   path_cost[3]      <= 8'b01111111 & ACS011_path_cost;
		   path_cost[4]      <= 8'b01111111 & ACS100_path_cost;
		   path_cost[5]      <= 8'b01111111 & ACS101_path_cost;
		   path_cost[6]      <= 8'b01111111 & ACS110_path_cost;
		   path_cost[7]      <= 8'b01111111 & ACS111_path_cost;

      end
      else   begin
         validity          <= validity_nets;
         selection         <= selection_nets;

         path_cost[0]      <= ACS000_path_cost;
         path_cost[1]      <= ACS001_path_cost;
		   path_cost[2]      <= ACS010_path_cost;
		   path_cost[3]      <= ACS011_path_cost;
		   path_cost[4]      <= ACS100_path_cost;
		   path_cost[5]      <= ACS101_path_cost;
		   path_cost[6]      <= ACS110_path_cost;
		   path_cost[7]      <= ACS111_path_cost;
      end
   end

   always @ (posedge clk, negedge rst) begin
      if(!rst)
         wr_mem_counter <= 10'd0;
      else if(!enable)
         wr_mem_counter <= 10'd0;
      else
         wr_mem_counter <= wr_mem_counter + 10'd1;
   end

   always @ (posedge clk, negedge rst) begin
      if(!rst)
         rd_mem_counter <= 10'b1;// -1   how do you handle this in 10 bit binary?
      else if(enable)
         rd_mem_counter <= rd_mem_counter - 10'd1;
   end

   always @ (posedge clk, negedge rst)
      if(!rst)
         mem_bank <= 2'b0;
      else begin
         if(wr_mem_counter==10'b1)
               mem_bank <= mem_bank + 2'b1;
      end

   always @ (posedge clk)    begin
      d_in_mem_A  <= selection;
      d_in_mem_B  <= selection;
      d_in_mem_C  <= selection;
      d_in_mem_D  <= selection;
   end

   always @ (posedge clk)     begin
      case(mem_bank)
         2'b00:         begin
            addr_mem_A        <= wr_mem_counter;
            addr_mem_B        <= rd_mem_counter;
            addr_mem_C        <= 10'd0;
            addr_mem_D        <= rd_mem_counter;

            wr_mem_A          <= 1'b1;
/* other wr_mems = 0
*/	        
         end
         2'b01:         begin
            addr_mem_A        <= rd_mem_counter;
            addr_mem_B        <= wr_mem_counter;
            addr_mem_C        <= rd_mem_counter;
            addr_mem_D        <= 10'd0;

            wr_mem_B          <= 1'b1;
/* other wr_mems = 0
*/	        
         end		       
         2'b10:    begin
            addr_mem_A        <= 10'd0;
            addr_mem_B        <= rd_mem_counter;
            addr_mem_C        <= wr_mem_counter;
            addr_mem_D        <= rd_mem_counter;

            wr_mem_C       <= 1'b1;
/* other wr_mems = 0
*/	        
         end
         2'b11:     begin
            addr_mem_A        <= rd_mem_counter;
            addr_mem_B        <= 10'd0;
            addr_mem_C        <= rd_mem_counter;
            addr_mem_D        <= wr_mem_counter;

            wr_mem_D       <= 1'b1;
/* other wr_mems = 0
*/	        
         end		       
      endcase
  end

//Trelis memory module instantiation

   mem   trelis_mem_A
   (
      .clk,
      .wr(wr_mem_A),
      .addr(addr_mem_A),
      .d_i(d_in_mem_A),
      .d_o(d_o_mem_A)
   );
/* likewise for trelis_memB, C, D
*/

   mem   trelis_mem_B
   (
      .clk,
      .wr(wr_mem_B),
      .addr(addr_mem_B),
      .d_i(d_in_mem_B),
      .d_o(d_o_mem_B)
   );

   mem   trelis_mem_C
   (
      .clk,
      .wr(wr_mem_C),
      .addr(addr_mem_C),
      .d_i(d_in_mem_C),
      .d_o(d_o_mem_C)
   );

   mem   trelis_mem_D
   (
      .clk,
      .wr(wr_mem_D),
      .addr(addr_mem_D),
      .d_i(d_in_mem_D),
      .d_o(d_o_mem_D)
   );

//Trace back module operation

/* create mem_bank, mem_bank_Q1, mem_bank_Q2 pipeline */

   always @(posedge clk)
      mem_bank_Q1   <= mem_bank;
   
   always @(posedge clk)
      mem_bank_Q2   <= mem_bank_Q1;

   always @ (posedge clk, negedge rst)
      if(!rst)
            enable_tbu_0   <= 1'b0;
      else begin
         if(mem_bank_Q2==2'b10)
            enable_tbu_0   <= 1'b1;
         else
            enable_tbu_0   <= enable_tbu_0;
      end

   always @ (posedge clk, negedge rst)
      if(!rst)
            enable_tbu_1   <= 1'b0;
      else begin
         if(mem_bank_Q2==2'b11)
            enable_tbu_1   <= 1'b1;
         else
            enable_tbu_1   <= enable_tbu_1;
      end
   
   always @ (posedge clk)
      case(mem_bank_Q2)
         2'b00:	  begin
            d_in_0_tbu_0   <= d_o_mem_D;
            d_in_1_tbu_0   <= d_o_mem_C;
            
            d_in_0_tbu_1   <= d_o_mem_C;
            d_in_1_tbu_1   <= d_o_mem_B;

            selection_tbu_0<= 1'b0;
            selection_tbu_1<= 1'b1;

         end
         2'b01:	   begin
            d_in_0_tbu_0   <= d_o_mem_D;
            d_in_1_tbu_0   <= d_o_mem_C;
            
            d_in_0_tbu_1   <= d_o_mem_A;
            d_in_1_tbu_1   <= d_o_mem_D;
            
            selection_tbu_0<= 1'b1;
            selection_tbu_1<= 1'b0;
         end
         2'b10:	   begin
            d_in_0_tbu_0   <= d_o_mem_B;
            d_in_1_tbu_0   <= d_o_mem_A;
            
            d_in_0_tbu_1   <= d_o_mem_A;
            d_in_1_tbu_1   <= d_o_mem_D;

            selection_tbu_0<= 1'b0;
            selection_tbu_1<= 1'b1;
         end
         2'b11:	  begin
            d_in_0_tbu_0   <= d_o_mem_B;
            d_in_1_tbu_0   <= d_o_mem_A;
            
            d_in_0_tbu_1   <= d_o_mem_C;
            d_in_1_tbu_1   <= d_o_mem_B;

            selection_tbu_0<= 1'b1;
            selection_tbu_1<= 1'b0;
         end
      endcase

//Trace-Back modules instantiation

   tbu tbu_0   (
      .clk,
      .rst,
      .enable(enable_tbu_0),
      .selection(selection_tbu_0),
      .d_in_0(d_in_0_tbu_0),
      .d_in_1(d_in_1_tbu_0),
      .d_o(d_o_tbu_0),
      .wr_en(wr_disp_mem_0)
   );

/* analogous for tbu_1
*/
   tbu tbu_1   (
      .clk,
      .rst,
      .enable(enable_tbu_1),
      .selection(selection_tbu_1),
      .d_in_0(d_in_0_tbu_1),
      .d_in_1(d_in_1_tbu_1),
      .d_o(d_o_tbu_1),
      .wr_en(wr_disp_mem_1)
   );

//Display Memory modules Instantioation
//   d_in_disp_mem_K   =  d_o_tbu_K;  K=0,1

   assign   d_in_disp_mem_0   =  d_o_tbu_0;
   assign   d_in_disp_mem_1   =  d_o_tbu_1;

  mem_disp   disp_mem_0	  (
      .clk              ,
      .wr(wr_disp_mem_0),
      .addr(addr_disp_mem_0),
      .d_i(d_in_disp_mem_0),
      .d_o(d_o_disp_mem_0)
   );
/* analogous for disp_mem_1
*/
   mem_disp   disp_mem_1
  (
      .clk              ,
      .wr(wr_disp_mem_1),
      .addr(addr_disp_mem_1),
      .d_i(d_in_disp_mem_1),
      .d_o(d_o_disp_mem_1)
   );

// Display memory module operation
   always @ (posedge clk)
      mem_bank_Q3 <= mem_bank_Q2[0];

   always @ (posedge clk)
      if(!rst)
         wr_mem_counter_disp  <= 10'b0000000010;
      else if(!enable)
         wr_mem_counter_disp  <= 10'b0000000010;
      else
			wr_mem_counter_disp  <= wr_mem_counter_disp - 10'd1;    

   always @ (posedge clk)
      if(!rst)
         rd_mem_counter_disp  <= 10'b1111111101;
      else if(!enable)
         rd_mem_counter_disp  <= 10'b1111111101;
      else
			rd_mem_counter_disp  <= rd_mem_counter_disp + 10'd1;     
   
   always @ (posedge clk)
      case(mem_bank_Q3)
         1'b0:
         begin
            addr_disp_mem_0   <= rd_mem_counter_disp; 
            addr_disp_mem_1   <= wr_mem_counter_disp;
         end
         1'b1:	 //swap rd and wr; 
		  begin
            addr_disp_mem_0   <= wr_mem_counter_disp; 
            addr_disp_mem_1   <= rd_mem_counter_disp;
         end 
      endcase

   
/* pipeline mem_bank_Q3 to Q4 to Q5
 also  d_out = d_o_disp_mem_i 
    i = mem_bank_Q5 
*/

   always @ (posedge clk) begin
      mem_bank_Q4     <= mem_bank_Q3;
      mem_bank_Q5 <= mem_bank_Q4;
   end

   always @ (posedge clk)
   if(mem_bank_Q5) d_out <= d_o_disp_mem_1;
	else 	d_out <= d_o_disp_mem_0;

endmodule
