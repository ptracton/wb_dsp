


vlog wb_master_interface.v  +incdir+../
vlog bus_matrix.v
vlog ../../behavioral/wb_ram/wb_ram.v
vlog ../../behavioral/wb_ram/wb_ram_generic.v
vlog ../../behavioral/wb_intercon/wb_arbiter.v
vlog ../../behavioral/wb_intercon/wb_data_resize.v
vlog ../../behavioral/wb_intercon/wb_mux.v
vlog ../../testbench/arbiter.v
vlog tb_wb_master_interface.v +define+MODELSIM_GUI
vlog test_tasks.v +define+MODELSIM_GUI
vlog dump.v

vsim work.wb_master_interface 
do wave.do
run -all

