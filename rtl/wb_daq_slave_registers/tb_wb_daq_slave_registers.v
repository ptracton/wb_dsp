//                              -*- Mode: Verilog -*-
// Filename        : tb_fifo.v
// Description     : fifo test bench
// Author          : ptracton
// Created On      : Mon Jul  2 20:26:10 2018
// Last Modified By: ptracton
// Last Modified On: Mon Jul  2 20:26:10 2018
// Update Count    : 0
// Status          : Unknown, Use with caution!

module tb_wb_daq_slave_registers (/*AUTOARG*/) ;

`include "wb_daq_slave_registers_include.vh"
`define REGISTER_ADDRESS 32'h2000_0000
   
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
   test_tasks #("wb_daq_slave_registeers",
		14) TEST();

   localparam dw = 32;
   localparam aw = 8;

   wire [31:0] daq_control;   
   
   wire [31:0] daq_channel0_address;
   wire [31:0] daq_channel1_address;
   wire [31:0] daq_channel2_address;
   wire [31:0] daq_channel3_address;

   wire [31:0] daq_channel0_control;
   wire [31:0] daq_channel1_control;
   wire [31:0] daq_channel2_control;
   wire [31:0] daq_channel3_control;
   
   wire        interrupt;
   reg [31:0]  daq_channel0_status;
   reg [31:0]  daq_channel1_status;
   reg [31:0]  daq_channel2_status;
   reg [31:0]  daq_channel3_status;
   
   
`include "bus_matrix.vh"
  
   wb_daq_slave_registers dut(
			      // Outputs
			      .wb_dat_o		(wb_s2m_daq_registers_dat),
			      .wb_ack_o		(wb_s2m_daq_registers_ack),
			      .wb_err_o		(wb_s2m_daq_registers_err),
			      .wb_rty_o		(wb_s2m_daq_registers_rty),
			      .daq_control_reg	(daq_control),
			      .daq_channel0_address_reg(daq_channel0_address),
			      .daq_channel1_address_reg(daq_channel1_address),
			      .daq_channel2_address_reg(daq_channel2_address),
			      .daq_channel3_address_reg(daq_channel3_address),
			      .daq_channel0_control_reg(daq_channel0_control),
			      .daq_channel1_control_reg(daq_channel1_control),
			      .daq_channel2_control_reg(daq_channel2_control),
			      .daq_channel3_control_reg(daq_channel3_control),
			      .interrupt	(interrupt),
			      // Inputs
			      .wb_clk		(wb_clk),
			      .wb_rst		(wb_rst),
			      .wb_adr_i		(wb_m2s_daq_registers_adr),
			      .wb_dat_i		(wb_m2s_daq_registers_dat),
			      .wb_sel_i		(wb_m2s_daq_registers_sel),
			      .wb_we_i		(wb_m2s_daq_registers_we),
			      .wb_cyc_i		(wb_m2s_daq_registers_cyc),
			      .wb_stb_i		(wb_m2s_daq_registers_stb),
			      .wb_cti_i		(wb_m2s_daq_registers_cti),
			      .wb_bte_i		(wb_m2s_daq_registers_adrbte),
			      .daq_channel0_status_reg(daq_channel0_status),
			      .daq_channel1_status_reg(daq_channel1_status),
			      .daq_channel2_status_reg(daq_channel2_status),
			      .daq_channel3_status_reg(daq_channel3_status)
			      ); 



   wb_bfm_master     
     #(.aw(8))
   master
   (
    .wb_clk_i(wb_clk),
    .wb_rst_i(wb_rst),
    .wb_adr_o(wb_m2s_bus_master_adr),
    .wb_dat_o(wb_m2s_bus_master_dat),
    .wb_sel_o(wb_m2s_bus_master_sel),
    .wb_we_o(wb_m2s_bus_master_we),
    .wb_cyc_o(wb_m2s_bus_master_cyc),
    .wb_stb_o(wb_m2s_bus_master_stb),
    .wb_cti_o(wb_m2s_bus_master_cti),
    .wb_bte_o(wb_m2s_bus_master_bte),
    .wb_dat_i(wb_s2m_bus_master_dat),
    .wb_ack_i(wb_s2m_bus_master_ack),
    .wb_err_i(wb_s2m_bus_master_err),
    .wb_rty_i(wb_s2m_bus_master_rty)
    );


   assign wb_s2m_ram0_dat = 0;
   assign wb_s2m_ram0_ack = 0;
   assign wb_s2m_ram0_err = 0;
   assign wb_s2m_ram0_rty = 0;
   
   initial begin
      daq_channel0_status = 0;
      daq_channel1_status = 0;
      daq_channel2_status = 0;
      daq_channel3_status = 0;
 
      
      //
      // Wait for reset to release
      //
      @(negedge wb_rst);


      //
      //
      //
      repeat(10) @(posedge wb_clk);
      master.reset;
      repeat(10) @(posedge wb_clk);
      
      master.write(`REGISTER_ADDRESS + `DAQ_CHANNEL0_ADDRESS_OFFSET,
		   32'h12345678,
		   4'hF
		   );
      
      repeat(10) @(posedge wb_clk);
      
      TEST.all_tests_completed();
   end
   
endmodule // tb_fifo
