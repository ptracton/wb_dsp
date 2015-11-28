//                              -*- Mode: Verilog -*-
// Filename        : testing_wb_master.v
// Description     : Testing a Wishbone Bus Master
// Author          : Philip Tracton
// Created On      : Fri Nov 27 16:22:45 2015
// Last Modified By: Philip Tracton
// Last Modified On: Fri Nov 27 16:22:45 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!
module testing_wb_master (/*AUTOARG*/
   // Outputs
   wb_adr_o, wb_dat_o, wb_sel_o, wb_we_o, wb_cyc_o, wb_stb_o,
   wb_cti_o, wb_bte_o, data_rd, active,
   // Inputs
   wb_clk, wb_rst, wb_dat_i, wb_ack_i, wb_err_i, wb_rty_i, start,
   address, selection, write, data_wr
   ) ;

   parameter dw = 32;
   parameter aw = 32;
   parameter DEBUG = 0;

   input 		wb_clk;
   input 		wb_rst;
   output reg [aw-1:0] wb_adr_o;
   output reg [dw-1:0] wb_dat_o;
   output reg [3:0]    wb_sel_o;
   output reg          wb_we_o;
   output reg          wb_cyc_o;
   output reg          wb_stb_o;
   output reg [2:0]    wb_cti_o;
   output reg [1:0]    wb_bte_o;
   input [dw-1:0]      wb_dat_i;
   input               wb_ack_i;
   input               wb_err_i;
   input               wb_rty_i;

   input               start;
   input [aw-1:0]      address;
   input [3:0]         selection;
   input               write;   
   input [dw-1:0]      data_wr;
   output reg [dw-1:0] data_rd;
   output reg          active;
   
   
   reg [2:0]           state;
   reg [2:0]           next_state;
   parameter STATE_IDLE         = 3'h0;
   parameter STATE_FIRST_CLOCK  = 3'h1;
   parameter STATE_SECOND_CLOCK = 3'h2;
   parameter STATE_THIRD_CLOCK  = 3'h3;
   parameter STATE_ERROR        = 3'h4;


   reg [aw-1:0]        adr_o;
   reg [dw-1:0]        dat_o;
   reg [3:0]           sel_o;
   reg                 we_o;
   reg                 cyc_o;
   reg                 stb_o;
   reg [2:0]           cti_o;
   reg [1:0]           bte_o;

   
   always @(posedge wb_clk)
     if (wb_rst) begin
        state <= STATE_IDLE;
        wb_adr_o <= 0;
        wb_dat_o <= 0;
        wb_sel_o <= 0;
        wb_we_o  <= 0;
        wb_cyc_o <= 0;
        wb_stb_o <= 0;
        wb_cti_o <= 0;
        wb_bte_o <= 0;        
     end else begin
        state <= next_state;
        wb_adr_o <= adr_o;
        wb_dat_o <= dat_o;
        wb_sel_o <= sel_o;
        wb_we_o  <= we_o;
        wb_cyc_o <= cyc_o;
        wb_stb_o <= stb_o;
        wb_cti_o <= cti_o;
        wb_bte_o <= bte_o;                
     end

   always @(*)
     if (wb_rst) begin
        next_state = STATE_IDLE;
        adr_o = 0;
        dat_o = 0;
        sel_o = 0;
        we_o  = 0;
        cyc_o = 0;
        stb_o = 0;
        cti_o = 0;
        bte_o = 0;
        active = 0;        
     end else begin // if (wb_rst)
        case (state)
          STATE_IDLE: begin
             adr_o = 0;
             dat_o = 0;
             sel_o = 0;
             we_o  = 0;
             cyc_o = 0;
             stb_o = 0;
             cti_o = 0;
             bte_o = 0;
             active = 0;             
             if (start) begin
                next_state = STATE_FIRST_CLOCK;
                adr_o = address;
                we_o = write;
                dat_o = data_wr;
                cyc_o = 1;
                stb_o = 1;
                active = 1;                
             end else begin
                next_state = STATE_IDLE;                
             end
          end // case: STATE_IDLE
          STATE_FIRST_CLOCK: begin
             if (wb_ack_i) begin
                next_state = STATE_SECOND_CLOCK;
             end else begin
                next_state = STATE_FIRST_CLOCK;
             end
          end
          STATE_SECOND_CLOCK: begin
             next_state = STATE_IDLE;                
          end
          STATE_THIRD_CLOCK:begin
             next_state = STATE_IDLE;                
          end
          default: begin
             next_state = STATE_IDLE;             
          end
          
        endcase // case (state)
        
     end
   
   

   
endmodule // testing_wb_master
