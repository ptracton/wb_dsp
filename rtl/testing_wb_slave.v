//                              -*- Mode: Verilog -*-
// Filename        : testing_wb_slave.v
// Description     : Testing making a wishbone slave device
// Author          : Philip Tracton
// Created On      : Fri Nov 27 13:36:52 2015
// Last Modified By: Philip Tracton
// Last Modified On: Fri Nov 27 13:36:52 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!


module testing_wb_slave (/*AUTOARG*/
   // Outputs
   wb_dat_o, wb_ack_o, wb_err_o, wb_rty_o,
   // Inputs
   wb_clk, wb_rst, wb_adr_i, wb_dat_i, wb_sel_i, wb_we_i, wb_cyc_i,
   wb_stb_i, wb_cti_i, wb_bte_i
   ) ;
   parameter dw = 32;
   parameter aw = 32;
   parameter DEBUG = 0;
   
   
   input                  wb_clk;
   input                  wb_rst;
   input [aw-1:0]         wb_adr_i;
   input [dw-1:0]         wb_dat_i;
   input [3:0]            wb_sel_i;
   input                  wb_we_i;
   input                  wb_cyc_i;
   input                  wb_stb_i;
   input [2:0]            wb_cti_i;
   input [1:0]            wb_bte_i;
   output reg [dw-1:0]    wb_dat_o;
   output reg             wb_ack_o;
   output reg             wb_err_o;
   output reg             wb_rty_o;

   reg [dw-1:0]           slave_reg0;
   reg [dw-1:0]           slave_reg1;
   reg [dw-1:0]           slave_reg2;
   reg [dw-1:0]           slave_reg3;

   
   
endmodule // testing_wb_slave
