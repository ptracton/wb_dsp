


module dump;
   
   initial
     begin
`ifdef NCVERILOG
	      $shm_open("test.shm");
	      $shm_probe(testbench, "MAC");
`else	
	      $dumpfile("dump.vcd");
	      $dumpvars(0, testbench_testing_wb_slave);
`endif
	      
     end // initial begin
   
   
endmodule // test_top
