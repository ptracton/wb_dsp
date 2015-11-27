//                              -*- Mode: Verilog -*-
// Filename        : testbench_testing_wb_slave.v
// Description     : Testbench for testing Wishbone Slave module
// Author          : Philip Tracton
// Created On      : Fri Nov 27 13:49:59 2015
// Last Modified By: Philip Tracton
// Last Modified On: Fri Nov 27 13:49:59 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!

`include "timescale.v"

module testbench_testing_wb_slave (/*AUTOARG*/ ) ;
`include "test_management.v"

   wire wb_clk;
   wire wb_rst;
      
   syscon system_controller(
                            // Outputs
                            .wb_clk_o(wb_clk), 
                            .wb_rst_o(wb_rst),
                            // Inputs
                            .clk_pad_i(clk), 
                            .rst_pad_i(reset)
                            ) ;

`include "wb_switch1.vh"
   
   wb_bfm_master master0(
                         .wb_clk_i(wb_clk),
                         .wb_rst_i(wb_rst),
                         .wb_adr_o(wb_m2s_master0_adr),
                         .wb_dat_o(wb_m2s_master0_dat),
                         .wb_sel_o(wb_m2s_master0_sel),
                         .wb_we_o(wb_m2s_master0_we),
                         .wb_cyc_o(wb_m2s_master0_cyc),
                         .wb_stb_o(wb_m2s_master0_stb),
                         .wb_cti_o(wb_m2s_master0_cti),
                         .wb_bte_o(wb_m2s_master0_bte),
                         .wb_dat_i(wb_s2m_master0_dat),
                         .wb_ack_i(wb_s2m_master0_ack),
                         .wb_err_i(wb_s2m_master0_err),
                         .wb_rty_i(wb_s2m_master0_rty));
   
   
   testing_wb_slave slave0 (/*AUTOARG*/
                            // Outputs
                            .wb_dat_o(wb_s2m_wb_slave0_dat), 
                            .wb_ack_o(wb_s2m_wb_slave0_ack), 
                            .wb_err_o(wb_s2m_wb_slave0_err), 
                            .wb_rty_o(wb_s2m_wb_slave0_rty),
                            // Inputs
                            .wb_clk(wb_clk), 
                            .wb_rst(wb_rst), 
                            .wb_adr_i(wb_m2s_wb_slave0_adr), 
                            .wb_dat_i(wb_m2s_wb_slave0_dat), 
                            .wb_sel_i(wb_m2s_wb_slave0_sel), 
                            .wb_we_i(wb_m2s_wb_slave0_we), 
                            .wb_cyc_i(wb_m2s_wb_slave0_cyc),
                            .wb_stb_i(wb_m2s_wb_slave0_stb), 
                            .wb_cti_i(wb_m2s_wb_slave0_cti),
                            .wb_bte_i(wb_m2s_wb_slave0_bte)
                            ) ;
   
   
   testing_wb_slave slave1 (/*AUTOARG*/
                            // Outputs
                            .wb_dat_o(wb_s2m_wb_slave1_dat), 
                            .wb_ack_o(wb_s2m_wb_slave1_ack), 
                            .wb_err_o(wb_s2m_wb_slave1_err), 
                            .wb_rty_o(wb_s2m_wb_slave1_rty),
                            // Inputs
                            .wb_clk(wb_clk), 
                            .wb_rst(wb_rst), 
                            .wb_adr_i(wb_m2s_wb_slave1_adr), 
                            .wb_dat_i(wb_m2s_wb_slave1_dat), 
                            .wb_sel_i(wb_m2s_wb_slave1_sel), 
                            .wb_we_i(wb_m2s_wb_slave1_we), 
                            .wb_cyc_i(wb_m2s_wb_slave1_cyc),
                            .wb_stb_i(wb_m2s_wb_slave1_stb), 
                            .wb_cti_i(wb_m2s_wb_slave1_cti),
                            .wb_bte_i(wb_m2s_wb_slave1_bte)
                            ) ;   
   reg  err;
   
   initial begin
      #100 $display("Simulation Running");
      master0.reset();
      master0.write(32'h9000_0000, 32'hdead_beef, 4'hF, err);
      master0.write(32'h9000_0004, 32'hf00d_d00f, 4'hF, err);
      master0.write(32'h9000_0008, 32'h0123_4567, 4'hF, err);
      master0.write(32'h9000_000C, 32'h89AB_CDEF, 4'hF, err);      
      #1000 $finish;
      
   end
   
endmodule // testbench_testing_wb_slave
