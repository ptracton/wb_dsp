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
   wb_clk, wb_rst, empty, grant, fifo_number_samples,
   fifo_number_samples_terminal, data_done, fifo_data_in
   ) ;

   parameter FIFO_DEPTH = 16;   
   
   input wb_clk;
   input wb_rst;
   input empty;
   input grant;
   input [$clog2(FIFO_DEPTH):0] fifo_number_samples;   
   input [$clog2(FIFO_DEPTH):0] fifo_number_samples_terminal;
   input       data_done;   
   output reg  pop;
   input [31:0] fifo_data_in;
   output reg [31:0] sram_data_out;
   output reg          sram_start;

   reg                 active;
   
   reg 		       data_done_reg;
   wire 	       data_done_edge;

   // watch the rising edge of data_done
   assign data_done_edge = (data_done & !data_done_reg);
   
   always @(posedge wb_clk)
     if (wb_rst) begin
	data_done_reg <= 0;	
     end else begin
	data_done_reg <= data_done;	
     end
 
   always @(posedge wb_clk)
     if (wb_rst) begin
	pop <= 0;	
     end else begin
	pop <= data_done_edge | (pop & !empty);	
     end
   //assign pop = data_done_edge;
   
   
   //
   // If the number of samples in the FIFO is greater than or equal to the FW
   // controlled terminal value, then we are active.  We stay active until the
   // empty flag is asserted.  This way all data is pulled out of the FIFO
   // and dumped to SRAM.  This allows for burst data moves.
   //
   always @(posedge wb_clk)
     if (wb_rst) begin
        active <= 0;        
     end else begin
        if (empty) begin
           active <= 0;           
        end else if ((fifo_number_samples >= fifo_number_samples_terminal) && !active) begin
           active <= 1;           
        end
     end   

   //
   // If we are active and not popping data, start to POP data from FIFO
   // also signal the bus master state machine to start.  Hold the sram_start
   // bit high until grant is asserted.  Grant is generated by the arbiter so
   // we know we are now the channel driving bus master and storing data.
   //
   always @(posedge wb_clk)
     if (wb_rst) begin
        sram_data_out <= 0;      
        sram_start <= 0;        
     end else begin
        if ((active && !pop) || 
            (data_done & !empty)) begin
           sram_data_out <= fifo_data_in;
           sram_start <= 1;           
        end else if (grant) begin
           sram_start <= 0;           
        end 
     end // else: !if(wb_rst)   
   
endmodule // fifo_to_sram
