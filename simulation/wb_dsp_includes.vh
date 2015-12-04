//                              -*- Mode: Verilog -*-
// Filename        : wb_dsp_includes.vh
// Description     : Include file for WB DSP Testing
// Author          : Philip Tracton
// Created On      : Wed Dec  2 13:38:15 2015
// Last Modified By: Philip Tracton
// Last Modified On: Wed Dec  2 13:38:15 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!

`define TB          testbench
`define WB_RST      `TB.wb_rst
`define WB_CLK      `TB.wb_clk
`define DUT         `TB.dut


`define TEST_CASE       test_case
`define SIMULATION_NAME `TEST_CASE.simulation_name
//`define RAM_IMAGE       `TEST_CASE.ram_image  
`define NUMBER_OF_TESTS `TEST_CASE.number_of_tests

`define WB_DSP_RAM_BASE_ADDRESS     32'h1000_0000

`define WB_DSP_BASE_ADDRESS         32'h5000_0000
`define WB_DSP_EQUATION_ADDRESS_REG `WB_DSP_BASE_ADDRESS + 0
`define WB_DSP_CONTROL_REG          `WB_DSP_BASE_ADDRESS + 4
`define WB_DSP_STATUS_REG           `WB_DSP_BASE_ADDRESS + 8

`define TEST_TASKS  test_tasks
`define TEST_PASSED `TEST_TASKS.test_passed
`define TEST_FAILED `TEST_TASKS.test_failed
`define TEST_COMPARE  `TEST_TASKS.compare_values
`define TEST_COMPLETE `TEST_TASKS.all_tests_completed
