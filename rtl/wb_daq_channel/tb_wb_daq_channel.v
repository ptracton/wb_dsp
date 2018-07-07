//                              -*- Mode: Verilog -*-
// Filename        : tb_fifo.v
// Description     : fifo test bench
// Author          : ptracton
// Created On      : Mon Jul  2 20:26:10 2018
// Last Modified By: ptracton
// Last Modified On: Mon Jul  2 20:26:10 2018
// Update Count    : 0
// Status          : Unknown, Use with caution!

module tb_wb_daq_channel (/*AUTOARG*/) ;

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

   localparam ADC_CLK_PERIOD=1000;   
   reg adc_clk;
   initial begin
      adc_clk = 0;      
      forever
	#(ADC_CLK_PERIOD/2) adc_clk <= ~adc_clk;      
   end
   
   //
   // General purpose test support
   //
   test_tasks #("wb_daq_channel",
		9) TEST();

   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [31:0]	data_out;		// From dut of wb_daq_channel.v
   wire 	fifo_empty;		// From dut of wb_daq_channel.v
   wire 	start_sram;		// From dut of wb_daq_channel.v

   reg 		adc_enable;
   reg 		master_enable;
   reg [31:0] 	control;                        // FW controlled register
   reg [4:0] 	fifo_number_samples_terminal;   // FW controlled register
   reg 		data_done;
   wire [7:0] 	adc_data_out;
   
   
   wb_daq_channel dut(
		      // Outputs
		      .data_out		(data_out),
		      .start_sram	(start_sram),
		      .fifo_empty	(fifo_empty),
		      // Inputs
		      .wb_clk		(wb_clk),
		      .wb_rst		(wb_rst),
		      .adc_clk		(adc_clk),
		      .master_enable	(master_enable),
		      .control		(control),
		      .data_done	(data_done),
		      .fifo_number_samples_terminal(fifo_number_samples_terminal),
		      .adc_data_out	(adc_data_out),
		      .adc_data_ready	(adc_data_ready));
   

   adc #(8, "adc_00.mem") 
   adc0(
	// Outputs
	.data_out(adc_data_out), 
	.data_ready(adc_data_ready),
	// Inputs
	.adc_clk(adc_clk), 
	.wb_clk(wb_clk), 
	.wb_rst(wb_rst), 
	.enable(adc_enable)
	) ;
   

   //
   // Measure the width of the PUSH pulse to make sure it is not too long or short.
   // Short pulses could miss data being stored.
   // Long pulses could store the data multiple times.
   //
   time 		  PopStart;
   time 		  PushStart;

   // Get the time the pulse goes high
   always @(posedge dut.fifo_pop)
     PopStart <= $time;

   // At the falling edge, find the difference from the start time and confirm width
   // If we do not match the clk period, error out!
   always @(negedge dut.fifo_pop) begin
      if ($time - PopStart != WB_CLK_PERIOD) begin
	 TEST.compare_values("Pop wrong size!", WB_CLK_PERIOD, $time-PopStart);
      end
   end

   always @(posedge dut.fifo_push)
     PushStart <= $time;

   // At the falling edge, find the difference from the start time and confirm width
   // If we do not match the clk period, error out!
   always @(negedge dut.fifo_push) begin
      if ($time - PushStart != WB_CLK_PERIOD) begin
	 TEST.compare_values("Push wrong size!", WB_CLK_PERIOD, $time-PushStart);
      end
   end


   localparam STATE_IDLE = 4'h0;
   localparam STATE_CAPTURE_SRAM_DATA = 4'h1;
   localparam STATE_DATA_DONE = 4'h2;
   
   reg [3:0] state;
   reg [3:0] next_state; 
   reg [31:0] capture_sram_data;
   
   always @(posedge wb_clk)
     if (wb_rst) begin
	state <= 0;	
     end else begin
	state <= next_state;	
     end

   always @(*)
     if (wb_rst) begin
	data_done = 0;
	next_state = 0;
	capture_sram_data = 0;	
     end else begin
	case (state)
	  STATE_IDLE : begin
	     data_done = 0;
	     next_state = 0;
	     capture_sram_data = 0;	     
	     if (start_sram) begin
		next_state = STATE_CAPTURE_SRAM_DATA;
	     end else begin
		next_state = STATE_IDLE;		
	     end
	  end // case: STATE_IDLE
	  
	  STATE_CAPTURE_SRAM_DATA: begin
	     capture_sram_data = data_out;
	     data_done = 1;	     
	     next_state = STATE_DATA_DONE;	     
	  end
	  
	  STATE_DATA_DONE:begin
	     if (start_sram) begin
		next_state = STATE_CAPTURE_SRAM_DATA;		
	     end else begin
		next_state = STATE_IDLE;		
	     end
	  end
	  
	  default:begin
	     next_state = STATE_IDLE;
	  end
	endcase // case (state)	
     end // else: !if(wb_rst)

   
   initial begin
      adc_enable = 0;
      master_enable = 0;
      control = 0;
      fifo_number_samples_terminal = 4;
      data_done = 0;      
      
      //
      // Wait for reset to release
      //
      @(negedge wb_rst);
      repeat(5) @(posedge wb_clk);
      adc_enable = 1;    // Turn on ADC
      control[0] = 1;       // Turn on channel
      master_enable = 1; // Turn on channel
       
      
      repeat(60) @(posedge adc_clk);
      
      TEST.all_tests_completed();
   end
   
endmodule // tb_fifo
