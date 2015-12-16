//                              -*- Mode: Verilog -*-
// Filename        : wb_dsp_slave_regs.v
// Description     : Slave register interface for wishbone DSP
// Author          : Philip Tracton
// Created On      : Fri Nov 27 13:36:52 2015
// Last Modified By: Philip Tracton
// Last Modified On: Fri Nov 27 13:36:52 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!

`include "wb_dsp_slave_registers_include.vh"

module wb_dsp_slave_registers (/*AUTOARG*/
   // Outputs
   wb_dat_o, wb_ack_o, wb_err_o, wb_rty_o, equation_address_reg,
   control_reg, slave_reg3, interrupt,
   // Inputs
   wb_clk, wb_rst, wb_adr_i, wb_dat_i, wb_sel_i, wb_we_i, wb_cyc_i,
   wb_stb_i, wb_cti_i, wb_bte_i, status_reg
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

   input [dw-1:0]         status_reg;   
   output reg [dw-1:0]    equation_address_reg;
   output reg [dw-1:0]    control_reg;
   output reg [dw-1:0]    slave_reg3;
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
        equation_address_reg <= 32'b0;
        control_reg <= 32'b0;
     end else begin
        if (wb_cyc_i & wb_stb_i & wb_we_i) begin
           case (wb_adr_i[3:0])
             `EQUATION_ADDRESS_REG_OFFSET: begin
                equation_address_reg[7:0]   <= wb_sel_i[0] ? wb_dat_i[7:0]   : equation_address_reg[7:0];
                equation_address_reg[15:8]  <= wb_sel_i[1] ? wb_dat_i[15:8]  : equation_address_reg[15:8];
                equation_address_reg[23:16] <= wb_sel_i[2] ? wb_dat_i[23:16] : equation_address_reg[23:16];
                equation_address_reg[31:24] <= wb_sel_i[3] ? wb_dat_i[31:24] : equation_address_reg[31:24];
                
             end
             `CONTROL_REG_OFFSET :begin
                control_reg[7:0]   <= wb_sel_i[0] ? wb_dat_i[7:0]   : control_reg[7:0];                
                control_reg[15:8]  <= wb_sel_i[1] ? wb_dat_i[15:8]  : control_reg[15:8];               
                control_reg[23:16] <= wb_sel_i[2] ? wb_dat_i[23:16] : control_reg[23:16];
                control_reg[31:24] <= wb_sel_i[3] ? wb_dat_i[31:24] : control_reg[31:24];
             end
                          
             4'hC:begin
                slave_reg3[7:0]   <= wb_sel_i[0] ? wb_dat_i[7:0]   : slave_reg3[7:0];                
                slave_reg3[15:8]  <= wb_sel_i[1] ? wb_dat_i[15:8]  : slave_reg3[15:8];                
                slave_reg3[23:16] <= wb_sel_i[2] ? wb_dat_i[23:16] : slave_reg3[23:16]; 
                slave_reg3[31:24] <= wb_sel_i[3] ? wb_dat_i[31:24] : slave_reg3[31:24];               
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
             `EQUATION_ADDRESS_REG_OFFSET: wb_dat_o <= equation_address_reg;
             `CONTROL_REG_OFFSET         : wb_dat_o <= control_reg;
             `STATUS_REG_OFFSET          : wb_dat_o <= status_reg;
             4'hC                        : wb_dat_o <= slave_reg3;
           endcase // case (wb_adr_i[3:0])           
        end
     end // else: !if(wb_rst)
   
   
endmodule // testing_wb_slave
