//                              -*- Mode: Verilog -*-
// Filename        : simple_slave_00.v
// Description     : Wishbone DSP Simple Slave interface testing
// Author          : Philip Tracton
// Created On      : Wed Dec  2 14:02:57 2015
// Last Modified By: Philip Tracton
// Last Modified On: Wed Dec  2 14:02:57 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!

`include "wb_dsp_includes.vh"

module test_case ();

   //
   // Test Configuration
   // These parameters need to be set for each test case
   //
   parameter simulation_name = "simple_slave_00";
   parameter ram_image = "simple_slave_00.mem";
   parameter channel0_adc_image = "simple_slave_00_adc.mem";
   
   parameter number_of_tests = 1028;

   reg  err;
   reg [31:0] data_out;
   integer    i;
   
   initial begin
      $display("Simple Slave Test Case");
      `TB.master_bfm.reset;      
      @(posedge `WB_RST);
      @(negedge `WB_RST);
      @(posedge `WB_CLK);

      `TB.master_bfm.write(`WB_DSP_EQUATION_ADDRESS_REG, 32'h1122_3344, 4'hF, err);
      `TB.master_bfm.write(`WB_DSP_CONTROL_REG, 32'h5566_7788, 4'hF, err);
      `TB.master_bfm.write(`WB_DAQ_SLAVE_REG, 32'h5566_7788, 4'hF, err);

      `TB.master_bfm.read_burst(`WB_DSP_EQUATION_ADDRESS_REG, data_out, 4'hF, 1, 0, err);
      `TEST_COMPARE("DSP Equation Read", 32'h1122_3344, data_out);

      @(posedge `WB_CLK);
      `TB.master_bfm.read_burst(`WB_DSP_CONTROL_REG, data_out, 4'hF, 1, 0, err);
      `TEST_COMPARE("DSP Control Read", 32'h5566_7788, data_out);

      @(posedge `WB_CLK);
      `TB.master_bfm.read_burst(`WB_DSP_STATUS_REG, data_out, 4'hF, 1, 0, err);
      `TEST_COMPARE("DSP Status Read", 32'h0, data_out);      

      @(posedge `WB_CLK);
      `TB.master_bfm.read_burst(`WB_DAQ_SLAVE_REG, data_out, 4'hF, 1, 0, err);
      `TEST_COMPARE("DAQ Slave Read", 32'h5566_7788, data_out); 

      repeat(10) @(posedge `WB_CLK);

      for (i=0; i<4096; i=i+4)begin
         `TB.master_bfm.write(`WB_DSP_RAM_BASE_ADDRESS + i, {i[7:0],i[7:0],i[7:0],i[7:0]}, 4'hF, err);
      end

      for (i=0; i<4096; i=i+4)begin
         `TB.master_bfm.read_burst(`WB_DSP_RAM_BASE_ADDRESS+i, data_out, 4'hF, 1, 0, err);
         `TEST_COMPARE("RAM0 Read", {i[7:0],i[7:0],i[7:0],i[7:0]}, data_out);
      end
      for (i=0; i<4096; i=i+4)begin
         `TB.master_bfm.write(`WB_DSP_RAM_BASE_ADDRESS + i, {24'h0,i[7:0]*4'd2}, 4'h1, err);
         `TB.master_bfm.write(`WB_DSP_RAM_BASE_ADDRESS + i, {16'h0,i[7:0]*4'd3,8'h00}, 4'h2, err);
         `TB.master_bfm.write(`WB_DSP_RAM_BASE_ADDRESS + i, {8'h0,i[7:0]*4'd4,16'h0}, 4'h4, err);
         `TB.master_bfm.write(`WB_DSP_RAM_BASE_ADDRESS + i, {i[7:0]*4'd5,24'h0}, 4'h8, err);
      end
         
      #1000;
      `TEST_COMPLETE;      
   end

endmodule // test_case
