//                              -*- Mode: Verilog -*-
// Filename        : tb_fifo.v
// Description     : fifo test bench
// Author          : ptracton
// Created On      : Mon Jul  2 20:26:10 2018
// Last Modified By: ptracton
// Last Modified On: Mon Jul  2 20:26:10 2018
// Update Count    : 0
// Status          : Unknown, Use with caution!

module tb_fifo_to_sram (/*AUTOARG*/) ;

   // For a testbench this is ok
   /* verilator lint_off STMTDLY */
   
   localparam WB_CLK_PERIOD= 10;
   
   reg 			wb_clk;
   initial begin
      wb_clk = 0;
      forever
	#(WB_CLK_PERIOD/2) wb_clk = ~wb_clk;
   end
 
   reg 			wb_rst;
   initial begin
      wb_rst = 0;
      #42 wb_rst = 1;
      #77 wb_rst = 0; 
   end

   //
   // General purpose test support
   //
   test_tasks #("fifo_to_sram",
		9) TEST();


   wire			pop;			// From dut of fifo_to_sram.v
   wire [31:0]		sram_data_out;		// From dut of fifo_to_sram.v
   wire			sram_start;		// From dut of fifo_to_sram.v
   reg 			push;
   reg [31:0] 		data_in;
   
   wire 		full;
   wire 		empty;
   reg 			grant;
   wire [4:0] 		fifo_number_samples;
   reg [4:0] 		fifo_number_samples_terminal;
   reg 			data_done;
   wire [31:0] 		fifo_data_in;
   
   fifo_to_sram #(5) dut(
			 // Outputs
			 .pop		(pop),
			 .sram_data_out	(sram_data_out),
			 .sram_start		(sram_start),
			 // Inputs
			 .wb_clk		(wb_clk),
			 .wb_rst		(wb_rst),
			 .empty		(empty),
			 .grant		(grant),
			 .fifo_number_samples(fifo_number_samples),
			 .fifo_number_samples_terminal(fifo_number_samples_terminal),
			 .data_done		(data_done),
			 .fifo_data_in	(fifo_data_in)); 
   
   
   fifo fifo_test(
		  // Outputs
		  .data_out(fifo_data_in), 
		  .empty(empty), 
		  .full(full), 
		  .number_samples(fifo_number_samples),
		  // Inputs
		  .wb_clk(wb_clk), 
		  .wb_rst(wb_rst), 
		  .push(push), 
		  .pop(pop), 
		  .data_in(data_in)
		  ) ;
   
   /******************************************************************
    
    Pushes the inputted data into the FIFO so the sram_to_fifo can 
    pull it out
    
    *****************************************************************/
   task PushToFIFO;
      input [31:0] pushData;
      begin
	 push <= 0;
	 data_in <= pushData;
	 @(posedge wb_clk);
	 push <= 1;
	 @(posedge wb_clk);
	 push <= 0;
      end
   endtask // PushToFIFO

   /******************************************************************
    
    Mimcs the other side that receives the data from fifo_to_sram
    
    *****************************************************************/
   task SRAMCycle;
      input [7:0] numberOfCycles;
      
      begin
	 @(posedge wb_clk);
	 grant <= 1;
	 repeat(numberOfCycles) @(posedge wb_clk);
	 grant <= 0;
	 data_done <= 1;
	 @(posedge wb_clk);
	 data_done <= 0;
      end
   endtask // SRAMCycle
   
   //
   // Measure the width of the PUSH pulse to make sure it is not too long or short.
   // Short pulses could miss data being stored.
   // Long pulses could store the data multiple times.
   //
   time 		  PopStart;

   // Get the time the pulse goes high
   always @(posedge pop)
     PopStart <= $time;

   // At the falling edge, find the difference from the start time and confirm width
   // If we do not match the clk period, error out!
   always @(negedge pop) begin
      if ($time - PopStart != WB_CLK_PERIOD) begin
	 TEST.compare_values("Pop wrong size!", WB_CLK_PERIOD, $time-PopStart);
      end
   end
      
   
   initial begin

      grant <= 0;
      fifo_number_samples_terminal <= 0;
      data_done <= 0;

      
      //
      // Wait for reset to complete
      //
      @(negedge wb_rst);

      //
      // Check POR values
      //
      TEST.compare_values("POR POP",0, pop);
      TEST.compare_values("POR SRAM Data Out",0, sram_data_out);
      TEST.compare_values("POR SRAM Start",0, sram_start);
      

      //
      // Grab sample from FIFO and send to SRAM writing state machine
      //
      fifo_number_samples_terminal <= 4;
      PushToFIFO(32'ha5b6c7d8);
      PushToFIFO(32'he9fa0123);
      PushToFIFO(32'h4567890a);
      PushToFIFO(32'h55555555);
      PushToFIFO(32'haaaaaaaa);

      
      SRAMCycle(2);
      TEST.compare_values("1st to SRAM", 32'ha5b6c7d8, sram_data_out);
      
      SRAMCycle(4);
      TEST.compare_values("2nd to SRAM", 32'he9fa0123, sram_data_out);
      
      SRAMCycle(6);
      TEST.compare_values("3rd to SRAM", 32'h4567890a, sram_data_out);
      
      SRAMCycle(8);
      TEST.compare_values("4th to SRAM", 32'h55555555, sram_data_out);
      
      SRAMCycle(10);
      TEST.compare_values("5th to SRAM", 32'hAAAAAAAA, sram_data_out);
      TEST.compare_values("First Empty", 1, empty);
      

      
      TEST.all_tests_completed();
   end
   
endmodule // tb_fifo
