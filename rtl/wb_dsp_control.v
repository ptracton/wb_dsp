//                              -*- Mode: Verilog -*-
// Filename        : wb_dsp_control.v
// Description     : Controller of wishbone master interface
// Author          : Philip Tracton
// Created On      : Wed Dec  2 13:02:02 2015
// Last Modified By: Philip Tracton
// Last Modified On: Wed Dec  2 13:02:02 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!

`include "wb_dsp_slave_registers_include.vh"

module wb_dsp_control (/*AUTOARG*/
   // Outputs
   wb_adr_o, wb_dat_o, wb_sel_o, wb_we_o, wb_cyc_o, wb_stb_o,
   wb_cti_o, wb_bte_o, status_reg,
   // Inputs
   wb_clk, wb_rst, wb_dat_i, wb_ack_i, wb_err_i, wb_rty_i,
   equation_address_reg, control_reg
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
   
   input [dw-1:0]       equation_address_reg;
   input [dw-1:0]       control_reg;
   output wire [dw-1:0] status_reg;
   
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire                 active;                 // From master of wb_master_interface.v
   wire [dw-1:0]        data_rd;                // From master of wb_master_interface.v
   // End of automatics
   /*AUTOREG*/
   reg                  start;
   reg [aw-1:0]         address;
   reg [3:0]            selection;
   reg                  write;
   reg [dw-1:0]         data_wr;

   //
   // Control Register Bits
   //
   wire                 start_equation = control_reg[`CONTROL_REG_START_EQUATION];
   wire                 stop_equation  = control_reg[`CONTROL_REG_STOP_EQUATION];
   wire [7:0]           equation       = control_reg[`CONTROL_EQUATION_EQUATION];
   
   
   //
   // Status Register Bits
   //
   assign status_reg[`STATUS_REG_ACTIVE] = active;
   assign status_reg[31:1] = 0;
      
   
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


   parameter STATE_IDLE                 = 4'h0;
   parameter STATE_ERROR                = 4'h1;
   parameter STATE_GET_EQUATION_HEADER  = 4'h2;
   parameter STATE_WAIT_EQUATION_HEADER = 4'h2;
   parameter STATE_RUN_EQUATION         = 4'h3;
   parameter STATE_FINISH_EQUATION      = 4'h4;

   reg [3:0]            state;
   reg [3:0]            next_state;

   always @(posedge wb_clk)
     if (wb_rst) begin
        state <= STATE_IDLE;        
     end else begin
        state <= next_state;        
     end

   always @(*)
     if (wb_rst) begin
        next_state = STATE_IDLE;
        start      = 0;
        address    = 0;
        selection  = 0;
        write      = 0;
        data_wr    = 0;        
        
     end else begin
        case (next_state)
          STATE_IDLE: begin
             start      = 0;
             address    = 0;
             selection  = 0;
             write      = 0;
             data_wr    = 0;        
                          
             if (start_equation) begin
                next_state = STATE_GET_EQUATION_HEADER;
             end else begin
                next_state = STATE_IDLE;
             end
          end
          
          STATE_GET_EQUATION_HEADER:begin
             
          end
          
         STATE_ERROR: begin
            next_state = STATE_IDLE;            
         end
          
          default:begin
             next_state = STATE_IDLE;            
          end
        endcase // case (next_state)        
     end
   
`ifdef SIM
   reg [32*8-1:0] state_name;
   always @(*)
     case (state)
       STATE_IDLE: state_name         = "STATE_IDLE";
       STATE_ERROR: state_name        = "STATE_ERROR";       
       default: state_name            = "DEFAULT";
     endcase // case (state)
   
`endif   
   
endmodule // wb_dsp_control
