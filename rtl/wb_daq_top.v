//                              -*- Mode: Verilog -*-
// Filename        : wb_daq_top.v
// Description     : WB Data Acquisition Top
// Author          : Philip Tracton
// Created On      : Tue Dec 15 20:50:40 2015
// Last Modified By: Philip Tracton
// Last Modified On: Tue Dec 15 20:50:40 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!
module wb_daq_top (/*AUTOARG*/
   // Outputs
   wb_master_adr_o, wb_master_dat_o, wb_master_sel_o, wb_master_we_o,
   wb_master_cyc_o, wb_master_stb_o, wb_master_cti_o, wb_master_bte_o,
   wb_slave_dat_o, wb_slave_ack_o, wb_slave_err_o, wb_slave_rty_o,
   interrupt,
   // Inputs
   adc_clk, wb_clk, wb_rst, wb_master_dat_i, wb_master_ack_i,
   wb_master_err_i, wb_master_rty_i, wb_slave_adr_i, wb_slave_dat_i,
   wb_slave_sel_i, wb_slave_we_i, wb_slave_cyc_i, wb_slave_stb_i,
   wb_slave_cti_i, wb_slave_bte_i
   ) ;
   parameter master_dw = 32;
   parameter master_aw = 32;
   parameter slave_dw = 32;
   parameter slave_aw = 8;
   parameter channel0_adc_image = "";
   
   //
   // Common Interface
   //
   input                  adc_clk;   
   input                  wb_clk;
   input                  wb_rst;
   
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
   input [slave_aw-1:0]        wb_slave_adr_i;
   input [slave_dw-1:0]        wb_slave_dat_i;
   input [3:0]                 wb_slave_sel_i;
   input                       wb_slave_we_i;
   input                       wb_slave_cyc_i;
   input                       wb_slave_stb_i;
   input [2:0]                 wb_slave_cti_i;
   input [1:0]                 wb_slave_bte_i;
   output wire [slave_dw-1:0]  wb_slave_dat_o;
   output wire                 wb_slave_ack_o;
   output wire                 wb_slave_err_o;
   output wire                 wb_slave_rty_o;

   output wire                 interrupt;
   
   wire [master_dw-1:0]               channel0_data_out;
   wire                        channel0_start_sram;
   
   wb_daq_slave_registers #(.aw(slave_aw), .dw(slave_dw))
   slave_registers 
     (
      // Outputs
      .interrupt                        (interrupt),
      .wb_dat_o                         (wb_slave_dat_o[slave_dw-1:0]),
      .wb_ack_o                         (wb_slave_ack_o),
      .wb_err_o                         (wb_slave_err_o),
      .wb_rty_o                         (wb_slave_rty_o),

      // Inputs
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
   
   wb_daq_bus_master #(.aw(master_aw), .dw(master_dw))
   bus_master(
              // Outputs
              .wb_adr_o             (wb_master_adr_o[master_aw-1:0]),
              .wb_dat_o             (wb_master_dat_o[master_dw-1:0]),
              .wb_sel_o             (wb_master_sel_o[3:0]),
              .wb_we_o              (wb_master_we_o),
              .wb_cyc_o             (wb_master_cyc_o),
              .wb_stb_o             (wb_master_stb_o),
              .wb_cti_o             (wb_master_cti_o[2:0]),
              .wb_bte_o             (wb_master_bte_o[1:0]),
              
              // Inputs
              .wb_clk               (wb_clk),
              .wb_rst               (wb_rst),
              .wb_dat_i             (wb_master_dat_i[master_dw-1:0]),
              .wb_ack_i             (wb_master_ack_i),
              .wb_err_i             (wb_master_err_i),
              .wb_rty_i             (wb_master_rty_i)
              
              );

   wb_daq_channel #(.dw(32), .adc_dw(8),
                    .adc_image(channel0_adc_image))
   channel0(
            // Outputs
            .data_out(channel0_data_out), 
            .start_sram(channel0_start_sram),
            // Inputs
            .wb_clk(wb_clk), 
            .wb_rst(wb_rst), 
            .adc_clk(adc_clk), 
            .enable(1'b1)
            ) ;
   
endmodule // wb_daq_top
