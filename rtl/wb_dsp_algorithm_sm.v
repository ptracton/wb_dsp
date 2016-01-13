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

module wb_dsp_algorithm_sm (/*AUTOARG*/
   // Outputs
   alg_start, alg_address, alg_selection, alg_write, alg_data_wr,
   status_reg, equation_enable, base_address,
   // Inputs
   wb_clk, wb_rst, alg_data_rd, begin_equation, equation0_address_reg,
   equation1_address_reg, equation2_address_reg,
   equation3_address_reg, control_reg, equation_done, active
   ) ;

   parameter dw = 32;
   parameter aw = 32;
   parameter DEBUG = 0;

   input               wb_clk;
   input               wb_rst;
   output reg          alg_start;
   output reg [aw-1:0] alg_address;      
   output reg [3:0]    alg_selection;
   output reg          alg_write;
   output reg [dw-1:0] alg_data_wr;
   input wire [dw-1:0] alg_data_rd;
   
   input [3:0]          begin_equation;
   input [dw-1:0]       equation0_address_reg;
   input [dw-1:0]       equation1_address_reg;
   input [dw-1:0]       equation2_address_reg;
   input [dw-1:0]       equation3_address_reg;
   input [dw-1:0]       control_reg;
   output wire [dw-1:0] status_reg;   
   output reg [7:0]     equation_enable;
   input                equation_done;
   output reg [aw-1:0]  base_address;
   input                active;
   
   /*AUTOWIRE*/
   /*AUTOREG*/

   reg [dw-1:0]         equation_control;
   reg [dw-1:0]         equation_status;
   reg [dw-1:0]         equation_next;

   reg [4:0]            state;
   reg [4:0]            next_state;
   
   parameter STATE_IDLE                 = 5'h00;
   parameter STATE_FETCH_CONTROL        = 5'h01;
   parameter STATE_FETCH_CONTROL_DONE   = 5'h02;
   parameter STATE_FETCH_STATUS         = 5'h03;
   parameter STATE_FETCH_STATUS_DONE    = 5'h04;
   parameter STATE_FETCH_NEXT           = 5'h05;
   parameter STATE_FETCH_NEXT_DONE      = 5'h06;
   parameter STATE_RUN_EQUATION         = 5'h07; 
   parameter STATE_WRITE_STATUS         = 5'h08;
   parameter STATE_WRITE_STATUS_DONE    = 5'h09;  
   parameter STATE_ERROR                = 5'h1F;
   
   wire                 equation_alg_active = (state != STATE_IDLE);         
   
   //
   // Control Register Bits
   //
   wire                 manual_start_equation;
   reg                  manual_start_equation_delay;
   reg                  current;   
   reg                  previous;   
   always @(posedge wb_clk)
     if (wb_rst) begin
        current <=0;
        previous <= 0;
        manual_start_equation_delay <=0;        
     end else begin
        previous <= manual_start_equation;        
        current<= |control_reg[`CONTROL_REG_BEGIN_EQUATION];
        manual_start_equation_delay <= manual_start_equation;        
     end
   
   assign manual_start_equation = (current & !previous) & !equation_alg_active;

   //assign manual_start_equation = (current & !previous) & !equation_alg_active;   
   
   wire                 start_equation =  (manual_start_equation |manual_start_equation_delay | begin_equation);
   wire                 stop_equation  = control_reg[`CONTROL_REG_STOP_EQUATION];
   
   
   //
   // Status Register Bits
   //
   assign status_reg[`STATUS_REG_ACTIVE] = active;
   assign status_reg[31:1] = 0;
      
   //
   //
   //


   


   always @(posedge wb_clk)
     if (wb_rst) begin
        state <= STATE_IDLE;        
     end else begin
        state <= next_state;        
     end

  always @(*)
    if (wb_rst) begin
       next_state   = STATE_IDLE;
       alg_start     = 0;
       alg_address   = 0;
       alg_selection = 0;
       alg_write     = 0;
       alg_data_wr   = 0;
       base_address = 0;
       equation_control = 0;
       equation_status  = 0;
       equation_next    = 0; 
       equation_enable  = 0;       
    end else begin
       case (state)
         
         STATE_IDLE: begin
            alg_start     = 0;
            alg_address   = 0;
            alg_selection = 0;
            alg_write     = 0;
            alg_data_wr   = 0;
            //base_address = 0;
            equation_control = 0;
            equation_status  = 0;
            equation_next    = 0; 
            equation_enable  = 0;                   
            if (start_equation) begin
               next_state = STATE_FETCH_CONTROL; 
               base_address = (begin_equation[0] | control_reg [0]) ? equation0_address_reg :
                              (begin_equation[1] | control_reg [1]) ? equation1_address_reg :
                              (begin_equation[2] | control_reg [2]) ? equation2_address_reg :
                              (begin_equation[3] | control_reg [3]) ? equation3_address_reg : 0;               
            end else begin
               next_state = STATE_IDLE;               
            end
         end // case: STATE_IDLE
         
         STATE_FETCH_CONTROL: begin
            alg_address = base_address + `EQUATION_CONTROL_OFFSET;
            alg_selection = 4'hF;
            alg_write = 0;
            alg_start = 1;                
            next_state =  STATE_FETCH_CONTROL_DONE;     
         end

         STATE_FETCH_CONTROL_DONE: begin
            alg_start = 0;             
            if (active) begin                               
               next_state =  STATE_FETCH_CONTROL_DONE;
            end else begin       
               equation_control = alg_data_rd;                
               next_state = STATE_FETCH_STATUS;                
             end             
         end         

         STATE_FETCH_STATUS: begin
            alg_address = base_address + `EQUATION_STATUS_OFFSET;
            alg_selection = 4'hF;
            alg_write = 0;
            alg_start = 1;                
            next_state =  STATE_FETCH_STATUS_DONE;     
         end

         STATE_FETCH_STATUS_DONE: begin
            alg_start = 0;             
            if (active) begin                               
               next_state =  STATE_FETCH_STATUS_DONE;
            end else begin       
               equation_status = alg_data_rd;                
               next_state = STATE_FETCH_NEXT;                
             end             
         end 

         STATE_FETCH_NEXT: begin
            alg_address = base_address + `EQUATION_NEXT_ADDRESS_OFFSET;
            alg_selection = 4'hF;
            alg_write = 0;
            alg_start = 1;                
            next_state =  STATE_FETCH_NEXT_DONE;     
         end

         STATE_FETCH_NEXT_DONE: begin
            alg_start = 0;             
            if (active) begin                               
               next_state =  STATE_FETCH_NEXT_DONE;
            end else begin       
               equation_next = alg_data_rd;                
               next_state = STATE_RUN_EQUATION;                
             end             
         end
         
         STATE_RUN_EQUATION:begin
            equation_enable = equation_control[`CONTROL_EQUATION_EQUATION];
            if (equation_done) begin
               next_state = STATE_IDLE;               
            end else begin
               next_state = STATE_RUN_EQUATION;               
            end
         end
         
         STATE_ERROR: begin
            next_state = STATE_IDLE;                
         end

         default begin
            next_state = STATE_IDLE;                
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
       STATE_RUN_EQUATION: state_name       = "STATE RUN EQUATION";
       default: state_name                  = "DEFAULT";
     endcase // case (state)
   
`endif   
   
endmodule // wb_dsp_algorithm_sm


