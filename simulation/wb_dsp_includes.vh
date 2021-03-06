//                              -*- Mode: Verilog -*-
// Filename        : wb_dsp_includes.vh
// Description     : Include file for WB DSP Testing
// Author          : Philip Tracton
// Created On      : Wed Dec  2 13:38:15 2015
// Last Modified By: Philip Tracton
// Last Modified On: Wed Dec  2 13:38:15 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!


`include "../rtl/wb_daq_slave_registers_include.vh"
`include "../rtl/wb_dsp_slave_registers_include.vh"

`define TB          testbench
`define WB_RST      `TB.wb_rst
`define WB_CLK      `TB.wb_clk
`define DSP         `TB.dsp
`define DAQ         `TB.daq
`define RAM         `TB.wb_ram0
`define RAM0        `RAM.ram0
`define MEMORY      `RAM0.mem

`define TEST_CASE       `TB.test_case
`define SIMULATION_NAME `TEST_CASE.simulation_name
//`define RAM_IMAGE       `TEST_CASE.ram_image  
`define NUMBER_OF_TESTS `TEST_CASE.number_of_tests

`define WB_DSP_RAM_BASE_ADDRESS     32'h9100_0000

`define WB_DSP_BASE_ADDRESS         32'h9000_0000
`define WB_DSP_EQUATION0_ADDRESS_REG `WB_DSP_BASE_ADDRESS + 8'h00
`define WB_DSP_EQUATION1_ADDRESS_REG `WB_DSP_BASE_ADDRESS + 8'h04
`define WB_DSP_EQUATION2_ADDRESS_REG `WB_DSP_BASE_ADDRESS + 8'h08
`define WB_DSP_EQUATION3_ADDRESS_REG `WB_DSP_BASE_ADDRESS + 8'h0C
`define WB_DSP_CONTROL_REG           `WB_DSP_BASE_ADDRESS + 8'h10
`define WB_DSP_STATUS_REG            `WB_DSP_BASE_ADDRESS + 8'h14

`define WB_DAQ_BASE_ADDRESS        32'h9010_0000
`define WB_DAQ_CONTROL_REG          `WB_DAQ_BASE_ADDRESS + `DAQ_CONTROL_REG_OFFSET
`define WB_DAQ_CHANNEL0_ADDRESS_REG `WB_DAQ_BASE_ADDRESS + `DAQ_CHANNEL0_ADDRESS_OFFSET
`define WB_DAQ_CHANNEL1_ADDRESS_REG `WB_DAQ_BASE_ADDRESS + `DAQ_CHANNEL1_ADDRESS_OFFSET
`define WB_DAQ_CHANNEL2_ADDRESS_REG `WB_DAQ_BASE_ADDRESS + `DAQ_CHANNEL2_ADDRESS_OFFSET
`define WB_DAQ_CHANNEL3_ADDRESS_REG `WB_DAQ_BASE_ADDRESS + `DAQ_CHANNEL3_ADDRESS_OFFSET

`define WB_DAQ_CHANNEL0_CONTROL_REG `WB_DAQ_BASE_ADDRESS + `DAQ_CHANNEL0_CONTROL_OFFSET
`define WB_DAQ_CHANNEL1_CONTROL_REG `WB_DAQ_BASE_ADDRESS + `DAQ_CHANNEL1_CONTROL_OFFSET
`define WB_DAQ_CHANNEL2_CONTROL_REG `WB_DAQ_BASE_ADDRESS + `DAQ_CHANNEL2_CONTROL_OFFSET
`define WB_DAQ_CHANNEL3_CONTROL_REG `WB_DAQ_BASE_ADDRESS + `DAQ_CHANNEL3_CONTROL_OFFSET

`define WB_DAQ_CHANNEL0_STATUS_REG `WB_DAQ_BASE_ADDRESS + `DAQ_CHANNEL0_STATUS_OFFSET
`define WB_DAQ_CHANNEL1_STATUS_REG `WB_DAQ_BASE_ADDRESS + `DAQ_CHANNEL1_STATUS_OFFSET
`define WB_DAQ_CHANNEL2_STATUS_REG `WB_DAQ_BASE_ADDRESS + `DAQ_CHANNEL2_STATUS_OFFSET
`define WB_DAQ_CHANNEL3_STATUS_REG `WB_DAQ_BASE_ADDRESS + `DAQ_CHANNEL3_STATUS_OFFSET


`define TEST_TASKS  `TB.test_tasks
`define TEST_PASSED `TEST_TASKS.test_passed
`define TEST_FAILED `TEST_TASKS.test_failed
`define TEST_COMPARE  `TEST_TASKS.compare_values
`define TEST_COMPLETE `TEST_TASKS.all_tests_completed
