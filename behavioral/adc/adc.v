//                              -*- Mode: Verilog -*-
// Filename        : adc.v
// Description     : Behavioral ADC Model
// Author          : Philip Tracton
// Created On      : Wed Dec 16 12:36:20 2015
// Last Modified By: Philip Tracton
// Last Modified On: Wed Dec 16 12:36:20 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!
`include "wb_dsp_includes.vh"


module adc (/*AUTOARG*/
   // Outputs
   data_out, data_ready,
   // Inputs
   adc_clk, wb_clk, wb_rst, enable
   ) ;

   parameter dw = 8;
   parameter adc_image = "";
   
   input adc_clk;
   input wb_clk;   
   input wb_rst;
   input enable;

   output reg [dw-1:0] data_out;
   output reg          data_ready;   

   reg [dw-1:0]        memory [1023:0];
   reg [31:0]          index;
   reg [31:0]          previous_index;
   
   initial begin
      $readmemh(adc_image, memory);      
   end

   //
   // Detect a change in the index (different clock domain) and
   // if we are a new sample (data_ready). If so indicate this
   // via the data_ready signal which we will hold for a single clock
   // cycle.  This is meant for the next block to know it is time
   // to read and capture the output from the ADC
   //
   always @(posedge wb_clk)
     if (wb_rst) begin
        data_ready <= 0;
        previous_index <=0;        
     end else begin
        if ((index != previous_index)) begin
           data_ready <= 1;     
           previous_index <= index;           
        end else begin
           data_ready <= 0;           
        end
     end   
   
   always @(posedge adc_clk)
     if (wb_rst) begin
        data_out <=0;
        index <= 0;        
     end else begin
        if (enable) begin
           data_out <= memory[index];
           index <= index + 1;           
        end else begin
           data_out <= 0;
           index  = 0;           
        end
     end // else: !if(rst)   
   
endmodule // adc