//                              -*- Mode: Verilog -*-
// Filename        : wb_daq_bus_master.v
// Description     : WB Data Acquisition Bus Master
// Author          : Philip Tracton
// Created On      : Tue Dec 15 20:57:41 2015
// Last Modified By: Philip Tracton
// Last Modified On: Tue Dec 15 20:57:41 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!

`include "wb_daq_slave_registers_include.vh"

module wb_daq_bus_master (/*AUTOARG*/
   // Outputs
   wb_adr_o, wb_dat_o, wb_sel_o, wb_we_o, wb_cyc_o, wb_stb_o,
   wb_cti_o, wb_bte_o, data_done, begin_equation,
   // Inputs
   wb_clk, wb_rst, wb_dat_i, wb_ack_i, wb_err_i, wb_rty_i,
   control_reg, daq_channel_control, channel_select, start,
   fifo_empty, address, selection, write, data_wr
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
   input [dw-1:0]       daq_channel_control;
   input [1:0]          channel_select;
   
   /*AUTOREG*/
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire                 active;                 // From master of wb_master_interface.v
   wire [dw-1:0]        data_rd;                // From master of wb_master_interface.v
   // End of automatics

   input                start;
   output reg           data_done; 
   input                fifo_empty;   
   input [aw-1:0]       address;
   input [3:0]          selection;
   input                write;
   input [dw-1:0]       data_wr;
   output reg [3:0]     begin_equation;
   
   reg [aw-1:0]       base_address;
   reg                sm_start;
   reg [aw-1:0]       sm_address;
   reg [3:0]          sm_selection;
   reg                sm_write;
   reg [dw-1:0]       sm_data_wr;
   reg [dw-1:0]       hold_data_wr;
   reg [dw-1:0]       sm_data_rd;
   reg [dw-1:0]       sm_daq_channel_control;
   reg [dw-1:0]       wr_ptr;
   reg [dw-1:0]       start_ptr;
   reg [dw-1:0]       end_ptr;
   reg [dw-1:0]       sm_status;
   reg [1:0]          sm_channel_select;
   
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
                              .selection        (selection[3:0]),
                              .write            (sm_write),
                              .data_wr          (sm_data_wr[dw-1:0]));


   reg [4:0]            state;
   reg [4:0]            next_state;
   
   parameter STATE_IDLE                 = 5'h00;
   parameter STATE_FETCH_WR_PTR         = 5'h01;
   parameter STATE_FETCH_WR_PTR_DONE    = 5'h02;
   parameter STATE_FETCH_STATUS         = 5'h03;
   parameter STATE_FETCH_STATUS_DONE    = 5'h04;   
   parameter STATE_FETCH_START_PTR      = 5'h05;
   parameter STATE_FETCH_START_PTR_DONE = 5'h06;
   parameter STATE_FETCH_END_PTR        = 5'h07;
   parameter STATE_FETCH_END_PTR_DONE   = 5'h08;
   parameter STATE_WRITE_DATA           = 5'h09;
   parameter STATE_WRITE_DATA_DONE      = 5'h0A;
   parameter STATE_UPDATE_WR_PTR        = 5'h0B;
   parameter STATE_WRITE_WR_PTR         = 5'h0C;
   parameter STATE_WRITE_WR_PTR_DONE    = 5'h0D;
   parameter STATE_WRITE_STATUS         = 5'h0E;
   parameter STATE_WRITE_STATUS_DONE    = 5'h0F;   
   parameter STATE_RETRY                = 5'h1E;   
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
        sm_data_rd   = 0;
        wr_ptr       = 0;
        end_ptr      = 0;
        start_ptr    = 0;  
        hold_data_wr = 0;
        base_address = 0;        
        data_done    = 0;
        sm_status    = 0;  
        begin_equation = 0;
        sm_daq_channel_control = 0; 
        sm_channel_select = 0;        
     end else begin
        case (state)
          STATE_IDLE: begin
             sm_start     = 0;
             sm_address   = 0;
             sm_selection = 0;
             sm_write     = 0;
             sm_data_wr   = 0;  
             sm_data_rd   = 0;
             wr_ptr       = 0;
             end_ptr      = 0;
             start_ptr    = 0;
             hold_data_wr = 0;
             base_address = 0;
             data_done    = 0;
             sm_status    = 0; 
             begin_equation = 0;
             sm_daq_channel_control = 0; 
             sm_channel_select = 0;               
             if (start) begin
                base_address = address;                
                next_state =  STATE_FETCH_WR_PTR;
                hold_data_wr = data_wr;         
                sm_daq_channel_control = daq_channel_control; 
                sm_channel_select = channel_select;                       
             end else begin
                next_state =  STATE_IDLE;                 
             end          
          end   
          STATE_FETCH_WR_PTR: begin
             sm_address = base_address + `VECTOR_WRITE_POINTER_OFFSET;
             sm_selection = 4'hF;
             sm_write = 0;
             sm_start = 1;                
             next_state =  STATE_FETCH_WR_PTR_DONE;     
          end
          
          STATE_FETCH_WR_PTR_DONE: begin
             sm_start = 0;             
             if (active) begin                               
                next_state =  STATE_FETCH_WR_PTR_DONE;
             end else begin       
                wr_ptr = data_rd;                
                next_state = STATE_FETCH_STATUS;                
             end             
          end   

          STATE_FETCH_STATUS: begin
             sm_address = base_address + `VECTOR_STATUS_OFFSET;
             sm_selection = 4'hF;
             sm_write = 0;
             sm_start = 1;
             next_state = STATE_FETCH_STATUS_DONE;             
          end

          STATE_FETCH_STATUS_DONE: begin
             sm_start = 0;             
             if (active) begin                               
                next_state =  STATE_FETCH_STATUS_DONE;
             end else begin       
                sm_status = data_rd;                
                next_state = STATE_FETCH_START_PTR;                
             end             
          end 
          
          STATE_FETCH_START_PTR: begin
             sm_address = base_address + `VECTOR_START_ADDRESS_OFFSET;
             sm_selection = 4'hF;
             sm_write = 0;
             sm_start = 1;
             next_state = STATE_FETCH_START_PTR_DONE;             
          end

          STATE_FETCH_START_PTR_DONE: begin
             sm_start = 0;             
             if (active) begin                               
                next_state =  STATE_FETCH_START_PTR_DONE;
             end else begin       
                start_ptr = data_rd;                
                next_state = STATE_FETCH_END_PTR;                
             end             
          end   

          STATE_FETCH_END_PTR: begin
             sm_address = base_address + `VECTOR_END_ADDRESS_OFFSET;
             sm_selection = 4'hF;
             sm_write = 0;
             sm_start = 1;
             next_state = STATE_FETCH_END_PTR_DONE;             
          end          
          
          STATE_FETCH_END_PTR_DONE: begin
             sm_start = 0;     
             if (active) begin
                next_state = STATE_FETCH_END_PTR_DONE;                
             end else begin
                end_ptr = data_rd;                
                next_state = STATE_WRITE_DATA;                
             end
          end

          STATE_WRITE_DATA:begin
             sm_address = wr_ptr;
             sm_data_wr = data_wr;             
             sm_selection = 4'hF;
             sm_write = 1;
             sm_start = 1;
             next_state = STATE_WRITE_DATA_DONE;
          end

          STATE_WRITE_DATA_DONE: begin
             sm_start = 0;     
             if (active) begin
                next_state = STATE_WRITE_DATA_DONE;                
             end else begin
                next_state = STATE_UPDATE_WR_PTR;
                wr_ptr = wr_ptr + 4; 
                data_done = 1;  
                sm_status[31:16] = sm_status[31:16] + 1;              
             end
          end

          STATE_UPDATE_WR_PTR: begin
             data_done = 0; 
            
             if (wr_ptr > end_ptr) begin
                wr_ptr = start_ptr;                
             end
             if (! fifo_empty) begin
                next_state = STATE_WRITE_DATA;                
             end else begin
                next_state = STATE_WRITE_WR_PTR;
             end
          end

          STATE_WRITE_WR_PTR:begin
             sm_address = base_address + `VECTOR_WRITE_POINTER_OFFSET;
             sm_data_wr = wr_ptr;             
             sm_selection = 4'hF;
             sm_write = 1;
             sm_start = 1;
             next_state = STATE_WRITE_WR_PTR_DONE;             
          end

          STATE_WRITE_WR_PTR_DONE: begin
             sm_start = 0;     
             if (active) begin
                next_state = STATE_WRITE_WR_PTR_DONE;                
             end else begin
                next_state = STATE_WRITE_STATUS;
                if (sm_status[31:16] >= sm_daq_channel_control[31:16]) begin
                   begin_equation = 1;
                   sm_status [31:16] = 0;
                   begin_equation[0] = (sm_channel_select == 2'b00);
                   begin_equation[1] = (sm_channel_select == 2'b01);
                   begin_equation[2] = (sm_channel_select == 2'b10);
                   begin_equation[3] = (sm_channel_select == 2'b11);                   
                end                
             end
          end

          STATE_WRITE_STATUS:begin
             sm_address = base_address + `VECTOR_STATUS_OFFSET;
             sm_data_wr = sm_status;             
             sm_selection = 4'hF;
             sm_write = 1;
             sm_start = 1;
             next_state = STATE_WRITE_STATUS_DONE;             
          end

          STATE_WRITE_STATUS_DONE: begin
             sm_start = 0;     
             if (active) begin
                next_state = STATE_WRITE_STATUS_DONE;                
             end else begin
                next_state = STATE_IDLE;                  
             end
          end
          
          default: begin
             next_state = STATE_IDLE;             
          end
        endcase // case (state)        
     end

`ifdef SIM
   reg [32*8-1:0] state_name;
   always @(*)
     case (state)
       STATE_IDLE: state_name                  = "IDLE";
       STATE_FETCH_WR_PTR: state_name          = "FETCH WR PTR";
       STATE_FETCH_WR_PTR_DONE: state_name     = "FETCH WR PTR DONE";
       STATE_FETCH_STATUS: state_name          = "FETCH STATUS";
       STATE_FETCH_STATUS_DONE: state_name     = "FETCH STATUS DONE";       
       STATE_FETCH_START_PTR:state_name        = "FETCH START PTR";
       STATE_FETCH_START_PTR_DONE:state_name   = "FETCH START PTR DONE";
       STATE_FETCH_END_PTR:state_name          = "FETCH END PTR";
       STATE_FETCH_END_PTR_DONE:state_name     = "FETCH END PTR DONE";
       STATE_UPDATE_WR_PTR:state_name          = "UPDATE WR PTR";       
       STATE_WRITE_DATA:state_name             = "WRITE DATA";       
       STATE_WRITE_DATA_DONE:state_name        = "WRITE DATA DONE";
       STATE_WRITE_WR_PTR:state_name           = "WRITE WR PTR";       
       STATE_WRITE_WR_PTR_DONE:state_name      = "WRITE WR PTR DONE";
       STATE_WRITE_STATUS:state_name           = "WRITE STATUS";       
       STATE_WRITE_STATUS_DONE:state_name      = "WRITE STATUS DONE";
       default: state_name                     = "DEFAULT";
     endcase // case (state)
   
`endif
   
endmodule // wb_daq_bus_master
