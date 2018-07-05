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

 
   reg 			wb_clk;
   initial begin
      wb_clk = 0;
      forever
	#5 wb_clk = ~wb_clk;
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
		274) TEST();


   wire			pop;			// From dut of fifo_to_sram.v
   wire [31:0]		sram_data_out;		// From dut of fifo_to_sram.v
   wire			sram_start;		// From dut of fifo_to_sram.v
   
   reg 			full;
   reg 			empty;
   reg 			grant;
   reg [5:0] 		fifo_number_samples;
   reg [5:0] 		fifo_number_samples_terminal;
   reg 			data_done;
   reg [31:0] 		fifo_data_in;
   
   fifo_to_sram dut(
		    // Outputs
		    .pop		(pop),
		    .sram_data_out	(sram_data_out[31:0]),
		    .sram_start		(sram_start),
		    // Inputs
		    .wb_clk		(wb_clk),
		    .wb_rst		(wb_rst),
		    .empty		(empty),
		    .full		(full),
		    .grant		(grant),
		    .fifo_number_samples(fifo_number_samples[5:0]),
		    .fifo_number_samples_terminal(fifo_number_samples_terminal[5:0]),
		    .data_done		(data_done),
		    .fifo_data_in	(fifo_data_in[31:0])); 

   initial begin

      full <= 0;
      empty <= 1;  //This one starts high since at POR the fifo is empty
      grant <= 0;
      fifo_number_samples <= 0;
      fifo_number_samples_terminal <= 0;
      data_done <= 0;
      fifo_data_in <= 0;
            
      
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
      repeat{5}(@posedge wb_clk);
      
      
      TEST.all_tests_completed();
   end
   
endmodule // tb_fifo
