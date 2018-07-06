

vlib work

vlog fifo_to_sram.v
vlog tb_fifo_to_sram.v +define+MODELSIM_GUI
vlog test_tasks.v +define+MODELSIM_GUI
vlog dump.v

vsim work.tb_fifo_to_sram 
do wave.do
run -all

