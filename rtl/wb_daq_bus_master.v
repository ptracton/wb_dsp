//                              -*- Mode: Verilog -*-
// Filename        : wb_daq_bus_master.v
// Description     : WB Data Acquisition Bus Master
// Author          : Philip Tracton
// Created On      : Tue Dec 15 20:57:41 2015
// Last Modified By: Philip Tracton
// Last Modified On: Tue Dec 15 20:57:41 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!

module wb_daq_bus_master (/*AUTOARG*/
   // Outputs
   wb_adr_o, wb_dat_o, wb_sel_o, wb_we_o, wb_cyc_o, wb_stb_o,
   wb_cti_o, wb_bte_o,
   // Inputs
   wb_clk, wb_rst, wb_dat_i, wb_ack_i, wb_err_i, wb_rty_i,
   control_reg
   ) ;
   parameter dw = 32;
   parameter aw = 32;
   parameter DEBUG = 0;
   
   input 		wb_clk;
   input 		wb_rst;
   output wire [aw-1:0] wb_adr_o;
   output wire [dw-1:0] wb_dat_o;
   output wire [3:0]    wb_sel_o;
   output wire          wb_we_o;
   output wire          wb_cyc_o;
   output wire          wb_stb_o;
   output wire [2:0]    wb_cti_o;
   output wire [1:0]    wb_bte_o;
   input [dw-1:0]       wb_dat_i;
   input                wb_ack_i;
   input                wb_err_i;
   input                wb_rty_i;
   input [dw-1:0]       control_reg;

   /*AUTOREG*/
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire                 active;                 // From master of wb_master_interface.v
   wire [dw-1:0]        data_rd;                // From master of wb_master_interface.v
   // End of automatics

   reg                  start;
   reg [aw-1:0]         address;
   reg [3:0]            selection;
   reg                  write;
   reg [dw-1:0]         data_wr;
   
   wb_master_interface master(/*AUTOINST*/
                              // Outputs
                              .wb_adr_o         (wb_adr_o[aw-1:0]),
                              .wb_dat_o         (wb_dat_o[dw-1:0]),
                              .wb_sel_o         (wb_sel_o[3:0]),
                              .wb_we_o          (wb_we_o),
                              .wb_cyc_o         (wb_cyc_o),
                              .wb_stb_o         (wb_stb_o),
                              .wb_cti_o         (wb_cti_o[2:0]),
                              .wb_bte_o         (wb_bte_o[1:0]),
                              .data_rd          (data_rd[dw-1:0]),
                              .active           (active),
                              // Inputs
                              .wb_clk           (wb_clk),
                              .wb_rst           (wb_rst),
                              .wb_dat_i         (wb_dat_i[dw-1:0]),
                              .wb_ack_i         (wb_ack_i),
                              .wb_err_i         (wb_err_i),
                              .wb_rty_i         (wb_rty_i),
                              .start            (start),
                              .address          (address[aw-1:0]),
                              .selection        (selection[3:0]),
                              .write            (write),
                              .data_wr          (data_wr[dw-1:0]));
   
endmodule // wb_daq_bus_master
