


module dump;
   
   initial
     begin
`ifdef NCVERILOG
	      $shm_open("dump.shm");
	      $shm_probe(tb_wb_daq_slave_registers, "MAC");
`else	
	      $dumpfile("dump.vcd");
	      $dumpvars(0, tb_wb_daq_slave_registers);
`endif
	      
     end // initial begin
   
   
endmodule // test_top
