//                              -*- Mode: Verilog -*-
// Filename        : tb_wb_daq_data_aggregation.v
// Description     : Test Bench for wb_daq_data_aggregation
// Author          : ptracton
// Created On      : Tue Jul  3 20:15:03 2018
// Last Modified By: ptracton
// Last Modified On: Tue Jul  3 20:15:03 2018
// Update Count    : 0
// Status          : Unknown, Use with caution!

module tb_wb_daq_data_aggregation (/*AUTOARG*/) ;

   // For a testbench this is ok
   /* verilator lint_off STMTDLY */
   
   /*AUTOWIRE*/
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
   test_tasks #("wb_daq_data_aggregation",
		28) TEST();


   //
   // Default Configuration Testing
   //
   localparam defaultADCDW = 8;

   wire [31:0] defaultDataOut;
   wire        defaultFIFOPush;
   reg 	       defaultDataReady;
   reg [defaultADCDW-1:0] defaultADCDataIn;
   reg 			  defaultSignedData;
   reg 			  defaultTestsDone;
   
   wb_daq_data_aggregation dutDefault(/*AUTOINST*/
				      // Outputs
				      .data_out		(defaultDataOut),
				      .fifo_push	(defaultFIFOPush),
				      // Inputs
				      .wb_clk		(wb_clk),
				      .wb_rst		(wb_rst),
				      .signed_data      (defaultSignedData),
				      .data_ready	(defaultDataReady),
				      .adc_data_in	(defaultADCDataIn)
				      );

   //
   // Measure the width of the PUSH pulse to make sure it is not too long or short.
   // Short pulses could miss data being stored.
   // Long pulses could store the data multiple times.
   //
   time 		  defaultPushStart;

   // Get the time the pulse goes high
   always @(posedge defaultFIFOPush)
     defaultPushStart <= $time;

   // At the falling edge, find the difference from the start time and confirm width
   // If we do not match the clk period, error out!
   always @(negedge defaultFIFOPush) begin
      if ($time - defaultPushStart != WB_CLK_PERIOD) begin
	 TEST.compare_values("defaultPush wrong size!", WB_CLK_PERIOD, $time-defaultPushStart);
      end
   end
   
   initial begin

      //
      // Initialize the test inputs
      //
      defaultDataReady <= 0;
      defaultSignedData <= 0;
      defaultADCDataIn <= 0;
      defaultTestsDone <= 0;
      
      
      //
      // Wait for reset to release before doing anything
      // 
      @(negedge wb_rst);

      repeat(2) @(posedge wb_clk);

      //
      // Check POR Values
      //
      TEST.compare_values("POR defaultDataOut", 0, defaultDataOut);
      TEST.compare_values("POR defaultFIFopush", 0, defaultFIFOPush);

      //
      // Write out 4 bytes and see if signal is sent to push into FIFO
      //
      @(posedge wb_clk);
      defaultADCDataIn <= 8'hAA;
      defaultDataReady <= 1;
      @(posedge wb_clk);
      defaultDataReady <= 0;

      @(posedge wb_clk);
      defaultADCDataIn <= 8'hBB;
      defaultDataReady <= 1;
      @(posedge wb_clk);
      defaultDataReady <= 0;

      @(posedge wb_clk);
      defaultADCDataIn <= 8'hCC;
      defaultDataReady <= 1;
      @(posedge wb_clk);
      defaultDataReady <= 0;

      @(posedge wb_clk);
      defaultADCDataIn <= 8'hDD;
      defaultDataReady <= 1;
      @(posedge wb_clk);
      defaultDataReady <= 0;

      @(posedge defaultFIFOPush);
      TEST.compare_values("default to FIFO", 32'hDDCCBBAA, defaultDataOut);

      @(posedge wb_clk);
      defaultADCDataIn <= 8'h11;
      defaultDataReady <= 1;
      @(posedge wb_clk);
      defaultDataReady <= 0;

      @(posedge wb_clk);
      defaultADCDataIn <= 8'h22;
      defaultDataReady <= 1;
      @(posedge wb_clk);
      defaultDataReady <= 0;

      @(posedge wb_clk);
      defaultADCDataIn <= 8'h33;
      defaultDataReady <= 1;
      @(posedge wb_clk);
      defaultDataReady <= 0;

      @(posedge wb_clk);
      defaultADCDataIn <= 8'h44;
      defaultDataReady <= 1;
      @(posedge wb_clk);
      defaultDataReady <= 0;

      @(posedge defaultFIFOPush);
      TEST.compare_values("default to FIFO2", 32'h44332211, defaultDataOut);

      
      defaultTestsDone <= 1;
      
   end // initial begin


   //
   // 10 bit data testing
   //
   localparam width10ADCDW = 10;

   wire [31:0] width10DataOut;
   wire        width10FIFOPush;
   reg 	       width10DataReady;
   reg [width10ADCDW-1:0] width10ADCDataIn;
   reg 			  width10SignedData;
   reg 			  width10TestsDone;
   
   wb_daq_data_aggregation #(width10ADCDW)
   dutWidth10(/*AUTOINST*/
	      // Outputs
	      .data_out		(width10DataOut),
	      .fifo_push	(width10FIFOPush),
	      // Inputs
	      .wb_clk		(wb_clk),
	      .wb_rst		(wb_rst),
	      .signed_data      (width10SignedData),
	      .data_ready	(width10DataReady),
	      .adc_data_in	(width10ADCDataIn)
	      );

   //
   // Measure the width of the PUSH pulse to make sure it is not too long or short.
   // Short pulses could miss data being stored.
   // Long pulses could store the data multiple times.
   //
   time 		  width10PushStart;

   // Get the time the pulse goes high
   always @(posedge width10FIFOPush)
     width10PushStart <= $time;

   // At the falling edge, find the difference from the start time and confirm width
   // If we do not match the clk period, error out!
   always @(negedge width10FIFOPush) begin
      if ($time - width10PushStart != WB_CLK_PERIOD) begin
	 TEST.compare_values("width10Push wrong size!", WB_CLK_PERIOD, $time-width10PushStart);
      end
   end


   initial begin

      //
      // Initialize the test inputs
      //
      width10DataReady <= 0;
      width10SignedData <= 0;
      width10ADCDataIn <= 0;
      width10TestsDone <= 0;
      
      
      //
      // Wait for previous tests to compelte
      // 
      @(posedge defaultTestsDone);

      repeat(2) @(posedge wb_clk);

      //
      // Check POR Values
      //
      TEST.compare_values("POR width10DataOut", 0, width10DataOut);
      TEST.compare_values("POR width10FIFopush", 0, defaultFIFOPush);

      //
      // Test out unsigned data
      //
      @(posedge wb_clk);
      width10ADCDataIn <= 10'h3ad;
      width10DataReady <= 1;
      @(posedge wb_clk);
      width10DataReady <= 0;

      @(posedge wb_clk);
      width10ADCDataIn <= 10'h0ef;
      width10DataReady <= 1;
      @(posedge wb_clk);
      width10DataReady <= 0;

      @(posedge width10FIFOPush);
      TEST.compare_values("width10 unsigned data to FIFO", 32'h00ef03ad, width10DataOut);
      
      @(posedge wb_clk);
      width10ADCDataIn <= 10'h001;
      width10DataReady <= 1;
      @(posedge wb_clk);
      width10DataReady <= 0;

      @(posedge wb_clk);
      width10ADCDataIn <= 10'h200;
      width10DataReady <= 1;
      @(posedge wb_clk);
      width10DataReady <= 0;

      @(posedge width10FIFOPush);
      TEST.compare_values("width10 unsigned data to FIFO2", 32'h0200_0001, width10DataOut);

   
      //
      // Test out signed data
      //
      width10SignedData <= 1;

      
      @(posedge wb_clk);
      width10ADCDataIn <= 10'h3ad;
      width10DataReady <= 1;
      @(posedge wb_clk);
      width10DataReady <= 0;

      @(posedge wb_clk);
      width10ADCDataIn <= 10'h2ef;
      width10DataReady <= 1;
      @(posedge wb_clk);
      width10DataReady <= 0;

      @(posedge width10FIFOPush);
      TEST.compare_values("width10 signed data to FIFO", 32'hfeefffad, width10DataOut);
      

      @(posedge wb_clk);
      width10ADCDataIn <= 10'h0C0;
      width10DataReady <= 1;
      @(posedge wb_clk);
      width10DataReady <= 0;

      @(posedge wb_clk);
      width10ADCDataIn <= 10'h3FF;
      width10DataReady <= 1;
      @(posedge wb_clk);
      width10DataReady <= 0;

      @(posedge width10FIFOPush);
      TEST.compare_values("width10 signed data to FIFO", 32'hffff_00C0, width10DataOut);
      
      width10TestsDone <= 1;
      
   end


   //
   // 16 bit data testing
   //
   localparam width16ADCDW = 16;

   wire [31:0] width16DataOut;
   wire        width16FIFOPush;
   reg 	       width16DataReady;
   reg [width16ADCDW-1:0] width16ADCDataIn;
   reg 			  width16SignedData;
   reg 			  width16TestsDone;
   
   wb_daq_data_aggregation #(width16ADCDW)
   dutWidth16(/*AUTOINST*/
	      // Outputs
	      .data_out		(width16DataOut),
	      .fifo_push	(width16FIFOPush),
	      // Inputs
	      .wb_clk		(wb_clk),
	      .wb_rst		(wb_rst),
	      .signed_data      (width16SignedData),
	      .data_ready	(width16DataReady),
	      .adc_data_in	(width16ADCDataIn)
	      );

   //
   // Measure the width of the PUSH pulse to make sure it is not too long or short.
   // Short pulses could miss data being stored.
   // Long pulses could store the data multiple times.
   //
   time 		  width16PushStart;

   // Get the time the pulse goes high
   always @(posedge width16FIFOPush)
     width16PushStart <= $time;

   // At the falling edge, find the difference from the start time and confirm width
   // If we do not match the clk period, error out!
   always @(negedge width16FIFOPush) begin
      if ($time - width16PushStart != WB_CLK_PERIOD) begin
	 TEST.compare_values("width16Push wrong size!", WB_CLK_PERIOD, $time-width16PushStart);
      end
   end


   initial begin

      //
      // Initialize the test inputs
      //
      width16DataReady <= 0;
      width16SignedData <= 0;
      width16ADCDataIn <= 0;
      width16TestsDone <= 0;
      
      
      //
      // Wait for previous tests to compelte
      // 
      @(posedge width10TestsDone);

      repeat(2) @(posedge wb_clk);

      //
      // Check POR Values
      //
      TEST.compare_values("POR width16DataOut", 0, width16DataOut);
      TEST.compare_values("POR width16FIFopush", 0, defaultFIFOPush);

      //
      // Test out unsigned data
      //
      @(posedge wb_clk);
      width16ADCDataIn <= 16'hF000;
      width16DataReady <= 1;
      @(posedge wb_clk);
      width16DataReady <= 0;

      @(posedge wb_clk);
      width16ADCDataIn <= 16'h05A0;
      width16DataReady <= 1;
      @(posedge wb_clk);
      width16DataReady <= 0;

      @(posedge width16FIFOPush);
      TEST.compare_values("width16 unsigned data to FIFO", 32'h05A0F000, width16DataOut);

      @(posedge wb_clk);
      width16ADCDataIn <= 16'h0FFF;
      width16DataReady <= 1;
      @(posedge wb_clk);
      width16DataReady <= 0;

      @(posedge wb_clk);
      width16ADCDataIn <= 16'hA005;
      width16DataReady <= 1;
      @(posedge wb_clk);
      width16DataReady <= 0;

      @(posedge width16FIFOPush);
      TEST.compare_values("width16 unsigned data 2 to FIFO", 32'hA0050FFF, width16DataOut);
   
      //
      // Test out signed data
      //
      width16SignedData <= 1;

      
      @(posedge wb_clk);
      width16ADCDataIn <= 16'h8ad0;
      width16DataReady <= 1;
      @(posedge wb_clk);
      width16DataReady <= 0;

      @(posedge wb_clk);
      width16ADCDataIn <= 16'h2ef0;
      width16DataReady <= 1;
      @(posedge wb_clk);
      width16DataReady <= 0;

      @(posedge width16FIFOPush);
      TEST.compare_values("width16 signed data to FIFO", 32'hf2ef0_8ad0, width16DataOut);
      
      @(posedge wb_clk);
      width16ADCDataIn <= 16'h00a5;
      width16DataReady <= 1;
      @(posedge wb_clk);
      width16DataReady <= 0;

      @(posedge wb_clk);
      width16ADCDataIn <= 16'hF00F;
      width16DataReady <= 1;
      @(posedge wb_clk);
      width16DataReady <= 0;

      @(posedge width16FIFOPush);
      TEST.compare_values("width16 signed data to FIFO", 32'hF00F00a5, width16DataOut);
      
      
      width16TestsDone <= 1;
      
   end
     
   //
   // 18 bit data testing
   //
   localparam width18ADCDW = 18;

   wire [31:0] width18DataOut;
   wire        width18FIFOPush;
   reg 	       width18DataReady;
   reg [width18ADCDW-1:0] width18ADCDataIn;
   reg 			  width18SignedData;
   reg 			  width18TestsDone;
   
   wb_daq_data_aggregation #(width18ADCDW)
   dutWidth18(/*AUTOINST*/
	      // Outputs
	      .data_out		(width18DataOut),
	      .fifo_push	(width18FIFOPush),
	      // Inputs
	      .wb_clk		(wb_clk),
	      .wb_rst		(wb_rst),
	      .signed_data      (width18SignedData),
	      .data_ready	(width18DataReady),
	      .adc_data_in	(width18ADCDataIn)
	      );

   //
   // Measure the width of the PUSH pulse to make sure it is not too long or short.
   // Short pulses could miss data being stored.
   // Long pulses could store the data multiple times.
   //
   time 		  width18PushStart;

   // Get the time the pulse goes high
   always @(posedge width18FIFOPush)
     width18PushStart <= $time;

   // At the falling edge, find the difference from the start time and confirm width
   // If we do not match the clk period, error out!
   always @(negedge width18FIFOPush) begin
      if ($time - width18PushStart != WB_CLK_PERIOD) begin
	 TEST.compare_values("width18Push wrong size!", WB_CLK_PERIOD, $time-width18PushStart);
      end
   end


   initial begin

      //
      // Initialize the test inputs
      //
      width18DataReady <= 0;
      width18SignedData <= 0;
      width18ADCDataIn <= 0;
      width18TestsDone <= 0;
      
      
      //
      // Wait for previous tests to compelte
      // 
      @(posedge width16TestsDone);

      repeat(2) @(posedge wb_clk);

      //
      // Check POR Values
      //
      TEST.compare_values("POR width18DataOut", 0, width18DataOut);
      TEST.compare_values("POR width18FIFopush", 0, defaultFIFOPush);

      //
      // Test out unsigned data
      //
      @(posedge wb_clk);
      width18ADCDataIn <= 18'h30F00;
      width18DataReady <= 1;
      @(posedge wb_clk);
      width18DataReady <= 0;

      @(posedge width18FIFOPush);
      TEST.compare_values("width18 unsigned data to FIFO", 32'h00030F00, width18DataOut);

      @(posedge wb_clk);
      width18ADCDataIn <= 18'h20FFF;
      width18DataReady <= 1;
      @(posedge wb_clk);
      width18DataReady <= 0;


      @(posedge width18FIFOPush);
      TEST.compare_values("width18 unsigned data 2 to FIFO", 32'h00020FFF, width18DataOut);
   
      //
      // Test out signed data
      //
      width18SignedData <= 1;

      
      @(posedge wb_clk);
      width18ADCDataIn <= 18'h38ad0;
      width18DataReady <= 1;
      @(posedge wb_clk);
      width18DataReady <= 0;


      @(posedge width18FIFOPush);
      TEST.compare_values("width18 signed data to FIFO", 32'hFFFF8ad0, width18DataOut);
      
      @(posedge wb_clk);
      width18ADCDataIn <= 18'h000a5;
      width18DataReady <= 1;
      @(posedge wb_clk);
      width18DataReady <= 0;


      @(posedge width18FIFOPush);
      TEST.compare_values("width18 signed data to FIFO", 32'h000000a5, width18DataOut);
      
      
      width18TestsDone <= 1;
      
   end

   //
   // 32 bit data testing
   //
   localparam width32ADCDW = 32;

   wire [31:0] width32DataOut;
   wire        width32FIFOPush;
   reg 	       width32DataReady;
   reg [width32ADCDW-1:0] width32ADCDataIn;
   reg 			  width32SignedData;
   reg 			  width32TestsDone;
   
   wb_daq_data_aggregation #(width32ADCDW)
   dutWidth32(/*AUTOINST*/
	      // Outputs
	      .data_out		(width32DataOut),
	      .fifo_push	(width32FIFOPush),
	      // Inputs
	      .wb_clk		(wb_clk),
	      .wb_rst		(wb_rst),
	      .signed_data      (width32SignedData),
	      .data_ready	(width32DataReady),
	      .adc_data_in	(width32ADCDataIn)
	      );

   //
   // Measure the width of the PUSH pulse to make sure it is not too long or short.
   // Short pulses could miss data being stored.
   // Long pulses could store the data multiple times.
   //
   time 		  width32PushStart;

   // Get the time the pulse goes high
   always @(posedge width32FIFOPush)
     width32PushStart <= $time;

   // At the falling edge, find the difference from the start time and confirm width
   // If we do not match the clk period, error out!
   always @(negedge width32FIFOPush) begin
      if ($time - width32PushStart != WB_CLK_PERIOD) begin
	 TEST.compare_values("width32Push wrong size!", WB_CLK_PERIOD, $time-width32PushStart);
      end
   end


   initial begin

      //
      // Initialize the test inputs
      //
      width32DataReady <= 0;
      width32SignedData <= 0;
      width32ADCDataIn <= 0;
      width32TestsDone <= 0;
      
      
      //
      // Wait for previous tests to compelte
      // 
      @(posedge width18TestsDone);

      repeat(2) @(posedge wb_clk);

      //
      // Check POR Values
      //
      TEST.compare_values("POR width32DataOut", 0, width32DataOut);
      TEST.compare_values("POR width32FIFopush", 0, defaultFIFOPush);

      //
      // Test out unsigned data
      //
      @(posedge wb_clk);
      width32ADCDataIn <= 32'ha5b6c7d8;
      width32DataReady <= 1;
      @(posedge wb_clk);
      width32DataReady <= 0;

      @(posedge width32FIFOPush);
      TEST.compare_values("width32 unsigned data to FIFO", 32'ha5b6c7d8, width32DataOut);

      @(posedge wb_clk);
      width32ADCDataIn <= 32'h9eaf0123;
      width32DataReady <= 1;
      @(posedge wb_clk);
      width32DataReady <= 0;


      @(posedge width32FIFOPush);
      TEST.compare_values("width32 unsigned data 2 to FIFO", 32'h9eaf0123, width32DataOut);
   
      //
      // Test out signed data
      //
      width32SignedData <= 1;

      
      @(posedge wb_clk);
      width32ADCDataIn <= 32'hF0F0_F0F0;
      width32DataReady <= 1;
      @(posedge wb_clk);
      width32DataReady <= 0;


      @(posedge width32FIFOPush);
      TEST.compare_values("width32 signed data to FIFO", 32'hF0F0_F0F0, width32DataOut);
      
      @(posedge wb_clk);
      width32ADCDataIn <= 32'h0F0F_0F0F;
      width32DataReady <= 1;
      @(posedge wb_clk);
      width32DataReady <= 0;


      @(posedge width32FIFOPush);
      TEST.compare_values("width32 signed data to FIFO", 32'h0F0F_0F0F, width32DataOut);
      
      
      width32TestsDone <= 1;
      
      TEST.all_tests_completed();
   end

   
endmodule // tb_wb_daq_data_aggregation
