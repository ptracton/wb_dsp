

vlib work

vlog fifo.v
vlog tb_fifo.v +define+MODELSIM_GUI
vlog test_tasks.v +define+MODELSIM_GUI
vlog dump.v

vsim work.tb_fifo 
do wave.do
run -all

