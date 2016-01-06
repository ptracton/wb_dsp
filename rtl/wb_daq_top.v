//                              -*- Mode: Verilog -*-
// Filename        : wb_daq_top.v
// Description     : WB Data Acquisition Top
// Author          : Philip Tracton
// Created On      : Tue Dec 15 20:50:40 2015
// Last Modified By: Philip Tracton
// Last Modified On: Tue Dec 15 20:50:40 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!
module wb_daq_top (/*AUTOARG*/
   // Outputs
   wb_master_adr_o, wb_master_dat_o, wb_master_sel_o, wb_master_we_o,
   wb_master_cyc_o, wb_master_stb_o, wb_master_cti_o, wb_master_bte_o,
   wb_slave_dat_o, wb_slave_ack_o, wb_slave_err_o, wb_slave_rty_o,
   interrupt, adc0_clk_speed_select, adc1_clk_speed_select,
   adc2_clk_speed_select, adc3_clk_speed_select,
   // Inputs
   adc0_clk, adc1_clk, adc2_clk, adc3_clk, wb_clk, wb_rst,
   wb_master_dat_i, wb_master_ack_i, wb_master_err_i, wb_master_rty_i,
   wb_slave_adr_i, wb_slave_dat_i, wb_slave_sel_i, wb_slave_we_i,
   wb_slave_cyc_i, wb_slave_stb_i, wb_slave_cti_i, wb_slave_bte_i
   ) ;
   parameter master_dw = 32;
   parameter master_aw = 32;
   parameter slave_dw = 32;
   parameter slave_aw = 8;
   parameter channel0_adc_image = "";
   parameter channel1_adc_image = "";
   parameter channel2_adc_image = "";   
   parameter channel3_adc_image = "";
   
   //
   // Common Interface
   //
   input                  adc0_clk;
   input                  adc1_clk;
   input                  adc2_clk;
   input                  adc3_clk;   
   input                  wb_clk;
   input                  wb_rst;
   
   //
   // Master Interface
   //
   output wire [master_aw-1:0] wb_master_adr_o;
   output wire [master_dw-1:0] wb_master_dat_o;
   output wire [3:0]           wb_master_sel_o;
   output wire                 wb_master_we_o;
   output wire                 wb_master_cyc_o;
   output wire                 wb_master_stb_o;
   output wire [2:0]           wb_master_cti_o;
   output wire [1:0]           wb_master_bte_o;
   input [master_dw-1:0]       wb_master_dat_i;
   input                       wb_master_ack_i;
   input                       wb_master_err_i;
   input                       wb_master_rty_i;
      
   //
   // Slave Interface
   //
   input [slave_aw-1:0]        wb_slave_adr_i;
   input [slave_dw-1:0]        wb_slave_dat_i;
   input [3:0]                 wb_slave_sel_i;
   input                       wb_slave_we_i;
   input                       wb_slave_cyc_i;
   input                       wb_slave_stb_i;
   input [2:0]                 wb_slave_cti_i;
   input [1:0]                 wb_slave_bte_i;
   output wire [slave_dw-1:0]  wb_slave_dat_o;
   output wire                 wb_slave_ack_o;
   output wire                 wb_slave_err_o;
   output wire                 wb_slave_rty_o;

   output wire                 interrupt;
   
   output wire [2:0]           adc0_clk_speed_select;   
   output wire [2:0]           adc1_clk_speed_select;   
   output wire [2:0]           adc2_clk_speed_select;   
   output wire [2:0]           adc3_clk_speed_select;  
   
   wire [master_dw-1:0]        channel0_data_out;
   wire                        channel0_start_sram;

   wire [master_dw-1:0]        channel1_data_out;
   wire                        channel1_start_sram;

   wire [master_dw-1:0]        channel2_data_out;
   wire                        channel2_start_sram;
   
   wire [master_dw-1:0]        channel3_data_out;
   wire                        channel3_start_sram;

   wire [master_dw-1:0]                daq_control;
   wire [master_dw-1:0]                daq_channel0_address;
   wire [master_dw-1:0]                daq_channel1_address;
   wire [master_dw-1:0]                daq_channel2_address;
   wire [master_dw-1:0]                daq_channel3_address;

   wire [master_dw-1:0]                daq_channel0_control;
   wire [master_dw-1:0]                daq_channel1_control;
   wire [master_dw-1:0]                daq_channel2_control;
   wire [master_dw-1:0]                daq_channel3_control;

   
   wire [master_dw-1:0]                daq_channel0_status;
   wire [master_dw-1:0]                daq_channel1_status;
   wire [master_dw-1:0]                daq_channel2_status;
   wire [master_dw-1:0]                daq_channel3_status;
   
   wire [master_dw-1:0]                bus_master_address;

   wire [3:0] grant;
   wire       active;
   wire [1:0] select;
               
   assign adc0_clk_speed_select = daq_channel0_control[4:2];   
   assign adc1_clk_speed_select = daq_channel1_control[4:2];
   assign adc2_clk_speed_select = daq_channel2_control[4:2];   
   assign adc3_clk_speed_select = daq_channel3_control[4:2];


   wire [2:0] adc0_data_width =  daq_channel0_control[7:5];
   wire [2:0] adc1_data_width =  daq_channel1_control[7:5];
   wire [2:0] adc2_data_width =  daq_channel2_control[7:5];
   wire [2:0] adc3_data_width =  daq_channel3_control[7:5];

   wire [1:0] adc0_decimator_select = daq_channel0_control[9:8];
   wire [1:0] adc1_decimator_select = daq_channel1_control[9:8];
   wire [1:0] adc2_decimator_select = daq_channel2_control[9:8];
   wire [1:0] adc3_decimator_select = daq_channel3_control[9:8];
   
   wire [5:0] adc0_fifo_samples_count = daq_channel0_control[15:10];
   wire [5:0] adc1_fifo_samples_count = daq_channel1_control[15:10];
   wire [5:0] adc2_fifo_samples_count = daq_channel2_control[15:10];
   wire [5:0] adc3_fifo_samples_count = daq_channel3_control[15:10];
   
   assign bus_master_address = (select == 2'b00) ? daq_channel0_address:
                               (select == 2'b01) ? daq_channel1_address:
                               (select == 2'b10) ? daq_channel2_address:
                               (select == 2'b11) ? daq_channel3_address: 32'h0;
   wire [master_dw-1:0]                bus_master_data_wr;
   
   assign bus_master_data_wr = (select == 2'b00) ? channel0_data_out:
                               (select == 2'b01) ? channel1_data_out:
                               (select == 2'b10) ? channel2_data_out:
                               (select == 2'b11) ? channel3_data_out: 32'h0;
                               
   wire                                bus_master_fifo_empty;
   wire                                channel0_fifo_empty;
   wire                                channel1_fifo_empty;
   wire                                channel2_fifo_empty;
   wire                                channel3_fifo_empty;
   
   assign bus_master_fifo_empty = (select == 2'b00) ? channel0_fifo_empty:
                                  (select == 2'b01) ? channel1_fifo_empty:
                                  (select == 2'b10) ? channel2_fifo_empty:
                                  (select == 2'b11) ? channel3_fifo_empty: 1;

   wire                                bus_master_data_done;
   
   assign channel0_data_done = (select == 2'b00) ? bus_master_data_done: 0;
   assign channel1_data_done = (select == 2'b01) ? bus_master_data_done: 0;
   assign channel2_data_done = (select == 2'b10) ? bus_master_data_done: 0;
   assign channel3_data_done = (select == 2'b11) ? bus_master_data_done: 0;
   
   
   wb_daq_slave_registers #(.aw(slave_aw), .dw(slave_dw))
   slave_registers 
     (
      // Outputs
      .daq_control_reg                  (daq_control),
      .daq_channel0_address_reg         (daq_channel0_address), 
      .daq_channel1_address_reg         (daq_channel1_address),
      .daq_channel2_address_reg         (daq_channel2_address), 
      .daq_channel3_address_reg         (daq_channel3_address),
      .daq_channel0_control_reg         (daq_channel0_control), 
      .daq_channel1_control_reg         (daq_channel1_control),
      .daq_channel2_control_reg         (daq_channel2_control), 
      .daq_channel3_control_reg         (daq_channel3_control),  
      .interrupt                        (interrupt),
      .wb_dat_o                         (wb_slave_dat_o[slave_dw-1:0]),
      .wb_ack_o                         (wb_slave_ack_o),
      .wb_err_o                         (wb_slave_err_o),
      .wb_rty_o                         (wb_slave_rty_o),

      // Inputs
      .wb_clk                           (wb_clk),
      .wb_rst                           (wb_rst),
      .wb_adr_i                         (wb_slave_adr_i[slave_aw-1:0]),
      .wb_dat_i                         (wb_slave_dat_i[slave_dw-1:0]),
      .wb_sel_i                         (wb_slave_sel_i[3:0]),
      .wb_we_i                          (wb_slave_we_i),
      .wb_cyc_i                         (wb_slave_cyc_i),
      .wb_stb_i                         (wb_slave_stb_i),
      .wb_cti_i                         (wb_slave_cti_i[2:0]),
      .wb_bte_i                         (wb_slave_bte_i[1:0]),
      .daq_channel0_status_reg          (32'b0),
      .daq_channel1_status_reg          (32'b0),
      .daq_channel2_status_reg          (32'b0),      
      .daq_channel3_status_reg          (32'b0)
      );
   
   wb_daq_bus_master #(.aw(master_aw), .dw(master_dw))
   bus_master(
              // Outputs
              .wb_adr_o             (wb_master_adr_o[master_aw-1:0]),
              .wb_dat_o             (wb_master_dat_o[master_dw-1:0]),
              .wb_sel_o             (wb_master_sel_o[3:0]),
              .wb_we_o              (wb_master_we_o),
              .wb_cyc_o             (wb_master_cyc_o),
              .wb_stb_o             (wb_master_stb_o),
              .wb_cti_o             (wb_master_cti_o[2:0]),
              .wb_bte_o             (wb_master_bte_o[1:0]),
              .data_done            (bus_master_data_done),
              
              // Inputs
              .wb_clk               (wb_clk),
              .wb_rst               (wb_rst),              
              .wb_dat_i             (wb_master_dat_i[master_dw-1:0]),
              .wb_ack_i             (wb_master_ack_i),
              .wb_err_i             (wb_master_err_i),
              .wb_rty_i             (wb_master_rty_i),

              .fifo_empty           (bus_master_fifo_empty),
              .control_reg          (daq_control), 
              .start                (active), 
              .address              (bus_master_address), 
              .selection            (4'hF), 
              .write                (1'b1), 
              .data_wr              (bus_master_data_wr)
              );

   wb_daq_channel #(.dw(32), .adc_dw(8),
                    .adc_image(channel0_adc_image))
   channel0(
            // Outputs
            .data_out(channel0_data_out), 
            .start_sram(channel0_start_sram),
            .fifo_empty(channel0_fifo_empty),
            
            // Inputs
            .wb_clk(wb_clk), 
            .wb_rst(wb_rst),
            .fifo_number_samples_terminal(adc0_fifo_samples_count),
            .data_done(channel0_data_done),
            .grant(grant[0]),
            .adc_clk(adc0_clk),
            .control(daq_channel0_control),
            .status(daq_channel0_status),
            .master_enable(daq_control[0])
            );


   wb_daq_channel #(.dw(32), .adc_dw(8),
                    .adc_image(channel1_adc_image))
   channel1(
            // Outputs
            .data_out(channel1_data_out), 
            .start_sram(channel1_start_sram),
            .fifo_empty(channel1_fifo_empty),
            
            // Inputs
            .wb_clk(wb_clk), 
            .wb_rst(wb_rst),
            .fifo_number_samples_terminal(adc1_fifo_samples_count),
            .data_done(channel1_data_done),
            .grant(grant[1]),
            .adc_clk(adc1_clk),
            .control(daq_channel1_control),
            .status(daq_channel1_status),
            .master_enable(daq_control[0])
            );

   wb_daq_channel #(.dw(32), .adc_dw(8),
                    .adc_image(channel2_adc_image))
   channel2(
            // Outputs
            .data_out(channel2_data_out), 
            .start_sram(channel2_start_sram),
            .fifo_empty(channel2_fifo_empty),
            
            // Inputs
            .wb_clk(wb_clk), 
            .wb_rst(wb_rst),
            .fifo_number_samples_terminal(adc2_fifo_samples_count),
            .data_done(channel2_data_done),
            .grant(grant[2]), 
            .adc_clk(adc2_clk),
            .control(daq_channel2_control),
            .status(daq_channel2_status),
            .master_enable(daq_control[0])
            );

   wb_daq_channel #(.dw(32), .adc_dw(8),
                    .adc_image(channel3_adc_image))
   channel3(
            // Outputs
            .data_out(channel3_data_out), 
            .start_sram(channel3_start_sram),
            .fifo_empty(channel3_fifo_empty),
            
            // Inputs
            .wb_clk(wb_clk), 
            .wb_rst(wb_rst),
            .fifo_number_samples_terminal(adc3_fifo_samples_count),
            .data_done(channel3_data_done),
            .grant(grant[3]),
            .adc_clk(adc3_clk),
            .control(daq_channel3_control),
            .status(daq_channel3_status),
            .master_enable(daq_control[0])
            );   

   wire [3:0] request = {channel3_start_sram,
                         channel2_start_sram,
                         channel1_start_sram,
                         channel0_start_sram};
   arbiter
  #(.NUM_PORTS(4))
   channel_arbiter
     (.clk(wb_clk),
      .rst(wb_rst),
      .request(request),
      .grant(grant),
      .select(select),
      .active(active)
      );

   
endmodule // wb_daq_top
