// THIS FILE IS AUTOGENERATED BY wb_intercon_gen
// ANY MANUAL CHANGES WILL BE LOST
wire [31:0] wb_m2s_master0_adr;
wire [31:0] wb_m2s_master0_dat;
wire  [3:0] wb_m2s_master0_sel;
wire        wb_m2s_master0_we;
wire        wb_m2s_master0_cyc;
wire        wb_m2s_master0_stb;
wire  [2:0] wb_m2s_master0_cti;
wire  [1:0] wb_m2s_master0_bte;
wire [31:0] wb_s2m_master0_dat;
wire        wb_s2m_master0_ack;
wire        wb_s2m_master0_err;
wire        wb_s2m_master0_rty;
wire [31:0] wb_m2s_wb_slave0_adr;
wire [31:0] wb_m2s_wb_slave0_dat;
wire  [3:0] wb_m2s_wb_slave0_sel;
wire        wb_m2s_wb_slave0_we;
wire        wb_m2s_wb_slave0_cyc;
wire        wb_m2s_wb_slave0_stb;
wire  [2:0] wb_m2s_wb_slave0_cti;
wire  [1:0] wb_m2s_wb_slave0_bte;
wire [31:0] wb_s2m_wb_slave0_dat;
wire        wb_s2m_wb_slave0_ack;
wire        wb_s2m_wb_slave0_err;
wire        wb_s2m_wb_slave0_rty;
wire [31:0] wb_m2s_wb_slave1_adr;
wire [31:0] wb_m2s_wb_slave1_dat;
wire  [3:0] wb_m2s_wb_slave1_sel;
wire        wb_m2s_wb_slave1_we;
wire        wb_m2s_wb_slave1_cyc;
wire        wb_m2s_wb_slave1_stb;
wire  [2:0] wb_m2s_wb_slave1_cti;
wire  [1:0] wb_m2s_wb_slave1_bte;
wire [31:0] wb_s2m_wb_slave1_dat;
wire        wb_s2m_wb_slave1_ack;
wire        wb_s2m_wb_slave1_err;
wire        wb_s2m_wb_slave1_rty;

wb_intercon wb_intercon0
   (.wb_clk_i           (wb_clk),
    .wb_rst_i           (wb_rst),
    .wb_master0_adr_i   (wb_m2s_master0_adr),
    .wb_master0_dat_i   (wb_m2s_master0_dat),
    .wb_master0_sel_i   (wb_m2s_master0_sel),
    .wb_master0_we_i    (wb_m2s_master0_we),
    .wb_master0_cyc_i   (wb_m2s_master0_cyc),
    .wb_master0_stb_i   (wb_m2s_master0_stb),
    .wb_master0_cti_i   (wb_m2s_master0_cti),
    .wb_master0_bte_i   (wb_m2s_master0_bte),
    .wb_master0_dat_o   (wb_s2m_master0_dat),
    .wb_master0_ack_o   (wb_s2m_master0_ack),
    .wb_master0_err_o   (wb_s2m_master0_err),
    .wb_master0_rty_o   (wb_s2m_master0_rty),
    .wb_wb_slave0_adr_o (wb_m2s_wb_slave0_adr),
    .wb_wb_slave0_dat_o (wb_m2s_wb_slave0_dat),
    .wb_wb_slave0_sel_o (wb_m2s_wb_slave0_sel),
    .wb_wb_slave0_we_o  (wb_m2s_wb_slave0_we),
    .wb_wb_slave0_cyc_o (wb_m2s_wb_slave0_cyc),
    .wb_wb_slave0_stb_o (wb_m2s_wb_slave0_stb),
    .wb_wb_slave0_cti_o (wb_m2s_wb_slave0_cti),
    .wb_wb_slave0_bte_o (wb_m2s_wb_slave0_bte),
    .wb_wb_slave0_dat_i (wb_s2m_wb_slave0_dat),
    .wb_wb_slave0_ack_i (wb_s2m_wb_slave0_ack),
    .wb_wb_slave0_err_i (wb_s2m_wb_slave0_err),
    .wb_wb_slave0_rty_i (wb_s2m_wb_slave0_rty),
    .wb_wb_slave1_adr_o (wb_m2s_wb_slave1_adr),
    .wb_wb_slave1_dat_o (wb_m2s_wb_slave1_dat),
    .wb_wb_slave1_sel_o (wb_m2s_wb_slave1_sel),
    .wb_wb_slave1_we_o  (wb_m2s_wb_slave1_we),
    .wb_wb_slave1_cyc_o (wb_m2s_wb_slave1_cyc),
    .wb_wb_slave1_stb_o (wb_m2s_wb_slave1_stb),
    .wb_wb_slave1_cti_o (wb_m2s_wb_slave1_cti),
    .wb_wb_slave1_bte_o (wb_m2s_wb_slave1_bte),
    .wb_wb_slave1_dat_i (wb_s2m_wb_slave1_dat),
    .wb_wb_slave1_ack_i (wb_s2m_wb_slave1_ack),
    .wb_wb_slave1_err_i (wb_s2m_wb_slave1_err),
    .wb_wb_slave1_rty_i (wb_s2m_wb_slave1_rty));

