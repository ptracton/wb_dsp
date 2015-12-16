//                              -*- Mode: Verilog -*-
// Filename        : fifo.v
// Description     : FIFO
// Author          : Philip Tracton
// Created On      : Wed Dec 16 13:27:12 2015
// Last Modified By: Philip Tracton
// Last Modified On: Wed Dec 16 13:27:12 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!
module fifo (/*AUTOARG*/
   // Outputs
   data_out, empty, full, number_samples,
   // Inputs
   wb_clk, wb_rst, push, pop, data_in
   ) ;
   parameter dw = 32;
   parameter depth = 16;

   input wb_clk;
   input wb_rst;
   input push;
   input pop;
   input [dw-1:0] data_in;
   output wire [dw-1:0] data_out;
   output wire          empty;
   output wire          full;
   output reg [7:0]     number_samples;
   
   reg [7:0]            rd_ptr;
   reg [7:0]            wr_ptr; 
   reg [dw-1:0]         memory [0:depth-1];
   integer              i;

   //
   // Write data into FIFO memory when there is a push.
   // Increment the write pointer and wrap around as needed.
   //
   always @(posedge wb_clk)
     if (wb_rst) begin
        for (i=0; i< depth; i=i+1)
          memory[i] <= 0;
        wr_ptr <= 0;  
     end else begin
        if (push) begin
           memory[wr_ptr] <= data_in;
           wr_ptr <= wr_ptr + 1;
           if (wr_ptr > depth-1) begin
              wr_ptr <= 0;              
           end 
        end
     end // else: !if(wb_rst)   

   //
   // Always present the next sample to the output.
   //
   // If we pop (read) a sample increment and wrap
   // around the read pointer if needed.
   //
   assign data_out = memory[rd_ptr];
   always @(posedge wb_clk)
     if (wb_rst) begin
        rd_ptr <= 0;        
     end else begin
        if (pop) begin
           rd_ptr <= rd_ptr + 1;
           if (rd_ptr > depth-1) begin
              rd_ptr <= 0;              
           end
        end
     end

   //
   // Track how many samples are in the FIFO
   //
   always @(posedge wb_clk)
     if (wb_rst) begin
        number_samples <= 0;        
     end else begin
        if (push) begin
           number_samples <= number_samples +1; 
           if (number_samples >= depth) begin
              number_samples <= depth;              
           end
        end
        if (pop) begin
           number_samples <= number_samples -1;           
        end
     end

   //
   // If there are no samples we are empty.
   //
   assign empty = (number_samples == 0);

   //
   // If we have filled in the FIFO we are full
   //
   assign full  = (number_samples == depth);   
   
endmodule // fifo
