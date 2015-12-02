//                              -*- Mode: Verilog -*-
// Filename        : simple_slave_00.v
// Description     : Wishbone DSP Simple Slave interface testing
// Author          : Philip Tracton
// Created On      : Wed Dec  2 14:02:57 2015
// Last Modified By: Philip Tracton
// Last Modified On: Wed Dec  2 14:02:57 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!

`include "wb_dsp_includes.vh"

module test_case (/*AUTOARG*/ ) ;
   parameter simulation_name = "simple_slave_00";
   
   reg  err;
   reg [31:0] data_out;
   
   initial begin
      $display("Simple Slave Test Case");
      
      @(posedge `WB_RST);
      @(negedge `WB_RST);
      @(posedge `WB_CLK);

      
      `TB.master_bfm.reset();
      `TB.master_bfm.write(32'h1000_0000, 32'hdead_beef, 4'hF, err);
      `TB.master_bfm.write(32'h5000_0000, 32'h1122_3344, 4'hF, err);
      
      #1000;
      $finish; 
      
   end

endmodule // test_case
