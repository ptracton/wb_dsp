//                              -*- Mode: Verilog -*-
// Filename        : testbench.v
// Description     : Wishbone DSP Testbench
// Author          : Philip Tracton
// Created On      : Wed Dec  2 13:12:45 2015
// Last Modified By: Philip Tracton
// Last Modified On: Wed Dec  2 13:12:45 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!

`include "timescale.v"
`include "wb_dsp_includes.vh"

module testbench (/*AUTOARG*/ ) ;

   //
   // Creates a clock, reset, a timeout in case the sim never stops,
   // and pass/fail managers
   //
`include "test_management.v"

   //
   // System Controller cleans up clocks and resets
   //
   
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
   
   //
   // Bus matrix between masters and slaves
   //
`include "wb_dsp_testbench_intercon.vh"

   wire interrupt;
   
   
   //
   // DSP Module being tested
   //
   wb_dsp_top dut(
                  // Outputs
                  .interrupt(interrupt),
                  .wb_master_adr_o(wb_m2s_dsp_master_adr), 
                  .wb_master_dat_o(wb_m2s_dsp_master_dat), 
                  .wb_master_sel_o(wb_m2s_dsp_master_sel), 
                  .wb_master_we_o(wb_m2s_dsp_master_we),
                  .wb_master_cyc_o(wb_m2s_dsp_master_cyc), 
                  .wb_master_stb_o(wb_m2s_dsp_master_stb), 
                  .wb_master_cti_o(wb_m2s_dsp_master_cti), 
                  .wb_master_bte_o(wb_m2s_dsp_master_bte),
                  .wb_slave_dat_o(wb_s2m_wb_dsp_slave_dat), 
                  .wb_slave_ack_o(wb_s2m_wb_dsp_slave_ack), 
                  .wb_slave_err_o(wb_s2m_wb_dsp_slave_err),
                  .wb_slave_rty_o(wb_s2m_wb_dsp_slave_rty),
                  // Inputs
                  .wb_clk(wb_clk), 
                  .wb_rst(wb_rst), 
                  .wb_master_dat_i(wb_s2m_dsp_master_dat), 
                  .wb_master_ack_i(wb_s2m_dsp_master_ack), 
                  .wb_master_err_i(wb_s2m_dsp_master_err),
                  .wb_master_rty_i(wb_s2m_dsp_master_rty), 
                  .wb_slave_adr_i(wb_m2s_wb_dsp_slave_adr), 
                  .wb_slave_dat_i(wb_m2s_wb_dsp_slave_dat), 
                  .wb_slave_sel_i(wb_m2s_wb_dsp_slave_sel), 
                  .wb_slave_we_i(wb_m2s_wb_dsp_slave_we),
                  .wb_slave_cyc_i(wb_m2s_wb_dsp_slave_cyc), 
                  .wb_slave_stb_i(wb_m2s_wb_dsp_slave_stb), 
                  .wb_slave_cti_i(wb_m2s_wb_dsp_slave_cti), 
                  .wb_slave_bte_i(wb_m2s_wb_dsp_slave_bte)
                  ) ;

   //
   // Bus Master
   //
   wb_bfm_master master_bfm(
                            .wb_clk_i(wb_clk),
                            .wb_rst_i(wb_rst),
                            .wb_adr_o(wb_m2s_bfm_adr),
                            .wb_dat_o(wb_m2s_bfm_dat),
                            .wb_sel_o(wb_m2s_bfm_sel),
                            .wb_we_o (wb_m2s_bfm_we ),
                            .wb_cyc_o(wb_m2s_bfm_cyc),
                            .wb_stb_o(wb_m2s_bfm_stb),
                            .wb_cti_o(wb_m2s_bfm_cti),
                            .wb_bte_o(wb_m2s_bfm_bte),
                            .wb_dat_i(wb_s2m_bfm_dat),
                            .wb_ack_i(wb_s2m_bfm_ack),
                            .wb_err_i(wb_s2m_bfm_err),
                            .wb_rty_i(wb_s2m_bfm_rty));   
   
   //
   // SRAM
   //

`include "hack.vh"
   
   wb_ram #(.depth(4096),
            .memfile(ram_image))
   wb_ram0 (
            // Outputs
            .wb_dat_o(wb_s2m_wb_ram0_dat), 
            .wb_ack_o(wb_s2m_wb_ram0_ack), 
            .wb_err_o(wb_s2m_wb_ram0_err), 
            //.wb_rty_o(wb_s2m_wb_ram0_rty),
            // Inputs
            .wb_clk_i(wb_clk), 
            .wb_rst_i(wb_rst), 
            .wb_adr_i(wb_m2s_wb_ram0_adr), 
            .wb_dat_i(wb_m2s_wb_ram0_dat), 
            .wb_sel_i(wb_m2s_wb_ram0_sel), 
            .wb_we_i(wb_m2s_wb_ram0_we), 
            .wb_cyc_i(wb_m2s_wb_ram0_cyc),
            .wb_stb_i(wb_m2s_wb_ram0_stb), 
            .wb_cti_i(wb_m2s_wb_ram0_cti),
            .wb_bte_i(wb_m2s_wb_ram0_bte)
            ) ;

   //
   // Tasks used to help test cases
   //
   test_tasks test_tasks();
   

   
   //
   // The actual test cases that are being tested
   //
   test_case test_case();

endmodule // testbench
