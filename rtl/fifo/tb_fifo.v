//                              -*- Mode: Verilog -*-
// Filename        : tb_fifo.v
// Description     : fifo test bench
// Author          : ptracton
// Created On      : Mon Jul  2 20:26:10 2018
// Last Modified By: ptracton
// Last Modified On: Mon Jul  2 20:26:10 2018
// Update Count    : 0
// Status          : Unknown, Use with caution!

module tb_fifo (/*AUTOARG*/) ;

   
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   // End of automatics
   
   /*AUTOREG*/
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
   test_tasks #("fifo",
		42) TEST();
   
   
   localparam defaultDW = 32;
   localparam defaultDepth = 16;
   
   wire [defaultDW-1:0]	defaultDataOut;	
   wire			defaultEmpty;	
   wire			defaultFull;	
   wire [$clog2(defaultDepth):0] defaultNumberSamples;
   
   reg 			defaultPush;
   reg 			defaultPop;
   reg [defaultDW-1:0] 	defaultDataIn;
   reg 			defaultTestComplete;
   
   //
   // Default Values FIFO
   //
   fifo dutDefault(
		   // Outputs
		   .data_out		(defaultDataOut),
		   .empty		(defaultEmpty),
		   .full		(defaultFull),
		   .number_samples	(defaultNumberSamples),
		   // Inputs
		   .wb_clk		(wb_clk),
		   .wb_rst		(wb_rst),
		   .push		(defaultPush),
		   .pop			(defaultPop),
		   .data_in		(defaultDataIn));
   
   //
   // Default Test Cases
   //
   integer 		i;
   initial begin

      //
      // Clean up input and test signals
      //
      defaultPush <= 0;
      defaultPop <= 0;
      defaultDataIn <= 0;
      defaultTestComplete <= 0;
      
      
      //
      // Wait for reset to release
      //
      @(negedge wb_rst);

      //
      // Check Initial Conditions
      //
      TEST.compare_values("Default POR FULL",0,defaultFull);      
      TEST.compare_values("Default POR Empty",1,defaultEmpty);
      TEST.compare_values("Default POR DataOut",0,defaultDataOut);
      TEST.compare_values("Default POR NumberSamples",0,defaultNumberSamples);
      
      
      //
      // Push FIFO Until Full
      //
      for (i=0; i< defaultDepth; i=i+1) begin
	 @(posedge wb_clk);
	 defaultDataIn <= (i << 24) | (i<<16) | (i<< 8) | i;
	 defaultPush <= 1;
	 @(posedge wb_clk);
	 defaultPush <= 0;
	 TEST.compare_values("Default Push Number Samples",i,defaultNumberSamples);	 
      end

      #1 TEST.compare_values("Default Assert FULL",1,defaultFull);
      TEST.compare_values("Default Clear Empty",0,defaultEmpty);

      //
      // Read back values to confirm write and read operations until we are empty
      //
      for (i=0; i<defaultDepth; i=i+1) begin
	 @(posedge wb_clk);
	 TEST.compare_values("Default Read", 
			     (i << 24) | (i<<16) | (i<< 8) | i, 
			     defaultDataOut);
	 @(posedge wb_clk);
	 defaultPop <= 1;
	 @(posedge wb_clk);
	 defaultPop <= 0;
      end

      #1 TEST.compare_values("Default Clear FULL",0,defaultFull);
      TEST.compare_values("Default Assert Empty",1,defaultEmpty);


      //
      // RESET to clear last test
      //
      wb_rst = 1;
      repeat(2) @(posedge wb_clk);
      wb_rst = 0;
      
      //
      // Reload FIFO and cause a wrap around and check results
      //
      for (i=0; i< defaultDepth*2; i=i+1) begin
	 @(posedge wb_clk);
	 defaultDataIn <= (i << 24) | (i<<16) | (i<< 8) | i;
	 defaultPush <= 1;
	 @(posedge wb_clk);
	 defaultPush <= 0;
      end
      
      #1 TEST.compare_values("Default Wrap Around Assert FULL",1,defaultFull);
      TEST.compare_values("Default Wrap Around Clear Empty",0,defaultEmpty);	 
      
      for (i=defaultDepth; i<defaultDepth*2; i=i+1) begin
	 @(posedge wb_clk);
	 TEST.compare_values("Default Wrap Around Read", 
			     ((i) << 24) | ((i)<<16) | ((i)<< 8) | i, 
			     defaultDataOut);
	 @(posedge wb_clk);
	 defaultPop <= 1;
	 @(posedge wb_clk);
	 defaultPop <= 0;
      end

      
      //
      // All Done, signal the testbench we are completed
      //
      defaultTestComplete <= 1;
      
   end


   
   localparam ShortNarrowDW = 8;
   localparam ShortNarrowDepth = 2;
   
   wire [ShortNarrowDW-1:0]	ShortNarrowDataOut;	
   wire			ShortNarrowEmpty;	
   wire			ShortNarrowFull;	
   wire [$clog2(ShortNarrowDepth):0] ShortNarrowNumberSamples;
   
   reg 			ShortNarrowPush;
   reg 			ShortNarrowPop;
   reg [ShortNarrowDW-1:0] 	ShortNarrowDataIn;
   reg 			ShortNarrowTestComplete;
   
   //
   // ShortNarrow Values FIFO
   //
   fifo #(ShortNarrowDW, ShortNarrowDepth) 
   dutShortNarrow(
		  // Outputs
		  .data_out		(ShortNarrowDataOut),
		  .empty		(ShortNarrowEmpty),
		  .full 		(ShortNarrowFull),
		  .number_samples	(ShortNarrowNumberSamples),
		  // Inputs
		  .wb_clk		(wb_clk),
		  .wb_rst		(wb_rst),
		  .push	        	(ShortNarrowPush),
		  .pop			(ShortNarrowPop),
		  .data_in		(ShortNarrowDataIn));
   
   initial begin

      //
      // Clean up input and test signals
      //
      ShortNarrowPush <= 0;
      ShortNarrowPop <= 0;
      ShortNarrowDataIn <= 0;
      ShortNarrowTestComplete <= 0;

      //
      // Wait for reset to release
      //
      @(negedge wb_rst);

      //
      // Check Initial Conditions
      //
      TEST.compare_values("ShortNarrow POR FULL",0,ShortNarrowFull);      
      TEST.compare_values("ShortNarrow POR Empty",1,ShortNarrowEmpty);
      TEST.compare_values("ShortNarrow POR DataOut",0,ShortNarrowDataOut);
      
      //
      // Wait for other tests to complete
      //
      @(posedge defaultTestComplete);


      //
      // All Done
      //
      TEST.all_tests_completed();
   end
     
endmodule // tb_fifo
