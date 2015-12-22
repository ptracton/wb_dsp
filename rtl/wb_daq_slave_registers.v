//                              -*- Mode: Verilog -*-
// Filename        : wb_daq_slave_registers.v
// Description     : WB Data Acquisition Slave Registers
// Author          : Philip Tracton
// Created On      : Tue Dec 15 20:52:45 2015
// Last Modified By: Philip Tracton
// Last Modified On: Tue Dec 15 20:52:45 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!


`include "wb_daq_slave_registers_include.vh"

module wb_daq_slave_registers (/*AUTOARG*/
   // Outputs
   wb_dat_o, wb_ack_o, wb_err_o, wb_rty_o, daq_control_reg,
   daq_channel0_address_reg, daq_channel1_address_reg,
   daq_channel2_address_reg, daq_channel3_address_reg,
   daq_channel0_control_reg, daq_channel1_control_reg,
   daq_channel2_control_reg, daq_channel3_control_reg, interrupt,
   // Inputs
   wb_clk, wb_rst, wb_adr_i, wb_dat_i, wb_sel_i, wb_we_i, wb_cyc_i,
   wb_stb_i, wb_cti_i, wb_bte_i, daq_channel0_status_reg,
   daq_channel1_status_reg, daq_channel2_status_reg,
   daq_channel3_status_reg
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
   output wire            wb_ack_o;
   output wire            wb_err_o;
   output wire            wb_rty_o;

   output reg [dw-1:0]    daq_control_reg;
   output reg [dw-1:0]    daq_channel0_address_reg;
   output reg [dw-1:0]    daq_channel1_address_reg;
   output reg [dw-1:0]    daq_channel2_address_reg;
   output reg [dw-1:0]    daq_channel3_address_reg;

   output reg [dw-1:0]    daq_channel0_control_reg;
   output reg [dw-1:0]    daq_channel1_control_reg;
   output reg [dw-1:0]    daq_channel2_control_reg;
   output reg [dw-1:0]    daq_channel3_control_reg;

   input wire [dw-1:0]    daq_channel0_status_reg;
   input wire [dw-1:0]    daq_channel1_status_reg;
   input wire [dw-1:0]    daq_channel2_status_reg;
   input wire [dw-1:0]    daq_channel3_status_reg;   
   
   output reg             interrupt = 0;


   assign wb_ack_o = wb_cyc_i & wb_stb_i;
   assign wb_err_o = 0;
   assign wb_rty_o = 0;
   
/* -----\/----- EXCLUDED -----\/-----
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
 -----/\----- EXCLUDED -----/\----- */

   //
   // Register Write Logic
   //
   always @(posedge wb_clk)
     if (wb_rst) begin
        daq_control_reg <= 0;
        daq_channel0_address_reg <= 0;
        daq_channel1_address_reg <= 0;
        daq_channel2_address_reg <= 0;
        daq_channel3_address_reg <= 0;
        daq_channel0_control_reg <= 0;
        daq_channel1_control_reg <= 0;
        daq_channel2_control_reg <= 0;
        daq_channel3_control_reg <= 0;                
     end else begin
        if (wb_cyc_i & wb_stb_i & wb_we_i) begin
           case (wb_adr_i)                         
             `DAQ_CONTROL_REG_OFFSET:begin
                daq_control_reg[7:0]   <= wb_sel_i[0] ? wb_dat_i[7:0]   : daq_control_reg[7:0];                
                daq_control_reg[15:8]  <= wb_sel_i[1] ? wb_dat_i[15:8]  : daq_control_reg[15:8];                
                daq_control_reg[23:16] <= wb_sel_i[2] ? wb_dat_i[23:16] : daq_control_reg[23:16]; 
                daq_control_reg[31:24] <= wb_sel_i[3] ? wb_dat_i[31:24] : daq_control_reg[31:24];               
             end
             `DAQ_CHANNEL0_ADDRESS_OFFSET: begin
                daq_channel0_address_reg[7:0]   <= wb_sel_i[0] ? wb_dat_i[7:0]   : daq_channel0_address_reg[7:0];                
                daq_channel0_address_reg[15:8]  <= wb_sel_i[1] ? wb_dat_i[15:8]  : daq_channel0_address_reg[15:8];                
                daq_channel0_address_reg[23:16] <= wb_sel_i[2] ? wb_dat_i[23:16] : daq_channel0_address_reg[23:16]; 
                daq_channel0_address_reg[31:24] <= wb_sel_i[3] ? wb_dat_i[31:24] : daq_channel0_address_reg[31:24];               
             end
             `DAQ_CHANNEL0_CONTROL_OFFSET: begin
                daq_channel0_control_reg[7:0]   <= wb_sel_i[0] ? wb_dat_i[7:0]   : daq_channel0_control_reg[7:0];                
                daq_channel0_control_reg[15:8]  <= wb_sel_i[1] ? wb_dat_i[15:8]  : daq_channel0_control_reg[15:8];                
                daq_channel0_control_reg[23:16] <= wb_sel_i[2] ? wb_dat_i[23:16] : daq_channel0_control_reg[23:16]; 
                daq_channel0_control_reg[31:24] <= wb_sel_i[3] ? wb_dat_i[31:24] : daq_channel0_control_reg[31:24];               
             end             
             `DAQ_CHANNEL1_ADDRESS_OFFSET: begin
                daq_channel1_address_reg[7:0]   <= wb_sel_i[0] ? wb_dat_i[7:0]   : daq_channel1_address_reg[7:0];                
                daq_channel1_address_reg[15:8]  <= wb_sel_i[1] ? wb_dat_i[15:8]  : daq_channel1_address_reg[15:8];                
                daq_channel1_address_reg[23:16] <= wb_sel_i[2] ? wb_dat_i[23:16] : daq_channel1_address_reg[23:16]; 
                daq_channel1_address_reg[31:24] <= wb_sel_i[3] ? wb_dat_i[31:24] : daq_channel1_address_reg[31:24];               
             end
             `DAQ_CHANNEL1_CONTROL_OFFSET: begin
                daq_channel1_control_reg[7:0]   <= wb_sel_i[0] ? wb_dat_i[7:0]   : daq_channel1_control_reg[7:0];                
                daq_channel1_control_reg[15:8]  <= wb_sel_i[1] ? wb_dat_i[15:8]  : daq_channel1_control_reg[15:8];                
                daq_channel1_control_reg[23:16] <= wb_sel_i[2] ? wb_dat_i[23:16] : daq_channel1_control_reg[23:16]; 
                daq_channel1_control_reg[31:24] <= wb_sel_i[3] ? wb_dat_i[31:24] : daq_channel1_control_reg[31:24];               
             end             
             `DAQ_CHANNEL2_ADDRESS_OFFSET: begin
                daq_channel2_address_reg[7:0]   <= wb_sel_i[0] ? wb_dat_i[7:0]   : daq_channel2_address_reg[7:0];                
                daq_channel2_address_reg[15:8]  <= wb_sel_i[1] ? wb_dat_i[15:8]  : daq_channel2_address_reg[15:8];                
                daq_channel2_address_reg[23:16] <= wb_sel_i[2] ? wb_dat_i[23:16] : daq_channel2_address_reg[23:16]; 
                daq_channel2_address_reg[31:24] <= wb_sel_i[3] ? wb_dat_i[31:24] : daq_channel2_address_reg[31:24];               
             end
             `DAQ_CHANNEL2_CONTROL_OFFSET: begin
                daq_channel2_control_reg[7:0]   <= wb_sel_i[0] ? wb_dat_i[7:0]   : daq_channel2_control_reg[7:0];                
                daq_channel2_control_reg[15:8]  <= wb_sel_i[1] ? wb_dat_i[15:8]  : daq_channel2_control_reg[15:8];                
                daq_channel2_control_reg[23:16] <= wb_sel_i[2] ? wb_dat_i[23:16] : daq_channel2_control_reg[23:16]; 
                daq_channel2_control_reg[31:24] <= wb_sel_i[3] ? wb_dat_i[31:24] : daq_channel2_control_reg[31:24];               
             end             
             `DAQ_CHANNEL3_ADDRESS_OFFSET: begin
                daq_channel3_address_reg[7:0]   <= wb_sel_i[0] ? wb_dat_i[7:0]   : daq_channel3_address_reg[7:0];                
                daq_channel3_address_reg[15:8]  <= wb_sel_i[1] ? wb_dat_i[15:8]  : daq_channel3_address_reg[15:8];                
                daq_channel3_address_reg[23:16] <= wb_sel_i[2] ? wb_dat_i[23:16] : daq_channel3_address_reg[23:16]; 
                daq_channel3_address_reg[31:24] <= wb_sel_i[3] ? wb_dat_i[31:24] : daq_channel3_address_reg[31:24];
             end             
             `DAQ_CHANNEL3_CONTROL_OFFSET: begin
                daq_channel3_control_reg[7:0]   <= wb_sel_i[0] ? wb_dat_i[7:0]   : daq_channel3_control_reg[7:0];                
                daq_channel3_control_reg[15:8]  <= wb_sel_i[1] ? wb_dat_i[15:8]  : daq_channel3_control_reg[15:8];                
                daq_channel3_control_reg[23:16] <= wb_sel_i[2] ? wb_dat_i[23:16] : daq_channel3_control_reg[23:16]; 
                daq_channel3_control_reg[31:24] <= wb_sel_i[3] ? wb_dat_i[31:24] : daq_channel3_control_reg[31:24];               
             end             
           endcase // case (wb_adr_i)           
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
             `DAQ_CONTROL_REG_OFFSET : wb_dat_o <= daq_control_reg;
             `DAQ_CHANNEL0_ADDRESS_OFFSET : wb_dat_o <= daq_channel0_address_reg;
             `DAQ_CHANNEL1_ADDRESS_OFFSET : wb_dat_o <= daq_channel1_address_reg;
             `DAQ_CHANNEL2_ADDRESS_OFFSET : wb_dat_o <= daq_channel2_address_reg;
             `DAQ_CHANNEL3_ADDRESS_OFFSET : wb_dat_o <= daq_channel3_address_reg;
             `DAQ_CHANNEL0_CONTROL_OFFSET : wb_dat_o <= daq_channel0_control_reg;
             `DAQ_CHANNEL1_CONTROL_OFFSET : wb_dat_o <= daq_channel1_control_reg;
             `DAQ_CHANNEL2_CONTROL_OFFSET : wb_dat_o <= daq_channel2_control_reg;
             `DAQ_CHANNEL3_CONTROL_OFFSET : wb_dat_o <= daq_channel3_control_reg;
             `DAQ_CHANNEL0_STATUS_OFFSET  : wb_dat_o <= daq_channel0_status_reg;
             `DAQ_CHANNEL1_STATUS_OFFSET  : wb_dat_o <= daq_channel1_status_reg;
             `DAQ_CHANNEL2_STATUS_OFFSET  : wb_dat_o <= daq_channel2_status_reg;
             `DAQ_CHANNEL3_STATUS_OFFSET  : wb_dat_o <= daq_channel3_status_reg;             
             default: wb_dat_o <= 0;             
           endcase // case (wb_adr_i[3:0])           
        end
     end // else: !if(wb_rst)
   
   
endmodule // wb_daq_slave_registers
