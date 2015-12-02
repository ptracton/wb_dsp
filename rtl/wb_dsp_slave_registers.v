//                              -*- Mode: Verilog -*-
// Filename        : wb_dsp_slave_regs.v
// Description     : Slave register interface for wishbone DSP
// Author          : Philip Tracton
// Created On      : Fri Nov 27 13:36:52 2015
// Last Modified By: Philip Tracton
// Last Modified On: Fri Nov 27 13:36:52 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!

module wb_dsp_slave_registers (/*AUTOARG*/
   // Outputs
   wb_dat_o, wb_ack_o, wb_err_o, wb_rty_o, slave_reg0, slave_reg1,
   slave_reg2, slave_reg3, interrupt,
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

   output reg [dw-1:0]    slave_reg0;
   output reg [dw-1:0]    slave_reg1;
   output reg [dw-1:0]    slave_reg2;
   output reg [dw-1:0]    slave_reg3;
   output reg             interrupt = 0;
   
   reg [aw-1:0]           addr_reg;
   reg [dw-1:0]           data_reg;
   
   
   always @(posedge wb_clk)
     if (wb_rst) begin
        wb_ack_o <= 1'b0;
        wb_err_o <= 1'b0;
        wb_rty_o <= 1'b0;  
        addr_reg <= 32'b0;
        data_reg <= 32'b0;
        
     end else begin
        if (wb_cyc_i & wb_stb_i) begin
           addr_reg <= wb_adr_i;
           data_reg <= wb_dat_i;
           wb_ack_o <= 1;           
        end else begin
           wb_ack_o <= 0;           
        end
           
        
     end
   
   //
   // Register Write Logic
   //
   always @(posedge wb_clk)
     if (wb_rst) begin
        slave_reg0 <= 32'b0;
        slave_reg1 <= 32'b0;
        slave_reg2 <= 32'b0;
        slave_reg3 <= 32'b0;        
     end else begin
        if (wb_cyc_i & wb_stb_i & wb_we_i) begin
           case (wb_adr_i[3:0])
             4'h0: begin
                slave_reg0[7:0]   <= wb_sel_i[0] ? wb_dat_i[7:0]   : slave_reg0[7:0];                
                slave_reg0[15:8]  <= wb_sel_i[1] ? wb_dat_i[15:8]  : slave_reg0[15:8];                               
                slave_reg0[23:16] <= wb_sel_i[2] ? wb_dat_i[23:16] : slave_reg0[23:16];
                slave_reg0[31:24] <= wb_sel_i[3] ? wb_dat_i[31:24] : slave_reg0[31:24];
                
             end
             4'h4:begin
                slave_reg1[7:0]   <= wb_sel_i[0] ? wb_dat_i[7:0]   : slave_reg1[7:0];                
                slave_reg1[15:8]  <= wb_sel_i[1] ? wb_dat_i[15:8]  : slave_reg1[15:8];               
                slave_reg1[23:16] <= wb_sel_i[2] ? wb_dat_i[23:16] : slave_reg1[23:16];                
                slave_reg1[31:24] <= wb_sel_i[3] ? wb_dat_i[31:24] : slave_reg0[31:24];                
             end
             
             4'h8:begin
                slave_reg2[7:0]   <= wb_sel_i[0] ? wb_dat_i[7:0]   : slave_reg2[7:0];                                               
                slave_reg2[15:8]  <= wb_sel_i[1] ? wb_dat_i[15:8]  : slave_reg2[15:8];                
                slave_reg2[23:16] <= wb_sel_i[2] ? wb_dat_i[23:16] : slave_reg2[23:16]; 
                slave_reg2[31:24] <= wb_sel_i[3] ? wb_dat_i[31:24] : slave_reg2[31:24];                
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
             4'h0: wb_dat_o <= slave_reg0;
             4'h4: wb_dat_o <= slave_reg1;
             4'h8: wb_dat_o <= slave_reg2;
             4'hC: wb_dat_o <= slave_reg3;
           endcase // case (wb_adr_i[3:0])           
        end
     end
   
endmodule // testing_wb_slave
