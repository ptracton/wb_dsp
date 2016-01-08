//                              -*- Mode: Verilog -*-
// Filename        : wb_dsp_top.v
// Description     : Top level module for wishbone DSP
// Author          : Philip Tracton
// Created On      : Wed Dec  2 12:53:51 2015
// Last Modified By: Philip Tracton
// Last Modified On: Wed Dec  2 12:53:51 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!

module wb_dsp_top (/*AUTOARG*/
   // Outputs
   interrupt, wb_master_adr_o, wb_master_dat_o, wb_master_sel_o,
   wb_master_we_o, wb_master_cyc_o, wb_master_stb_o, wb_master_cti_o,
   wb_master_bte_o, wb_slave_dat_o, wb_slave_ack_o, wb_slave_err_o,
   wb_slave_rty_o,
   // Inputs
   wb_clk, wb_rst, begin_equation, wb_master_dat_i, wb_master_ack_i,
   wb_master_err_i, wb_master_rty_i, wb_slave_adr_i, wb_slave_dat_i,
   wb_slave_sel_i, wb_slave_we_i, wb_slave_cyc_i, wb_slave_stb_i,
   wb_slave_cti_i, wb_slave_bte_i
   ) ;

   parameter master_dw = 32;
   parameter master_aw = 32;
   parameter slave_dw = 32;
   parameter slave_aw = 8;
   
   //
   // Common Interface
   //
   input                  wb_clk;
   input                  wb_rst;
   output wire            interrupt;
   input [3:0]            begin_equation;
   
   //
   // Master Interface
   //
   output wire [master_aw-1:0] wb_master_adr_o;
   output wire [master_dw-1:0] wb_master_dat_o;
   output wire [3:0]           wb_master_sel_o;
   output wire                 wb_master_we_o;
   output wire                 wb_master_cyc_o;
   output wire                 wb_master_stb_o;
   output wire [2:0]           wb_master_cti_o;
   output wire [1:0]           wb_master_bte_o;
   input [master_dw-1:0]       wb_master_dat_i;
   input                       wb_master_ack_i;
   input                       wb_master_err_i;
   input                       wb_master_rty_i;
      
   //
   // Slave Interface
   //
   input [slave_aw-1:0] wb_slave_adr_i;
   input [slave_dw-1:0] wb_slave_dat_i;
   input [3:0]          wb_slave_sel_i;
   input                wb_slave_we_i;
   input                wb_slave_cyc_i;
   input                wb_slave_stb_i;
   input [2:0]          wb_slave_cti_i;
   input [1:0]          wb_slave_bte_i;
   output wire [slave_dw-1:0] wb_slave_dat_o;
   output wire                wb_slave_ack_o;
   output wire                wb_slave_err_o;
   output wire                wb_slave_rty_o;

   wire [slave_dw-1:0]        equation0_address_reg;
   wire [slave_dw-1:0]        equation1_address_reg;
   wire [slave_dw-1:0]        equation2_address_reg;
   wire [slave_dw-1:0]        equation3_address_reg;   
   wire [slave_dw-1:0]        control_reg;
   wire [slave_dw-1:0]        status_reg;
   
   wb_dsp_slave_registers #(.aw(slave_aw), .dw(slave_dw))
   slave_registers 
     (
      // Outputs
      .interrupt                        (interrupt),
      .wb_dat_o                         (wb_slave_dat_o[slave_dw-1:0]),
      .wb_ack_o                         (wb_slave_ack_o),
      .wb_err_o                         (wb_slave_err_o),
      .wb_rty_o                         (wb_slave_rty_o),
      .equation0_address_reg (equation0_address_reg[slave_dw-1:0]),
      .equation1_address_reg (equation1_address_reg[slave_dw-1:0]),
      .equation2_address_reg (equation2_address_reg[slave_dw-1:0]),
      .equation3_address_reg (equation3_address_reg[slave_dw-1:0]),      
      .control_reg                      (control_reg[slave_dw-1:0]),

      // Inputs
      .status_reg                       (status_reg),
      .wb_clk                           (wb_clk),
      .wb_rst                           (wb_rst),
      .wb_adr_i                         (wb_slave_adr_i[slave_aw-1:0]),
      .wb_dat_i                         (wb_slave_dat_i[slave_dw-1:0]),
      .wb_sel_i                         (wb_slave_sel_i[3:0]),
      .wb_we_i                          (wb_slave_we_i),
      .wb_cyc_i                         (wb_slave_cyc_i),
      .wb_stb_i                         (wb_slave_stb_i),
      .wb_cti_i                         (wb_slave_cti_i[2:0]),
      .wb_bte_i                         (wb_slave_bte_i[1:0])
      );
   
   wb_dsp_equation_sm #(.aw(master_aw), .dw(master_dw))
     control(
             // Outputs
             .wb_adr_o             (wb_master_adr_o[master_aw-1:0]),
             .wb_dat_o             (wb_master_dat_o[master_dw-1:0]),
             .wb_sel_o             (wb_master_sel_o[3:0]),
             .wb_we_o              (wb_master_we_o),
             .wb_cyc_o             (wb_master_cyc_o),
             .wb_stb_o             (wb_master_stb_o),
             .wb_cti_o             (wb_master_cti_o[2:0]),
             .wb_bte_o             (wb_master_bte_o[1:0]),
             .status_reg           (status_reg),
             
             // Inputs
             .wb_clk               (wb_clk),
             .wb_rst               (wb_rst),
             .wb_dat_i             (wb_master_dat_i[master_dw-1:0]),
             .wb_ack_i             (wb_master_ack_i),
             .wb_err_i             (wb_master_err_i),
             .wb_rty_i             (wb_master_rty_i),
             .begin_equation       (begin_equation),
             .equation0_address_reg (equation0_address_reg[slave_dw-1:0]),
             .equation1_address_reg (equation1_address_reg[slave_dw-1:0]),
             .equation2_address_reg (equation2_address_reg[slave_dw-1:0]),
             .equation3_address_reg (equation3_address_reg[slave_dw-1:0]),
             .control_reg          (control_reg[slave_dw-1:0])
             );
   
endmodule // wb_dsp_top
