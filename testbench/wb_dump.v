//                              -*- Mode: Verilog -*-
// Filename        : wb_dump.v
// Description     : Dump signals for waveform debugging
// Author          : Philip Tracton
// Created On      : Wed Dec  2 14:22:59 2015
// Last Modified By: Philip Tracton
// Last Modified On: Wed Dec  2 14:22:59 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!


`include "wb_dsp_includes.vh"

module dump;

   
   initial
     begin
`ifdef NCVERILOG
        $shm_open("test.shm",0); 
        $shm_probe(`TB,"AC");        
`else	
	      $dumpfile("dump.vcd");
	      $dumpvars(0, `TB);
`endif
	      
     end // initial begin
   
   
endmodule // test_top
