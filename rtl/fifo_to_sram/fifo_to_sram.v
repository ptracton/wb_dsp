//                              -*- Mode: Verilog -*-
// Filename        : fifo_to_sram.v
// Description     : FIFO to SRAM
// Author          : Philip Tracton
// Created On      : Wed Dec 16 13:48:34 2015
// Last Modified By: Philip Tracton
// Last Modified On: Wed Dec 16 13:48:34 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!

module fifo_to_sram (/*AUTOARG*/
   // Outputs
   pop, sram_data_out, sram_start,
   // Inputs
   wb_clk, wb_rst, empty, fifo_number_samples,
   fifo_number_samples_terminal, data_done, fifo_data_in
   ) ;

   parameter FIFO_DEPTH = 16;   
   parameter DEBUG = 1;
   
   input wb_clk;
   input wb_rst;
   input empty;
   input [$clog2(FIFO_DEPTH):0] fifo_number_samples;   
   input [$clog2(FIFO_DEPTH):0] fifo_number_samples_terminal;
   input       data_done;   
   output reg  pop;
   input [31:0] fifo_data_in;
   output reg [31:0] sram_data_out;
   output reg          sram_start;


   //
   // State machine variables and state names
   //
   reg [2:0] 	       state;
   reg [2:0] 	       next_state;
   localparam STATE_IDLE = 3'h0;
   localparam STATE_READ_FIFO = 3'h1;
   localparam STATE_WAIT_SRAM_DONE = 3'h2;
   localparam STATE_LAST_SAMPLE = 3'h3;
   localparam STATE_LAST_SAMPLE_DONE = 3'h4;
   

   //
   // Once there are enough samples in the FIFO, we can start to unload it and write it to SRAM
   //
   wire start_state_machine = fifo_number_samples >= fifo_number_samples_terminal;
   
   //
   // Synchronous phase of the state machine.
   // The state we are processing can only change on a clock edge
   //
   always @(posedge wb_clk)
     if (wb_rst) begin
	state <= STATE_IDLE;
     end else begin
	state <= next_state;	
     end

   
   //
   // Asynchronous element of state machine that does all the work
   //
   always @(*)
     if (wb_rst) begin
	pop = 0;
	sram_data_out = 0;
	sram_start = 0;
     end else begin
	
	case (state)

	  //
	  // Do nothing and wait for data to be loaded into the FIFO.
	  // All control signals should be zero here.
	  //
	  STATE_IDLE: begin
	     pop = 0;
	     sram_data_out = 0;
	     sram_start = 0;
	     if (start_state_machine) begin
		next_state = STATE_READ_FIFO;		
	     end else begin
		next_state = STATE_IDLE;		
	     end
	  end

	  //
	  // There are enough samples in the FIFO, read the current one and pop to the next one
	  // Also signal the SRAM state machine to start processing the data we are sending it
	  //
	  STATE_READ_FIFO: begin
	     sram_data_out = fifo_data_in;
	     pop = 1;
	     sram_start = 1;
	     next_state = STATE_WAIT_SRAM_DONE;
	  end

	  //
	  // Wait for the SRAM Bus Master to indicate we are done writing the last sample out.
	  //
	  STATE_WAIT_SRAM_DONE: begin
	     sram_start = 0;
	     pop = 0;	     
	     if (data_done) begin
		if (empty) begin
		   next_state = STATE_LAST_SAMPLE;		   
		end else 
		  next_state = STATE_READ_FIFO;
	     end else begin
		next_state = STATE_WAIT_SRAM_DONE;
	     end
	  end // case: STATE_WAIT_SRAM_DONE
	  

	  //
	  // This is the last sample to process.  No need to pop since the FIFO
	  // is now empty.
	  //
	  STATE_LAST_SAMPLE: begin
	     sram_data_out = fifo_data_in;
	     sram_start = 1;
	     next_state = STATE_LAST_SAMPLE_DONE;
	  end

	  //
	  // Once ware are done with the last sample, return to IDLE
	  //
	  STATE_LAST_SAMPLE_DONE:begin
	     if (data_done) begin
		next_state = STATE_IDLE;
	     end else begin
		next_state = STATE_LAST_SAMPLE_DONE;		
	     end
	  end
	  
	  default:begin
	     next_state = STATE_IDLE;	     
	  end
  
	endcase // case (state)
	
     end // else: !if(wb_rst)

   reg [(30*8)-1:0] state_name;
   
   always @(wb_clk)
     if (wb_rst) begin 
	state_name = "STATE IDLE";	
     end else begin
	if (DEBUG) begin
	   case (state)
	     STATE_IDLE: state_name = "STATE IDLE";
	     STATE_READ_FIFO: state_name = "STATE READ FIFO";
	     STATE_WAIT_SRAM_DONE: state_name = "STATE WAIT SRAM DONE";
	     STATE_LAST_SAMPLE: state_name = "STATE LAST SAMPLE";
	     STATE_LAST_SAMPLE_DONE: state_name = "STATE LAST SAMPLE DONE";	     
	     default: state_name = "DEFAULT!";
	     
	   endcase // case (state)	
	end
     end // else: !if(wb_rst)
   
   
endmodule // fifo_to_sram
