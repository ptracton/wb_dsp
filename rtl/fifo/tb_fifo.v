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
		274) TEST();
   
   
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
      // Wait for other tests to complete
      //
      @(posedge defaultTestComplete);

      //
      // Check Initial Conditions
      //
      TEST.compare_values("ShortNarrow POR FULL",0,ShortNarrowFull);      
      TEST.compare_values("ShortNarrow POR Empty",1,ShortNarrowEmpty);
      TEST.compare_values("ShortNarrow POR DataOut",0,ShortNarrowDataOut);


      //
      // Push FIFO Until Full
      //
      for (i=0; i< ShortNarrowDepth; i=i+1) begin
	 @(posedge wb_clk);
	 ShortNarrowDataIn <= 8'hFF - i;
	 ShortNarrowPush <= 1;
	 @(posedge wb_clk);
	 ShortNarrowPush <= 0;
	 TEST.compare_values("ShortNarrow Push Number Samples",i,ShortNarrowNumberSamples);	 
      end

      #1 TEST.compare_values("ShortNarrow Assert FULL",1,ShortNarrowFull);
      TEST.compare_values("ShortNarrow Clear Empty",0,ShortNarrowEmpty);


      //
      // Read back values to confirm write and read operations until we are empty
      //
      for (i=0; i<ShortNarrowDepth; i=i+1) begin
	 @(posedge wb_clk);
	 TEST.compare_values("ShortNarrow Read", 
			     8'hFF - i, 
			     ShortNarrowDataOut);
	 @(posedge wb_clk);
	 ShortNarrowPop <= 1;
	 @(posedge wb_clk);
	 ShortNarrowPop <= 0;
      end

      #1 TEST.compare_values("ShortNarrow Clear FULL",0,ShortNarrowFull);
      TEST.compare_values("ShortNarrow Assert Empty",1,ShortNarrowEmpty);

      //
      // RESET to clear last test
      //
      wb_rst = 1;
      repeat(2) @(posedge wb_clk);
      wb_rst = 0;
      
      //
      // Reload FIFO and cause a wrap around and check results
      //
      for (i=0; i< ShortNarrowDepth*2; i=i+1) begin
	 @(posedge wb_clk);
	 ShortNarrowDataIn <= 8'hAA - i;
	 ShortNarrowPush <= 1;
	 @(posedge wb_clk);
	 ShortNarrowPush <= 0;
      end
      
      #1 TEST.compare_values("ShortNarrow Wrap Around Assert FULL",1,ShortNarrowFull);
      TEST.compare_values("ShortNarrow Wrap Around Clear Empty",0,ShortNarrowEmpty);	 
      
      for (i=ShortNarrowDepth; i<ShortNarrowDepth*2; i=i+1) begin
	 @(posedge wb_clk);
	 TEST.compare_values("ShortNarrow Wrap Around Read", 
			     8'hAA - i, 
			     ShortNarrowDataOut);
	 @(posedge wb_clk);
	 ShortNarrowPop <= 1;
	 @(posedge wb_clk);
	 ShortNarrowPop <= 0;
      end      
      
      //
      // All Done
      //
      ShortNarrowTestComplete <= 1;
   end

   localparam LongWideDW = 64;
   localparam LongWideDepth = 64;
   
   wire [LongWideDW-1:0]	LongWideDataOut;	
   wire			LongWideEmpty;	
   wire			LongWideFull;	
   wire [$clog2(LongWideDepth):0] LongWideNumberSamples;
   
   reg 			LongWidePush;
   reg 			LongWidePop;
   reg [LongWideDW-1:0] 	LongWideDataIn;
   reg 			LongWideTestComplete;
   
   //
   // LongWide Values FIFO
   //
   fifo #(LongWideDW, LongWideDepth) 
   dutLongWide(
		  // Outputs
		  .data_out		(LongWideDataOut),
		  .empty		(LongWideEmpty),
		  .full 		(LongWideFull),
		  .number_samples	(LongWideNumberSamples),
		  // Inputs
		  .wb_clk		(wb_clk),
		  .wb_rst		(wb_rst),
		  .push	        	(LongWidePush),
		  .pop			(LongWidePop),
		  .data_in		(LongWideDataIn));
   
   initial begin

      //
      // Clean up input and test signals
      //
      LongWidePush <= 0;
      LongWidePop <= 0;
      LongWideDataIn <= 0;
      LongWideTestComplete <= 0;

      //
      // Wait for reset to release
      //
      @(negedge wb_rst);

      
      //
      // Wait for other tests to complete
      //
      @(posedge ShortNarrowTestComplete);

      //
      // Check Initial Conditions
      //
      TEST.compare_values("LongWide POR FULL",0,LongWideFull);      
      TEST.compare_values("LongWide POR Empty",1,LongWideEmpty);
      TEST.compare_values("LongWide POR DataOut",0,LongWideDataOut);


      //
      // Push FIFO Until Full
      //
      for (i=0; i< LongWideDepth; i=i+1) begin
	 @(posedge wb_clk);
	 LongWideDataIn <= 64'hdead_beef_C7C7_A5A5 - i;
	 LongWidePush <= 1;
	 @(posedge wb_clk);
	 LongWidePush <= 0;
	 TEST.compare_values("LongWide Push Number Samples",i,LongWideNumberSamples);	 
      end

      #1 TEST.compare_values("LongWide Assert FULL",1,LongWideFull);
      TEST.compare_values("LongWide Clear Empty",0,LongWideEmpty);


      //
      // Read back values to confirm write and read operations until we are empty
      //
      for (i=0; i<LongWideDepth; i=i+1) begin
	 @(posedge wb_clk);
	 TEST.compare_values("LongWide Read", 
			     64'hdead_beef_C7C7_A5A5 - i, 
			     LongWideDataOut);
	 @(posedge wb_clk);
	 LongWidePop <= 1;
	 @(posedge wb_clk);
	 LongWidePop <= 0;
      end

      #1 TEST.compare_values("LongWide Clear FULL",0,LongWideFull);
      TEST.compare_values("LongWide Assert Empty",1,LongWideEmpty);

      //
      // RESET to clear last test
      //
      wb_rst = 1;
      repeat(2) @(posedge wb_clk);
      wb_rst = 0;
      
      //
      // Reload FIFO and cause a wrap around and check results
      //
      for (i=0; i< LongWideDepth*2; i=i+1) begin
	 @(posedge wb_clk);
	 LongWideDataIn <= 8'hAA - i;
	 LongWidePush <= 1;
	 @(posedge wb_clk);
	 LongWidePush <= 0;
      end
      
      #1 TEST.compare_values("LongWide Wrap Around Assert FULL",1,LongWideFull);
      TEST.compare_values("LongWide Wrap Around Clear Empty",0,LongWideEmpty);	 
      
      for (i=LongWideDepth; i<LongWideDepth*2; i=i+1) begin
	 @(posedge wb_clk);
	 TEST.compare_values("LongWide Wrap Around Read", 
			     8'hAA - i, 
			     LongWideDataOut);
	 @(posedge wb_clk);
	 LongWidePop <= 1;
	 @(posedge wb_clk);
	 LongWidePop <= 0;
      end      
      
      //
      // All Done
      //
      LongWideTestComplete <= 1;
      TEST.all_tests_completed();
   end

     
endmodule // tb_fifo
