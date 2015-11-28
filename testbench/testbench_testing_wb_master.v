//                              -*- Mode: Verilog -*-
// Filename        : testbench_testing_wb_slave.v
// Description     : Testbench for testing Wishbone Master module
// Author          : Philip Tracton
// Created On      : Fri Nov 27 13:49:59 2015
// Last Modified By: Philip Tracton
// Last Modified On: Fri Nov 27 13:49:59 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!

`include "timescale.v"

module testbench_testing_wb_master (/*AUTOARG*/ ) ;
`include "test_management.v"

   wire wb_clk;
   wire wb_rst;
      
   syscon system_controller(
                            // Outputs
                            .wb_clk_o(wb_clk), 
                            .wb_rst_o(wb_rst),
                            // Inputs
                            .clk_pad_i(clk), 
                            .rst_pad_i(reset)
                            ) ;

`include "wb_switch1.vh"

   reg  start;
   reg [31:0] address;
   reg [3:0]    selection;
   reg          write;   
   reg [31:0] data_wr;
   wire [31:0] data_rd;
   wire          active;

   
   testing_wb_master master0(
                             .wb_clk(wb_clk),
                             .wb_rst(wb_rst),
                             .wb_adr_o(wb_m2s_master0_adr),
                             .wb_dat_o(wb_m2s_master0_dat),
                             .wb_sel_o(wb_m2s_master0_sel),
                             .wb_we_o(wb_m2s_master0_we),
                             .wb_cyc_o(wb_m2s_master0_cyc),
                             .wb_stb_o(wb_m2s_master0_stb),
                             .wb_cti_o(wb_m2s_master0_cti),
                             .wb_bte_o(wb_m2s_master0_bte),
                             .wb_dat_i(wb_s2m_master0_dat),
                             .wb_ack_i(wb_s2m_master0_ack),
                             .wb_err_i(wb_s2m_master0_err),
                             .wb_rty_i(wb_s2m_master0_rty),

                             .start(start),
                             .address(address),
                             .selection(selection),
                             .write(write),
                             .data_wr(data_wr),
                             .data_rd(data_rd),
                             .active(active)
                             );
   
   
   testing_wb_slave slave0 (/*AUTOARG*/
                        // Outputs
                        .wb_dat_o(wb_s2m_wb_slave0_dat), 
                        .wb_ack_o(wb_s2m_wb_slave0_ack), 
                        .wb_err_o(wb_s2m_wb_slave0_err), 
                        .wb_rty_o(wb_s2m_wb_slave0_rty),
                        // Inputs
                        .wb_clk(wb_clk), 
                        .wb_rst(wb_rst), 
                        .wb_adr_i(wb_m2s_wb_slave0_adr), 
                        .wb_dat_i(wb_m2s_wb_slave0_dat), 
                        .wb_sel_i(wb_m2s_wb_slave0_sel), 
                        .wb_we_i(wb_m2s_wb_slave0_we), 
                        .wb_cyc_i(wb_m2s_wb_slave0_cyc),
                        .wb_stb_i(wb_m2s_wb_slave0_stb), 
                        .wb_cti_i(wb_m2s_wb_slave0_cti),
                        .wb_bte_i(wb_m2s_wb_slave0_bte)
                        ) ;
   
   
   testing_wb_slave slave1 (/*AUTOARG*/
                        // Outputs
                        .wb_dat_o(wb_s2m_wb_slave1_dat), 
                        .wb_ack_o(wb_s2m_wb_slave1_ack), 
                        .wb_err_o(wb_s2m_wb_slave1_err), 
                        .wb_rty_o(wb_s2m_wb_slave1_rty),
                        // Inputs
                        .wb_clk(wb_clk), 
                        .wb_rst(wb_rst), 
                        .wb_adr_i(wb_m2s_wb_slave1_adr), 
                        .wb_dat_i(wb_m2s_wb_slave1_dat), 
                        .wb_sel_i(wb_m2s_wb_slave1_sel), 
                        .wb_we_i(wb_m2s_wb_slave1_we), 
                        .wb_cyc_i(wb_m2s_wb_slave1_cyc),
                        .wb_stb_i(wb_m2s_wb_slave1_stb), 
                        .wb_cti_i(wb_m2s_wb_slave1_cti),
                        .wb_bte_i(wb_m2s_wb_slave1_bte)
                        ) ;   
   reg  err;
   reg [31:0] data_out;

   //
   // Thread for controlling bus master
   //
   initial begin
      start     <= 0;
      address   <= 0;
      selection <= 0;
      write     <= 0;   
      data_wr   <= 0;
      @(negedge wb_rst);
      #15;
      master_write(32'h9000_0000, 32'hdead_beef, 4'hf);
      repeat(2) @(posedge wb_clk);
      
      master_read(32'h9000_0000, data_out, 4'hf);
//      repeat(2) @(posedge wb_clk);
      
   end
   
   initial begin
      #100 $display("Simulation Running");
      
      #1000 $finish;
      
   end

   task master_read;
      input [31:0] taddress;
      output [31:0] tdata;
      input [3:0]  tselection;
      begin
         write     <= 0;         
         start     <= 0;
         address   <= 0;
         selection <= 0;
         write     <= 0;   
         data_wr   <= 0;
         @(posedge wb_clk);
         start     <= 1;
         write     <= 0;
         address   <= taddress;
         selection <= tselection;
         
         @(posedge clk);
         tdata     <= data_rd;         
         write     <= 0;         
         start     <= 0;
         address   <= 0;
         selection <= 0;
         write     <= 0;   
         data_wr   <= 0;         
      end
   endtask 
   
   task master_write;
      input [31:0] taddress;
      input [31:0] tdata;
      input [3:0]  tselection;
      begin
         write     <= 0;         
         start     <= 0;
         address   <= 0;
         selection <= 0;
         write     <= 0;   
         data_wr   <= 0;
         @(posedge wb_clk);
         start     <= 1;
         write     <= 1;
         address   <= taddress;
         data_wr   <= tdata;
         selection <= tselection;
         
         @(posedge clk);
         write     <= 0;         
         start     <= 0;
         address   <= 0;
         selection <= 0;
         write     <= 0;   
         data_wr   <= 0;         
      end
   endtask 
   
     
endmodule // testbench_testing_wb_slave
