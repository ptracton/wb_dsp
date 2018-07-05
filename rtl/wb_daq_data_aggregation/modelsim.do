

vlib work

vlog wb_daq_data_aggregation.v
vlog tb_wb_daq_data_aggregation.v +define+MODELSIM_GUI
vlog test_tasks.v +define+MODELSIM_GUI
vlog dump.v

vsim work.tb_wb_daq_data_aggregation 
do wave.do
run -all

