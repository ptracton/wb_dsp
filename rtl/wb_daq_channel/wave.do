onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group ADC -radix hexadecimal /tb_wb_daq_channel/adc0/dw
add wave -noupdate -group ADC -radix hexadecimal /tb_wb_daq_channel/adc0/adc_image
add wave -noupdate -group ADC -radix hexadecimal /tb_wb_daq_channel/adc0/adc_clk
add wave -noupdate -group ADC -radix hexadecimal /tb_wb_daq_channel/adc0/wb_clk
add wave -noupdate -group ADC -radix hexadecimal /tb_wb_daq_channel/adc0/wb_rst
add wave -noupdate -group ADC -radix hexadecimal /tb_wb_daq_channel/adc0/enable
add wave -noupdate -group ADC -radix hexadecimal /tb_wb_daq_channel/adc0/data_out
add wave -noupdate -group ADC -radix hexadecimal /tb_wb_daq_channel/adc0/data_ready
add wave -noupdate -group ADC -radix hexadecimal /tb_wb_daq_channel/adc0/shift_delay
add wave -noupdate -group ADC -radix hexadecimal /tb_wb_daq_channel/adc0/data_ready_local
add wave -noupdate -group ADC -radix hexadecimal /tb_wb_daq_channel/adc0/memory
add wave -noupdate -group ADC -radix hexadecimal /tb_wb_daq_channel/adc0/index
add wave -noupdate -group ADC -radix hexadecimal /tb_wb_daq_channel/adc0/previous_index
add wave -noupdate -expand -group Aggregate -radix hexadecimal /tb_wb_daq_channel/dut/aggregate/data_ready
add wave -noupdate -expand -group Aggregate -radix hexadecimal /tb_wb_daq_channel/dut/aggregate/signed_data
add wave -noupdate -expand -group Aggregate -radix hexadecimal /tb_wb_daq_channel/dut/aggregate/adc_data_in
add wave -noupdate -expand -group Aggregate -radix hexadecimal /tb_wb_daq_channel/dut/aggregate/data_out
add wave -noupdate -expand -group Aggregate -radix hexadecimal /tb_wb_daq_channel/dut/aggregate/fifo_push
add wave -noupdate -expand -group Aggregate -radix hexadecimal /tb_wb_daq_channel/dut/aggregate/byte_location
add wave -noupdate -expand -group Aggregate -radix hexadecimal /tb_wb_daq_channel/dut/aggregate/sign_bit
add wave -noupdate -expand -group Aggregate -radix hexadecimal /tb_wb_daq_channel/dut/aggregate/sign_extend32
add wave -noupdate -group FIFO -radix hexadecimal /tb_wb_daq_channel/dut/fifo0/push
add wave -noupdate -group FIFO -radix hexadecimal /tb_wb_daq_channel/dut/fifo0/pop
add wave -noupdate -group FIFO -radix hexadecimal /tb_wb_daq_channel/dut/fifo0/data_in
add wave -noupdate -group FIFO -radix hexadecimal /tb_wb_daq_channel/dut/fifo0/data_out
add wave -noupdate -group FIFO -radix hexadecimal /tb_wb_daq_channel/dut/fifo0/empty
add wave -noupdate -group FIFO -radix hexadecimal /tb_wb_daq_channel/dut/fifo0/full
add wave -noupdate -group FIFO -radix hexadecimal /tb_wb_daq_channel/dut/fifo0/number_samples
add wave -noupdate -group FIFO -radix hexadecimal /tb_wb_daq_channel/dut/fifo0/rd_ptr
add wave -noupdate -group FIFO -radix hexadecimal /tb_wb_daq_channel/dut/fifo0/wr_ptr
add wave -noupdate -group FIFO -radix hexadecimal /tb_wb_daq_channel/dut/fifo0/memory
add wave -noupdate -group {FIFO TO SRAM} -radix hexadecimal /tb_wb_daq_channel/dut/fifo_to_sram0/empty
add wave -noupdate -group {FIFO TO SRAM} -radix hexadecimal /tb_wb_daq_channel/dut/fifo_to_sram0/fifo_number_samples
add wave -noupdate -group {FIFO TO SRAM} -radix hexadecimal /tb_wb_daq_channel/dut/fifo_to_sram0/fifo_number_samples_terminal
add wave -noupdate -group {FIFO TO SRAM} -radix hexadecimal /tb_wb_daq_channel/dut/fifo_to_sram0/data_done
add wave -noupdate -group {FIFO TO SRAM} -radix hexadecimal /tb_wb_daq_channel/dut/fifo_to_sram0/pop
add wave -noupdate -group {FIFO TO SRAM} -radix hexadecimal /tb_wb_daq_channel/dut/fifo_to_sram0/fifo_data_in
add wave -noupdate -group {FIFO TO SRAM} -radix hexadecimal /tb_wb_daq_channel/dut/fifo_to_sram0/sram_data_out
add wave -noupdate -group {FIFO TO SRAM} -radix hexadecimal /tb_wb_daq_channel/dut/fifo_to_sram0/sram_start
add wave -noupdate -group {FIFO TO SRAM} -radix hexadecimal /tb_wb_daq_channel/dut/fifo_to_sram0/state
add wave -noupdate -group {FIFO TO SRAM} -radix hexadecimal /tb_wb_daq_channel/dut/fifo_to_sram0/next_state
add wave -noupdate -group {FIFO TO SRAM} -radix hexadecimal /tb_wb_daq_channel/dut/fifo_to_sram0/start_state_machine
add wave -noupdate -group {FIFO TO SRAM} -radix ascii /tb_wb_daq_channel/dut/fifo_to_sram0/state_name
add wave -noupdate -expand -group TB -radix hexadecimal /tb_wb_daq_channel/data_out
add wave -noupdate -expand -group TB -radix hexadecimal /tb_wb_daq_channel/fifo_empty
add wave -noupdate -expand -group TB -radix hexadecimal /tb_wb_daq_channel/start_sram
add wave -noupdate -expand -group TB -radix hexadecimal /tb_wb_daq_channel/adc_enable
add wave -noupdate -expand -group TB -radix hexadecimal /tb_wb_daq_channel/master_enable
add wave -noupdate -expand -group TB -radix hexadecimal /tb_wb_daq_channel/control
add wave -noupdate -expand -group TB -radix hexadecimal /tb_wb_daq_channel/fifo_number_samples_terminal
add wave -noupdate -expand -group TB -radix hexadecimal /tb_wb_daq_channel/data_done
add wave -noupdate -expand -group TB -radix hexadecimal /tb_wb_daq_channel/adc_data_out
add wave -noupdate -expand -group TB -radix hexadecimal /tb_wb_daq_channel/adc_data_ready
add wave -noupdate -expand -group TB -radix hexadecimal /tb_wb_daq_channel/PopStart
add wave -noupdate -expand -group TB -radix hexadecimal /tb_wb_daq_channel/PushStart
add wave -noupdate -expand -group TB -radix hexadecimal /tb_wb_daq_channel/state
add wave -noupdate -expand -group TB -radix hexadecimal /tb_wb_daq_channel/next_state
add wave -noupdate -expand -group TB -radix hexadecimal /tb_wb_daq_channel/capture_sram_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 394
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
WaveRestoreZoom {0 ps} {37590 ps}
