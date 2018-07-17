// THIS FILE IS AUTOGENERATED BY wb_intercon_gen
// ANY MANUAL CHANGES WILL BE LOST
module wb_intercon
   (input         wb_clk_i,
    input         wb_rst_i,
    input  [31:0] wb_bus_master_adr_i,
    input  [31:0] wb_bus_master_dat_i,
    input   [3:0] wb_bus_master_sel_i,
    input         wb_bus_master_we_i,
    input         wb_bus_master_cyc_i,
    input         wb_bus_master_stb_i,
    input   [2:0] wb_bus_master_cti_i,
    input   [1:0] wb_bus_master_bte_i,
    output [31:0] wb_bus_master_dat_o,
    output        wb_bus_master_ack_o,
    output        wb_bus_master_err_o,
    output        wb_bus_master_rty_o,
    output [31:0] wb_daq_registers_adr_o,
    output [31:0] wb_daq_registers_dat_o,
    output  [3:0] wb_daq_registers_sel_o,
    output        wb_daq_registers_we_o,
    output        wb_daq_registers_cyc_o,
    output        wb_daq_registers_stb_o,
    output  [2:0] wb_daq_registers_cti_o,
    output  [1:0] wb_daq_registers_bte_o,
    input  [31:0] wb_daq_registers_dat_i,
    input         wb_daq_registers_ack_i,
    input         wb_daq_registers_err_i,
    input         wb_daq_registers_rty_i,
    output [31:0] wb_ram0_adr_o,
    output [31:0] wb_ram0_dat_o,
    output  [3:0] wb_ram0_sel_o,
    output        wb_ram0_we_o,
    output        wb_ram0_cyc_o,
    output        wb_ram0_stb_o,
    output  [2:0] wb_ram0_cti_o,
    output  [1:0] wb_ram0_bte_o,
    input  [31:0] wb_ram0_dat_i,
    input         wb_ram0_ack_i,
    input         wb_ram0_err_i,
    input         wb_ram0_rty_i);

wb_mux
  #(.num_slaves (2),
    .MATCH_ADDR ({32'h20000000, 32'h40000000}),
    .MATCH_MASK ({32'hffffff00, 32'hffffff00}))
 wb_mux_bus_master
   (.wb_clk_i  (wb_clk_i),
    .wb_rst_i  (wb_rst_i),
    .wbm_adr_i (wb_bus_master_adr_i),
    .wbm_dat_i (wb_bus_master_dat_i),
    .wbm_sel_i (wb_bus_master_sel_i),
    .wbm_we_i  (wb_bus_master_we_i),
    .wbm_cyc_i (wb_bus_master_cyc_i),
    .wbm_stb_i (wb_bus_master_stb_i),
    .wbm_cti_i (wb_bus_master_cti_i),
    .wbm_bte_i (wb_bus_master_bte_i),
    .wbm_dat_o (wb_bus_master_dat_o),
    .wbm_ack_o (wb_bus_master_ack_o),
    .wbm_err_o (wb_bus_master_err_o),
    .wbm_rty_o (wb_bus_master_rty_o),
    .wbs_adr_o ({wb_daq_registers_adr_o, wb_ram0_adr_o}),
    .wbs_dat_o ({wb_daq_registers_dat_o, wb_ram0_dat_o}),
    .wbs_sel_o ({wb_daq_registers_sel_o, wb_ram0_sel_o}),
    .wbs_we_o  ({wb_daq_registers_we_o, wb_ram0_we_o}),
    .wbs_cyc_o ({wb_daq_registers_cyc_o, wb_ram0_cyc_o}),
    .wbs_stb_o ({wb_daq_registers_stb_o, wb_ram0_stb_o}),
    .wbs_cti_o ({wb_daq_registers_cti_o, wb_ram0_cti_o}),
    .wbs_bte_o ({wb_daq_registers_bte_o, wb_ram0_bte_o}),
    .wbs_dat_i ({wb_daq_registers_dat_i, wb_ram0_dat_i}),
    .wbs_ack_i ({wb_daq_registers_ack_i, wb_ram0_ack_i}),
    .wbs_err_i ({wb_daq_registers_err_i, wb_ram0_err_i}),
    .wbs_rty_i ({wb_daq_registers_rty_i, wb_ram0_rty_i}));

endmodule
