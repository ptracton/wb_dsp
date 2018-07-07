//                              -*- Mode: Verilog -*-
// Filename        : wb_daq_channel.v
// Description     : WB Data Acquisition Channel
// Author          : Philip Tracton
// Created On      : Wed Dec 16 12:30:23 2015
// Last Modified By: Philip Tracton
// Last Modified On: Wed Dec 16 12:30:23 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!


`include "wb_dsp_slave_registers_include.vh"

module wb_daq_channel (/*AUTOARG*/
   // Outputs
   data_out, start_sram, fifo_empty,
   // Inputs
   wb_clk, wb_rst, adc_clk, master_enable, control, data_done,
   fifo_number_samples_terminal, adc_data_out, adc_data_ready
   ) ;


   parameter dw = 32;
   parameter ADC_DATA_WIDTH = 8;
   parameter FIFO_DEPTH = 16;

   
   output wire [dw-1:0] data_out;
   output wire 		start_sram;
   output wire 		fifo_empty;
      
   input 		wb_clk;
   input 		wb_rst;
   input 		adc_clk;
   input 		master_enable;   
   input [dw-1:0] 	control;
   input 		data_done;   
   input [$clog2(FIFO_DEPTH):0] fifo_number_samples_terminal;
   
   

   input [ADC_DATA_WIDTH-1:0] adc_data_out;   
   input 		      adc_data_ready;
   wire 		      enable = master_enable & control[0];
   wire [dw-1:0] 	      aggregate_data_out;   
   wire 		      fifo_push;

   wire 		      signed_data = control[`CONTROL_REG_SIGNED_DATA];   
   
   wire [dw-1:0] 	      fifo_data_out;   
   wire 		      fifo_full;
   wire [$clog2(FIFO_DEPTH):0] fifo_number_samples;
   
   //
   // Aggregate the data into 32 bits wide.  This way the FIFO has data ready
   // to push out to SRAM
   //
   wb_daq_data_aggregation #(.ADC_DATA_WIDTH(ADC_DATA_WIDTH))
     aggregate(
               // Outputs
               .data_out(aggregate_data_out),
               .fifo_push(fifo_push),
               
               // Inputs
               .wb_clk(wb_clk), 
               .wb_rst(wb_rst), 
               .data_ready(adc_data_ready), 
	       .signed_data(signed_data),
               .adc_data_in(adc_data_out)
               ) ;

   //
   // FIFO for holding the aggregated data,  
   //
   fifo #(.dw(dw), .depth(FIFO_DEPTH))
   fifo0(
         // Outputs
         .data_out(fifo_data_out), 
         .empty(fifo_empty), 
         .full(fifo_full), 
         .number_samples(fifo_number_samples),
         // Inputs
         .wb_clk(wb_clk), 
         .wb_rst(wb_rst), 
         .push(fifo_push), 
         .pop(fifo_pop), 
         .data_in(aggregate_data_out)
         ) ;


   //
   // Once there are enough samples in the FIFO, pull data from FIFO
   // and move to state machine to write to SRAM
   //
   fifo_to_sram #(FIFO_DEPTH)
   fifo_to_sram0(
                 // Outputs
                 .pop(fifo_pop),
                 .sram_data_out(data_out), 
                 .sram_start(start_sram),
                 // Inputs
                 .wb_clk(wb_clk), 
                 .wb_rst(wb_rst),
                 .data_done(data_done),
                 .fifo_number_samples(fifo_number_samples),
		 .fifo_number_samples_terminal(fifo_number_samples_terminal),
		 .empty(fifo_empty),
		 .fifo_data_in(fifo_data_out)
		 ) ;
   
endmodule // wb_daq_channel
