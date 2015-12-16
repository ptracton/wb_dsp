//                              -*- Mode: Verilog -*-
// Filename        : wb_daq_channel.v
// Description     : WB Data Acquisition Channel
// Author          : Philip Tracton
// Created On      : Wed Dec 16 12:30:23 2015
// Last Modified By: Philip Tracton
// Last Modified On: Wed Dec 16 12:30:23 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!
module wb_daq_channel (/*AUTOARG*/
   // Outputs
   data_out, start_sram,
   // Inputs
   wb_clk, wb_rst, adc_clk, enable
   ) ;


   parameter dw = 32;
   parameter adc_dw = 8;
   parameter adc_image = "";

   input wb_clk;
   input wb_rst;
   input adc_clk;
   input enable;
   output wire [dw-1:0] data_out;
   output wire         start_sram;
   

   wire [adc_dw-1:0]   adc_data_out;   
   wire                adc_data_ready;
   
   adc #(.dw(adc_dw), .adc_image(adc_image))
   adc0(
        // Outputs
        .data_out(adc_data_out), 
        .data_ready(adc_data_ready),
        // Inputs
        .adc_clk(adc_clk), 
        .wb_clk(wb_clk), 
        .wb_rst(wb_rst), 
        .enable(enable)
        ) ;

   wire [dw-1:0]       aggregate_data_out;   
   wire                fifo_push;
   
   wb_daq_data_aggregation #(.dw(dw), .adc_dw(adc_dw))
     aggregate(
               // Outputs
               .data_out(aggregate_data_out),
               .fifo_push(fifo_push),
               
               // Inputs
               .wb_clk(wb_clk), 
               .wb_rst(wb_rst), 
               .data_ready(adc_data_ready), 
               .data_width(0), 
               .adc_data_in(adc_data_out)
               ) ;

   wire [dw-1:0]       fifo_data_out;   
   wire                fifo_empty;
   wire                fifo_full;
   wire [7:0]          fifo_number_samples;
   
   fifo #(.dw(dw), .depth(16))
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

   fifo_to_sram fifo_to_sram0(
                              // Outputs
                              .pop(fifo_pop),
                              .sram_data_out(data_out), 
                              .sram_start(start_sram),
                              // Inputs
                              .wb_clk(wb_clk), 
                              .wb_rst(wb_rst),
                              .empty(fifo_empty),
                              .full(fifo_full),
                              .fifo_data_in(fifo_data_out)
                              ) ;
   
endmodule // wb_daq_channel