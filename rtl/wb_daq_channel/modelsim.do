

vlib work

vlog wb_daq_channel.v +incdir+../
vlog ../wb_daq_data_aggregation/wb_daq_data_aggregation.v
vlog ../fifo/fifo.v
vlog ../fifo_to_sram/fifo_to_sram.v
vlog ../../behavioral/adc/adc.v
vlog tb_wb_daq_channel.v  +define+MODELSIM_GUI
vlog test_tasks.v +define+MODELSIM_GUI
vlog dump.v

vsim work.tb_wb_daq_channel
do wave.do
run -all

