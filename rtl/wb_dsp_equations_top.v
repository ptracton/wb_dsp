//                              -*- Mode: Verilog -*-
// Filename        : wb_dsp_equations_top.v
// Description     : Container for all Equations
// Author          : Philip Tracton
// Created On      : Wed Jan 13 16:34:33 2016
// Last Modified By: Philip Tracton
// Last Modified On: Wed Jan 13 16:34:33 2016
// Update Count    : 0
// Status          : Unknown, Use with caution!

module wb_dsp_equations_top (/*AUTOARG*/
   // Outputs
   eq_adr_o, eq_dat_o, eq_sel_o, eq_we_o, eq_cyc_o, eq_stb_o,
   eq_cti_o, eq_bte_o, equation_done,
   // Inputs
   wb_clk, wb_rst, wb_dat_i, wb_ack_i, wb_err_i, wb_rty_i,
   base_address, equation_enable
   ) ;
   parameter dw = 32;
   parameter aw = 32;
   parameter DEBUG = 0;
   
   input 		wb_clk;
   input 		wb_rst;
   output wire [aw-1:0] eq_adr_o;
   output wire [dw-1:0] eq_dat_o;
   output wire [3:0]    eq_sel_o;
   output wire          eq_we_o;
   output wire          eq_cyc_o;
   output wire          eq_stb_o;
   output wire [2:0]    eq_cti_o;
   output wire [1:0]    eq_bte_o;
   input [dw-1:0]       wb_dat_i;
   input                wb_ack_i;
   input                wb_err_i;
   input                wb_rty_i;

   input [aw-1:0]       base_address;
   input [7:0]          equation_enable;
   output               equation_done;

   /****************************************************************************
    EQUATION: SUM
    ****************************************************************************/

    wire [aw-1:0] sum_adr_o;
    wire [dw-1:0] sum_dat_o;
    wire [3:0]    sum_sel_o;
    wire          sum_we_o;
    wire          sum_cyc_o;
    wire          sum_stb_o;
    wire [2:0]    sum_cti_o;
    wire [1:0]    sum_bte_o;
   
   equation_sum #(.aw(aw), .dw(dw),.DEBUG(DEBUG))
   sum(
       // Outputs
       .wb_adr_o(sum_adr_o), 
       .wb_dat_o(sum_dat_o), 
       .wb_sel_o(sum_sel_o), 
       .wb_we_o(sum_we_o), 
       .wb_cyc_o(sum_cyc_o), 
       .wb_stb_o(sum_stb_o),
       .wb_cti_o(), 
       .wb_bte_o(), 
       .equation_done(sum_equation_done),
       
       // Inputs
       .wb_clk(wb_clk), 
       .wb_rst(wb_rst), 
       .wb_dat_i(wb_dat_i), 
       .wb_ack_i(wb_ack_i), 
       .wb_err_i(wb_err_i), 
       .wb_rty_i(wb_rty_i),
       .base_address(base_address), 
       .equation_enable(equation_enable)
       );
   
   /****************************************************************************
    Put all the equation output busses together.  This is why they are required 
    to drive 0's on all signal when not active!
    ****************************************************************************/
   assign eq_adr_o = sum_adr_o;
   assign eq_dat_o = sum_dat_o; 
   assign eq_sel_o = sum_sel_o;
   assign eq_we_o  = sum_we_o;
   assign eq_cyc_o = sum_cyc_o;
   assign eq_stb_o = sum_stb_o;
   assign eq_cti_o = sum_cti_o;
   assign eq_bte_o = sum_bte_o;   
   assign eq_cti_o = 0;
   assign eq_bte_o = 0;
   assign equation_done = sum_equation_done;
   
endmodule // wb_dsp_equations_top

