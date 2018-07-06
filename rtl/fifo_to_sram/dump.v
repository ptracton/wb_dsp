


module dump;
   
   initial
     begin
`ifdef NCVERILOG
	      $shm_open("test.shm");
	      $shm_probe(testbench, "MAC");
`else	
	      $dumpfile("dump.vcd");
	      $dumpvars(0, tb_fifo_to_sram);
`endif
	      
     end // initial begin
   
   
endmodule // test_top