


module dump;
   
   initial
     begin
`ifdef NCVERILOG
	      $shm_open("test.shm");
	      $shm_probe(tb_wb_daq_data_aggregation, "MAC");
`else	
	      $dumpfile("dump.vcd");
	      $dumpvars(0, tb_wb_daq_data_aggregation);
`endif
	      
     end // initial begin
   
   
endmodule // test_top
