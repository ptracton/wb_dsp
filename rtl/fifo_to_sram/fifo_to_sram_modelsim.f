vlib work

vlog fifo_to_sram.v
vlog ../fifo/fifo.v
vlog tb_fifo_to_sram.v
vlog test_tasks.v
vlog dump.v

vsim work.tb_fifo_to_sram
run -all
