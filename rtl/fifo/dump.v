


module dump;
   
   initial
     begin
`ifdef NCVERILOG
	      $shm_open("dump.shm");
	      $shm_probe(tb_fifo, "MAC");
`else	
	      $dumpfile("dump.vcd");
	      $dumpvars(0, tb_fifo);
`endif
	      
     end // initial begin
   
   
endmodule // test_top
