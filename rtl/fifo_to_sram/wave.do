onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group T -radix hexadecimal /tb_fifo_to_sram/wb_clk
add wave -noupdate -group T -radix hexadecimal /tb_fifo_to_sram/wb_rst
add wave -noupdate -group T -radix hexadecimal /tb_fifo_to_sram/pop
add wave -noupdate -group T -radix hexadecimal /tb_fifo_to_sram/sram_data_out
add wave -noupdate -group T -radix hexadecimal /tb_fifo_to_sram/sram_start
add wave -noupdate -group T -radix hexadecimal /tb_fifo_to_sram/empty
add wave -noupdate -group T -radix hexadecimal /tb_fifo_to_sram/grant
add wave -noupdate -group T -radix hexadecimal /tb_fifo_to_sram/fifo_number_samples
add wave -noupdate -group T -radix hexadecimal /tb_fifo_to_sram/fifo_number_samples_terminal
add wave -noupdate -group T -radix hexadecimal /tb_fifo_to_sram/data_done
add wave -noupdate -group T -radix hexadecimal /tb_fifo_to_sram/fifo_data_in
add wave -noupdate -radix hexadecimal /tb_fifo_to_sram/dut/wb_clk
add wave -noupdate -radix hexadecimal /tb_fifo_to_sram/dut/wb_rst
add wave -noupdate -radix hexadecimal /tb_fifo_to_sram/dut/empty
add wave -noupdate -radix hexadecimal /tb_fifo_to_sram/dut/grant
add wave -noupdate -radix hexadecimal /tb_fifo_to_sram/dut/fifo_number_samples
add wave -noupdate -radix hexadecimal /tb_fifo_to_sram/dut/fifo_number_samples_terminal
add wave -noupdate -radix hexadecimal /tb_fifo_to_sram/dut/data_done
add wave -noupdate -radix hexadecimal /tb_fifo_to_sram/dut/pop
add wave -noupdate -radix hexadecimal /tb_fifo_to_sram/dut/fifo_data_in
add wave -noupdate -radix hexadecimal /tb_fifo_to_sram/dut/sram_data_out
add wave -noupdate -radix hexadecimal /tb_fifo_to_sram/dut/sram_start
add wave -noupdate -radix hexadecimal /tb_fifo_to_sram/dut/active
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {49993112 ps} {50000468 ps}
