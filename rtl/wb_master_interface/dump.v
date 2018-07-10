


module dump;
   
   initial
     begin
`ifdef NCVERILOG
	      $shm_open("dump.shm");
	      $shm_probe(tb_wb_master_interface, "MAC");
`else	
	      $dumpfile("dump.vcd");
	      $dumpvars(0, tb_wb_master_interface);
`endif
	      
     end // initial begin
   
   
endmodule // test_top
