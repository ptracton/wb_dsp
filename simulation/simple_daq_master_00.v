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
   parameter simulation_name = "simple_daq_master_00";
   parameter ram_image = "simple_daq_master_00.mem";
   parameter channel0_adc_image = "simple_daq_master_00_adc.mem";
   parameter channel1_adc_image = "simple_daq_master_00_adc.mem";
   parameter channel2_adc_image = "simple_daq_master_00_adc.mem";
   parameter channel3_adc_image = "simple_daq_master_00_adc.mem";
   
   parameter number_of_tests = 80;

   reg  err;
   reg [31:0] data_out;
   integer    i;

   initial begin
      $display("Simple DAQ Master 00 Test Case");
      `TB.master_bfm.reset;      
      @(posedge `WB_RST);
      @(negedge `WB_RST);
      @(posedge `WB_CLK);
      
      //
      // Set Channel 0 Address register to 0x100, this is location of
      // vector structure
      //
      `TB.master_bfm.write(`WB_DAQ_CHANNEL0_ADDRESS_REG, `WB_DSP_RAM_BASE_ADDRESS+1024, 4'hF, err);
      `TB.master_bfm.write(`WB_DAQ_CHANNEL1_ADDRESS_REG, `WB_DSP_RAM_BASE_ADDRESS+512, 4'hF, err);

      //
      // Turn on Channels 0 and 1
      //
      `TB.master_bfm.write(`WB_DAQ_CHANNEL0_CONTROL_REG, 32'h000A_101D, 4'hF, err);
      `TB.master_bfm.write(`WB_DAQ_CHANNEL1_CONTROL_REG, 32'h0010_2015, 4'hF, err);
      
      //
      // Enable Data Flow
      //
      `TB.master_bfm.write(`WB_DAQ_CONTROL_REG, 32'h0000_0001, 4'hF, err);

      //
      // Check Data in SRAM
      //
      @(negedge `DAQ.select[0]);
      `TEST_COMPARE("MEM[384]", `MEMORY[384], 32'h030201ff);
      `TEST_COMPARE("MEM[385]", `MEMORY[385], 32'h07060504);
      `TEST_COMPARE("MEM[386]", `MEMORY[386], 32'h0b0a0908);
      `TEST_COMPARE("MEM[387]", `MEMORY[387], 32'h0f0e0d0c);
      `TEST_COMPARE("MEM[388]", `MEMORY[388], 32'h13121110);
      `TEST_COMPARE("MEM[389]", `MEMORY[389], 32'h17161514);
      `TEST_COMPARE("MEM[390]", `MEMORY[390], 32'h1b1a1918);
      `TEST_COMPARE("MEM[391]", `MEMORY[391], 32'h1f1e1d1c);
      
      @(negedge `DAQ.select[0]);
      `TEST_COMPARE("MEM[392]", `MEMORY[392], 32'h23222120);
      `TEST_COMPARE("MEM[393]", `MEMORY[393], 32'h27262524);
      `TEST_COMPARE("MEM[394]", `MEMORY[394], 32'h2b2a2928);
      `TEST_COMPARE("MEM[395]", `MEMORY[395], 32'h2f2e2d2c);
      `TEST_COMPARE("MEM[396]", `MEMORY[396], 32'h33323130);
      `TEST_COMPARE("MEM[397]", `MEMORY[397], 32'h37363534);
      `TEST_COMPARE("MEM[398]", `MEMORY[398], 32'h3b3a3938);
      `TEST_COMPARE("MEM[399]", `MEMORY[399], 32'h3f3e3d3c); 
      
      @(negedge `DAQ.select[0]);
      `TEST_COMPARE("MEM[400]", `MEMORY[400], 32'h030201ff);
      `TEST_COMPARE("MEM[401]", `MEMORY[401], 32'h07060504);
      `TEST_COMPARE("MEM[402]", `MEMORY[402], 32'h0b0a0908);
      `TEST_COMPARE("MEM[403]", `MEMORY[403], 32'h0f0e0d0c);
      `TEST_COMPARE("MEM[404]", `MEMORY[404], 32'h13121110);
      `TEST_COMPARE("MEM[405]", `MEMORY[405], 32'h17161514);
      `TEST_COMPARE("MEM[406]", `MEMORY[406], 32'h1b1a1918);
      `TEST_COMPARE("MEM[407]", `MEMORY[407], 32'h1f1e1d1c);     

      `TEST_COMPARE("MEM[514]", `MEMORY[514], 32'h030201ff);
      `TEST_COMPARE("MEM[515]", `MEMORY[515], 32'h07060504);
      `TEST_COMPARE("MEM[516]", `MEMORY[516], 32'h0b0a0908);
      `TEST_COMPARE("MEM[517]", `MEMORY[517], 32'h0f0e0d0c);
      
      @(negedge `DAQ.select[0]);
      `TEST_COMPARE("MEM[408]", `MEMORY[408], 32'h23222120);
      `TEST_COMPARE("MEM[409]", `MEMORY[409], 32'h27262524);
      `TEST_COMPARE("MEM[410]", `MEMORY[410], 32'h2b2a2928);
      `TEST_COMPARE("MEM[411]", `MEMORY[411], 32'h2f2e2d2c);
      `TEST_COMPARE("MEM[412]", `MEMORY[412], 32'h33323130);
      `TEST_COMPARE("MEM[413]", `MEMORY[413], 32'h37363534);
      `TEST_COMPARE("MEM[414]", `MEMORY[414], 32'h3b3a3938);
      `TEST_COMPARE("MEM[415]", `MEMORY[415], 32'h3f3e3d3c);     

      @(negedge `DAQ.select[0]);
      `TEST_COMPARE("MEM[416]", `MEMORY[416], 32'h030201ff);
      `TEST_COMPARE("MEM[417]", `MEMORY[417], 32'h07060504);
      `TEST_COMPARE("MEM[418]", `MEMORY[418], 32'h0b0a0908);
      `TEST_COMPARE("MEM[419]", `MEMORY[419], 32'h0f0e0d0c);
      `TEST_COMPARE("MEM[420]", `MEMORY[420], 32'h13121110);
      `TEST_COMPARE("MEM[421]", `MEMORY[421], 32'h17161514);
      `TEST_COMPARE("MEM[422]", `MEMORY[422], 32'h1b1a1918);
      `TEST_COMPARE("MEM[423]", `MEMORY[423], 32'h1f1e1d1c);      

      @(negedge `DAQ.select[0]);
      `TEST_COMPARE("MEM[424]", `MEMORY[424], 32'h23222120);
      `TEST_COMPARE("MEM[425]", `MEMORY[425], 32'h27262524);
      `TEST_COMPARE("MEM[426]", `MEMORY[426], 32'h2b2a2928);
      `TEST_COMPARE("MEM[427]", `MEMORY[427], 32'h2f2e2d2c);
      `TEST_COMPARE("MEM[428]", `MEMORY[428], 32'h33323130);
      `TEST_COMPARE("MEM[429]", `MEMORY[429], 32'h37363534);
      `TEST_COMPARE("MEM[430]", `MEMORY[430], 32'h3b3a3938);
      `TEST_COMPARE("MEM[431]", `MEMORY[431], 32'h3f3e3d3c); 

      `TEST_COMPARE("MEM[518]", `MEMORY[518], 32'h13121110);
      `TEST_COMPARE("MEM[519]", `MEMORY[519], 32'h17161514);
      `TEST_COMPARE("MEM[520]", `MEMORY[520], 32'h1b1a1918);
      `TEST_COMPARE("MEM[521]", `MEMORY[521], 32'h1f1e1d1c);
      
      @(negedge `DAQ.select[0]);
      `TEST_COMPARE("MEM[432]", `MEMORY[432], 32'h030201ff);
      `TEST_COMPARE("MEM[433]", `MEMORY[433], 32'h07060504);
      `TEST_COMPARE("MEM[434]", `MEMORY[434], 32'h0b0a0908);
      `TEST_COMPARE("MEM[435]", `MEMORY[435], 32'h0f0e0d0c);
      `TEST_COMPARE("MEM[436]", `MEMORY[436], 32'h13121110);
      `TEST_COMPARE("MEM[437]", `MEMORY[437], 32'h17161514);
      `TEST_COMPARE("MEM[438]", `MEMORY[438], 32'h1b1a1918);
      `TEST_COMPARE("MEM[439]", `MEMORY[439], 32'h1f1e1d1c);  

      @(negedge `DAQ.select[0]);
      `TEST_COMPARE("MEM[440]", `MEMORY[440], 32'h23222120);
      `TEST_COMPARE("MEM[441]", `MEMORY[441], 32'h27262524);
      `TEST_COMPARE("MEM[442]", `MEMORY[442], 32'h2b2a2928);
      `TEST_COMPARE("MEM[443]", `MEMORY[443], 32'h2f2e2d2c);
      `TEST_COMPARE("MEM[444]", `MEMORY[444], 32'h33323130);
      `TEST_COMPARE("MEM[445]", `MEMORY[445], 32'h37363534);
      `TEST_COMPARE("MEM[446]", `MEMORY[446], 32'h3b3a3938);
      `TEST_COMPARE("MEM[447]", `MEMORY[447], 32'h3f3e3d3c); 

      //
      // WRAP AROUND!
      //
      @(negedge `DAQ.select[0]);
      `TEST_COMPARE("MEM[448]", `MEMORY[448], 32'h030201ff);
      `TEST_COMPARE("MEM[384]", `MEMORY[384], 32'h07060504);
      `TEST_COMPARE("MEM[385]", `MEMORY[385], 32'h0b0a0908);
      `TEST_COMPARE("MEM[386]", `MEMORY[386], 32'h0f0e0d0c);
      `TEST_COMPARE("MEM[387]", `MEMORY[387], 32'h13121110);
      `TEST_COMPARE("MEM[388]", `MEMORY[388], 32'h17161514);
      `TEST_COMPARE("MEM[389]", `MEMORY[389], 32'h1b1a1918);
      `TEST_COMPARE("MEM[390]", `MEMORY[390], 32'h1f1e1d1c);
      
      #500000;
      `TEST_COMPLETE;    
   end
   
   
endmodule // test_case
