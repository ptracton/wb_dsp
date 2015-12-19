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
   wb_clk, wb_rst, empty, full, fifo_data_in
   ) ;

   parameter dw=32;
   
   
   input wb_clk;
   input wb_rst;
   input empty;
   input full;
   output reg pop;
   input [dw-1:0] fifo_data_in;
   output reg [dw-1:0] sram_data_out;
   output reg          sram_start;
   
   always @(posedge wb_clk)
     if (wb_rst) begin
        pop <=0;    
        sram_data_out <= 0;      
        sram_start <= 0;        
     end else begin
        if (!empty && !pop) begin
           pop <= 1;       
           sram_data_out <= fifo_data_in;
           sram_start <= 1;           
        end else begin
           pop <= 0;
           //sram_data_out <= 0;
           sram_start <= 0;           
        end
     end // else: !if(wb_rst)   
   
endmodule // fifo_to_sram
