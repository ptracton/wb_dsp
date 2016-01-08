//                              -*- Mode: Verilog -*-
// Filename        : wb_dsp_equation_sm.v
// Description     : WB DSP Equation State Machine
// Author          : Philip Tracton
// Created On      : Fri Jan  8 13:47:49 2016
// Last Modified By: Philip Tracton
// Last Modified On: Fri Jan  8 13:47:49 2016
// Update Count    : 0
// Status          : Unknown, Use with caution!

`include "wb_dsp_slave_registers_include.vh"

module wb_dsp_equation_sm (/*AUTOARG*/
   // Outputs
   wb_adr_o, wb_dat_o, wb_sel_o, wb_we_o, wb_cyc_o, wb_stb_o,
   wb_cti_o, wb_bte_o, status_reg,
   // Inputs
   wb_clk, wb_rst, wb_dat_i, wb_ack_i, wb_err_i, wb_rty_i,
   begin_equation, equation0_address_reg, equation1_address_reg,
   equation2_address_reg, equation3_address_reg, control_reg
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

   input [3:0]          begin_equation;
   input [dw-1:0]       equation0_address_reg;
   input [dw-1:0]       equation1_address_reg;
   input [dw-1:0]       equation2_address_reg;
   input [dw-1:0]       equation3_address_reg;
   input [dw-1:0]       control_reg;
   output wire [dw-1:0] status_reg;
   
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire                 active;                 // From master of wb_master_interface.v
   wire [dw-1:0]        data_rd;                // From master of wb_master_interface.v
   // End of automatics
   /*AUTOREG*/
   reg                  sm_start;
   reg [aw-1:0]         sm_address;
   reg [3:0]            sm_selection;
   reg                  sm_write;
   reg [dw-1:0]         sm_data_wr;
   reg [dw-1:0]         equation_control;
   reg [dw-1:0]         equation_status;
   reg [dw-1:0]         equation_next;
   
   //
   // Control Register Bits
   //
   wire                 start_equation = |(control_reg[3:0] | begin_equation);
   wire                 stop_equation  = control_reg[`CONTROL_REG_STOP_EQUATION];
   wire [7:0]           equation       = control_reg[`CONTROL_EQUATION_EQUATION];
   
   
   //
   // Status Register Bits
   //
   assign status_reg[`STATUS_REG_ACTIVE] = active;
   assign status_reg[31:1] = 0;
      
   //
   //
   //
   reg [aw-1:0]         base_address;

   
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
                              .start            (sm_start),
                              .address          (sm_address[aw-1:0]),
                              .selection        (sm_selection[3:0]),
                              .write            (sm_write),
                              .data_wr          (sm_data_wr[dw-1:0]));

   reg [4:0]            state;
   reg [4:0]            next_state;
   
   parameter STATE_IDLE                 = 5'h00;
   parameter STATE_FETCH_CONTROL        = 5'h01;
   parameter STATE_FETCH_CONTROL_DONE   = 5'h02;
   parameter STATE_FETCH_STATUS         = 5'h03;
   parameter STATE_FETCH_STATUS_DONE    = 5'h04;
   parameter STATE_FETCH_NEXT           = 5'h05;
   parameter STATE_FETCH_NEXT_DONE      = 5'h06;
   parameter STATE_ERROR                = 5'h1F;
      
   always @(posedge wb_clk)
     if (wb_rst) begin
        state <= STATE_IDLE;        
     end else begin
        state <= next_state;        
     end

  always @(*)
    if (wb_rst) begin
       next_state   = STATE_IDLE;
       sm_start     = 0;
       sm_address   = 0;
       sm_selection = 0;
       sm_write     = 0;
       sm_data_wr   = 0;
       base_address = 0;
       equation_control = 0;
       equation_status  = 0;
       equation_next    = 0;       
    end else begin
       case (state)
         
         STATE_IDLE: begin
            sm_start     = 0;
            sm_address   = 0;
            sm_selection = 0;
            sm_write     = 0;
            sm_data_wr   = 0;
            base_address = 0;
            
            if (start_equation) begin
               next_state = STATE_FETCH_CONTROL; 
               base_address = (begin_equation[0]) ? equation0_address_reg :
                              (begin_equation[1]) ? equation1_address_reg :
                              (begin_equation[2]) ? equation2_address_reg :
                              (begin_equation[3]) ? equation3_address_reg : 0;               
            end else begin
               next_state = STATE_IDLE;               
            end
         end // case: STATE_IDLE
         
         STATE_FETCH_CONTROL: begin
            sm_address = base_address + `EQUATION_CONTROL_OFFSET;
            sm_selection = 4'hF;
            sm_write = 0;
            sm_start = 1;                
            next_state =  STATE_FETCH_CONTROL_DONE;     
         end

         STATE_FETCH_CONTROL_DONE: begin
            sm_start = 0;             
            if (active) begin                               
               next_state =  STATE_FETCH_CONTROL_DONE;
            end else begin       
               equation_control = data_rd;                
               next_state = STATE_FETCH_STATUS;                
             end             
         end         

         STATE_FETCH_STATUS: begin
            sm_address = base_address + `EQUATION_STATUS_OFFSET;
            sm_selection = 4'hF;
            sm_write = 0;
            sm_start = 1;                
            next_state =  STATE_FETCH_STATUS_DONE;     
         end

         STATE_FETCH_STATUS_DONE: begin
            sm_start = 0;             
            if (active) begin                               
               next_state =  STATE_FETCH_STATUS_DONE;
            end else begin       
               equation_status = data_rd;                
               next_state = STATE_FETCH_NEXT;                
             end             
         end 

         STATE_FETCH_NEXT: begin
            sm_address = base_address + `EQUATION_NEXT_ADDRESS_OFFSET;
            sm_selection = 4'hF;
            sm_write = 0;
            sm_start = 1;                
            next_state =  STATE_FETCH_NEXT_DONE;     
         end

         STATE_FETCH_NEXT_DONE: begin
            sm_start = 0;             
            if (active) begin                               
               next_state =  STATE_FETCH_NEXT_DONE;
            end else begin       
               equation_next = data_rd;                
               next_state = STATE_IDLE;                
             end             
         end             
         
       endcase // case (state)
       
    end
      
   
`ifdef SIM
   reg [32*8-1:0] state_name;
   always @(*)
     case (state)
       STATE_IDLE: state_name               = "STATE_IDLE";
       STATE_FETCH_CONTROL: state_name      = "STATE FETCH CONTROL";
       STATE_FETCH_CONTROL_DONE: state_name = "STATE FETCH CONTROL DONE";
       STATE_FETCH_STATUS: state_name       = "STATE FETCH STATUS";
       STATE_FETCH_STATUS_DONE: state_name  = "STATE FETCH STATUS DONE";   
       STATE_FETCH_NEXT: state_name         = "STATE FETCH NEXT";
       STATE_FETCH_NEXT_DONE: state_name    = "STATE FETCH NEXT DONE";    
       STATE_ERROR: state_name              = "STATE_ERROR";       
       default: state_name                  = "DEFAULT";
     endcase // case (state)
   
`endif   
   
endmodule // wb_dsp_equation_sm

