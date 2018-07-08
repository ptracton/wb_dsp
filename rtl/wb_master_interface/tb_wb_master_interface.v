//                              -*- Mode: Verilog -*-
// Filename        : tb_fifo.v
// Description     : fifo test bench
// Author          : ptracton
// Created On      : Mon Jul  2 20:26:10 2018
// Last Modified By: ptracton
// Last Modified On: Mon Jul  2 20:26:10 2018
// Update Count    : 0
// Status          : Unknown, Use with caution!

module tb_wb_master_interface (/*AUTOARG*/) ;

   // For a testbench this is ok
   /* verilator lint_off STMTDLY */
   
   localparam WB_CLK_PERIOD= 10;
   
   reg 			wb_clk;
   initial begin
      wb_clk = 0;
      forever
	#(WB_CLK_PERIOD/2) wb_clk = ~wb_clk;
   end
 
   reg 			wb_rst;
   initial begin
      wb_rst = 0;
      #42 wb_rst = 1;
      #77 wb_rst = 0; 
   end

   //
   // Bus Matrix has slightly different names
   //
   wire wb_clk_i = wb_clk;
   wire wb_rst_i = wb_rst;
   

   //
   // General purpose test support
   //
   test_tasks #("wb_master_interface",
		16) TEST();

`include "bus_matrix.vh"
   
   localparam aw = 32;
   localparam dw = 32;
   
   
   wb_master_interface dut( 
			   // Outputs
			   .wb_adr_o		(wb_m2s_daq_adr),
			   .wb_dat_o		(),
			   .wb_sel_o		(),
			   .wb_we_o		(),
			   .wb_cyc_o		(),
			   .wb_stb_o		(),
			   .wb_cti_o		(),
			   .wb_bte_o		(),
			   .data_rd		(),
			   .active		(),
			   // Inputs
			   .wb_clk		(wb_clk),
			   .wb_rst		(wb_rst),
			   .wb_dat_i		(),
			   .wb_ack_i		(),
			   .wb_err_i		(),
			   .wb_rty_i		(),
			   .start		(),
			   .address		(),
			   .selection		(),
			   .write		(),
			   .data_wr		()
			    );
   
   
   wb_ram 
     #(//Wishbone parameters
       .depth(32768)
       )
   ram0
   (
    .wb_clk_i(wb_clk),
    .wb_rst_i(wb_rst),
    
    .wb_adr_i(wb_m2s_ram0_adr),
    .wb_dat_i(wb_m2s_ram0_dat),
    .wb_sel_i(wb_m2s_ram0_sel),
    .wb_we_i(wb_m2s_ram0_we),
    .wb_bte_i(wb_m2s_ram0_bte),
    .wb_cti_i(wb_m2s_ram0_cti),
    .wb_cyc_i(wb_m2s_ram0_cyc),
    .wb_stb_i(wb_m2s_ram0_stb),
    
    .wb_ack_o(wb_s2m_ram0_ack),
    .wb_err_o(wb_s2m_ram0_err),
    .wb_dat_o(wb_s2m_ram0_dat)
    );
   
   assign wb_s2m_ram0_rty = 0;


   wb_ram 
     #(//Wishbone parameters
       .depth(32768)
       )
   ram1
   (
    .wb_clk_i(wb_clk),
    .wb_rst_i(wb_rst),
    
    .wb_adr_i(wb_m2s_ram1_adr),
    .wb_dat_i(wb_m2s_ram1_dat),
    .wb_sel_i(wb_m2s_ram1_sel),
    .wb_we_i(wb_m2s_ram1_we),
    .wb_bte_i(wb_m2s_ram1_bte),
    .wb_cti_i(wb_m2s_ram1_cti),
    .wb_cyc_i(wb_m2s_ram1_cyc),
    .wb_stb_i(wb_m2s_ram1_stb),
    
    .wb_ack_o(wb_s2m_ram1_ack),
    .wb_err_o(wb_s2m_ram1_err),
    .wb_dat_o(wb_s2m_ram1_dat)
    );
   
   assign wb_s2m_ram1_rty = 0;

   wb_ram 
     #(//Wishbone parameters
       .depth(32768)
       )
   ram2
   (
    .wb_clk_i(wb_clk),
    .wb_rst_i(wb_rst),
    
    .wb_adr_i(wb_m2s_ram2_adr),
    .wb_dat_i(wb_m2s_ram2_dat),
    .wb_sel_i(wb_m2s_ram2_sel),
    .wb_we_i(wb_m2s_ram2_we),
    .wb_bte_i(wb_m2s_ram2_bte),
    .wb_cti_i(wb_m2s_ram2_cti),
    .wb_cyc_i(wb_m2s_ram2_cyc),
    .wb_stb_i(wb_m2s_ram2_stb),
    
    .wb_ack_o(wb_s2m_ram2_ack),
    .wb_err_o(wb_s2m_ram2_err),
    .wb_dat_o(wb_s2m_ram2_dat)
    );
   
   assign wb_s2m_ram2_rty = 0;

   wb_ram 
     #(
       .depth(32768)
       )
   ram3
   (
    .wb_clk_i(wb_clk),
    .wb_rst_i(wb_rst),
    
    .wb_adr_i(wb_m2s_ram3_adr),
    .wb_dat_i(wb_m2s_ram3_dat),
    .wb_sel_i(wb_m2s_ram3_sel),
    .wb_we_i(wb_m2s_ram3_we),
    .wb_bte_i(wb_m2s_ram3_bte),
    .wb_cti_i(wb_m2s_ram3_cti),
    .wb_cyc_i(wb_m2s_ram3_cyc),
    .wb_stb_i(wb_m2s_ram3_stb),
    
    .wb_ack_o(wb_s2m_ram3_ack),
    .wb_err_o(wb_s2m_ram3_err),
    .wb_dat_o(wb_s2m_ram3_dat)
    );
   
   assign wb_s2m_ram3_rty = 0;

   
   
   initial begin
      
      //
      // Wait for reset to release
      //
      @(negedge wb_rst);
      repeat(5) @(posedge wb_clk);
      
      TEST.all_tests_completed();
   end
   
endmodule // tb_fifo
