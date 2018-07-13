vlib work

vlog wb_master_interface.v  +incdir+../
vlog bus_matrix.v
vlog ../../behavioral/wb_ram/wb_ram.v +incdir+../../cores/orpsoc-cores/cores/wb_common
vlog ../../behavioral/wb_ram/wb_ram_generic.v
vlog ../../behavioral/wb_intercon/wb_arbiter.v +incdir+../../cores/orpsoc-cores/cores/verilog_utils

vlog ../../behavioral/wb_intercon/wb_data_resize.v
vlog ../../behavioral/wb_intercon/wb_mux.v +incdir+../../cores/orpsoc-cores/cores/verilog_utils

vlog ../../testbench/arbiter.v
vlog tb_wb_master_interface.v 
vlog test_tasks.v 
vlog dump.v

vsim work.tb_wb_master_interface
run -all
