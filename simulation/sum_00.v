//                              -*- Mode: Verilog -*-
// Filename        : simple_daq_master_00.v
// Description     : Simple DAQ Master Test
// Author          : Philip Tracton
// Created On      : Wed Dec 16 21:44:30 2015
// Last Modified By: Philip Tracton
// Last Modified On: Wed Dec 16 21:44:30 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!


`include "wb_dsp_includes.vh"


module test_case (/*AUTOARG*/ ) ;

   //
   // Test Configuration
   // These parameters need to be set for each test case
   //
   parameter simulation_name = "sum_00";
   parameter ram_image = "sum_00.mem";
   parameter channel0_adc_image = "sum_00_adc.mem";
   parameter channel1_adc_image = "sum_00_adc.mem";
   parameter channel2_adc_image = "sum_00_adc.mem";
   parameter channel3_adc_image = "sum_00_adc.mem";
   
   parameter number_of_tests = 80;

   reg  err;
   reg [31:0] data_out;
   integer    i;

   initial begin
      $display("SUM 00 Test Case");
      `TB.master_bfm.reset;      
      @(posedge `WB_RST);
      @(negedge `WB_RST);
      @(posedge `WB_CLK);
      
      //
      // Seq Address for equation 0
      //
      `TB.master_bfm.write(`WB_DSP_EQUATION0_ADDRESS_REG, `WB_DSP_RAM_BASE_ADDRESS+1024, 4'hF, err);

      //
      // Start running the equation
      //
      `TB.master_bfm.write(`WB_DSP_CONTROL_REG, 32'h0000_0021, 4'hF, err);
      
      #500000;
      `TEST_COMPLETE;    
   end
   
   
endmodule // test_case
