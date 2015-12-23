//                              -*- Mode: Verilog -*-
// Filename        : adc_clk_gen.v
// Description     : ADC Clock Generator
// Author          : Philip Tracton
// Created On      : Tue Dec 22 21:44:39 2015
// Last Modified By: Philip Tracton
// Last Modified On: Tue Dec 22 21:44:39 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!

module adc_clk_gen (/*AUTOARG*/
   // Outputs
   adc_clk,
   // Inputs
   wb_clk, rst_pad_i, clk_speed_select
   ) ;
   input wb_clk;
   input rst_pad_i;
   input [2:0] clk_speed_select;
   output reg  adc_clk;

   reg [15:0] adc_clk_count;
   wire [7:0] adc_clk_count_terminal = (1 << clk_speed_select)-1;
   
   always @(posedge wb_clk)
     if (rst_pad_i) begin
        adc_clk <= 0;
        adc_clk_count <= 0;        
     end else begin
        adc_clk_count <=  adc_clk_count+1;        
        if (adc_clk_count == adc_clk_count_terminal) begin
           adc_clk <= ~adc_clk;
           adc_clk_count <= 0;           
        end
     end
   
endmodule // adc_clk_gen
