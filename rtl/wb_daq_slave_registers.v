//                              -*- Mode: Verilog -*-
// Filename        : wb_daq_slave_registers.v
// Description     : WB Data Acquisition Slave Registers
// Author          : Philip Tracton
// Created On      : Tue Dec 15 20:52:45 2015
// Last Modified By: Philip Tracton
// Last Modified On: Tue Dec 15 20:52:45 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!


//`include "wb_daq_slave_registers_include.vh"

module wb_daq_slave_registers (/*AUTOARG*/
   // Outputs
   wb_dat_o, wb_ack_o, wb_err_o, wb_rty_o, slave_reg, interrupt,
   // Inputs
   wb_clk, wb_rst, wb_adr_i, wb_dat_i, wb_sel_i, wb_we_i, wb_cyc_i,
   wb_stb_i, wb_cti_i, wb_bte_i
   ) ;
   parameter dw = 32;
   parameter aw = 8;
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

   output reg [dw-1:0]    slave_reg;   
   output reg             interrupt = 0;
   
   always @(posedge wb_clk)
     if (wb_rst) begin
        wb_ack_o <= 1'b0;
        wb_err_o <= 1'b0;
        wb_rty_o <= 1'b0;  
        
     end else begin
        if (wb_cyc_i & wb_stb_i) begin
           wb_ack_o <= 1;           
        end else begin
           wb_ack_o <= 0;           
        end
     end // else: !if(wb_rst)

   //
   // Register Write Logic
   //
   always @(posedge wb_clk)
     if (wb_rst) begin
        slave_reg <= 0;
        
     end else begin
        if (wb_cyc_i & wb_stb_i & wb_we_i) begin
           case (wb_adr_i[3:0])                         
             4'h0:begin
                slave_reg[7:0]   <= wb_sel_i[0] ? wb_dat_i[7:0]   : slave_reg[7:0];                
                slave_reg[15:8]  <= wb_sel_i[1] ? wb_dat_i[15:8]  : slave_reg[15:8];                
                slave_reg[23:16] <= wb_sel_i[2] ? wb_dat_i[23:16] : slave_reg[23:16]; 
                slave_reg[31:24] <= wb_sel_i[3] ? wb_dat_i[31:24] : slave_reg[31:24];               
             end 
           endcase // case (wb_adr_i[3:0])
        end // if (wb_cyc_i & wb_stb_i & wb_we_i)        
     end // else: !if(wb_rst)   

   //
   // Register Read Logic
   //
   always @(posedge wb_clk)
     if (wb_rst) begin
        wb_dat_o <= 32'b0;        
     end else begin
        if (wb_cyc_i & wb_stb_i & ~wb_we_i) begin
           case (wb_adr_i[3:0])
             4'h0                        : wb_dat_o <= slave_reg;
           endcase // case (wb_adr_i[3:0])           
        end
     end // else: !if(wb_rst)
   
   
endmodule // wb_daq_slave_registers