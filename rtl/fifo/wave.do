onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group TB -radix hexadecimal /tb_fifo/defaultDW
add wave -noupdate -expand -group TB -radix hexadecimal /tb_fifo/defaultDepth
add wave -noupdate -expand -group TB -radix hexadecimal /tb_fifo/wb_clk
add wave -noupdate -expand -group TB -radix hexadecimal /tb_fifo/wb_rst
add wave -noupdate -expand -group TB -radix hexadecimal /tb_fifo/defaultDataOut
add wave -noupdate -expand -group TB -radix hexadecimal /tb_fifo/defaultEmpty
add wave -noupdate -expand -group TB -radix hexadecimal /tb_fifo/defaultFull
add wave -noupdate -expand -group TB -radix hexadecimal /tb_fifo/defaultNumberSamples
add wave -noupdate -expand -group TB -radix hexadecimal /tb_fifo/defaultPush
add wave -noupdate -expand -group TB -radix hexadecimal /tb_fifo/defaultPop
add wave -noupdate -expand -group TB -radix hexadecimal /tb_fifo/defaultDataIn
add wave -noupdate -expand -group TB -radix hexadecimal /tb_fifo/i
add wave -noupdate -group {Default FIFO} -radix hexadecimal /tb_fifo/dutDefault/dw
add wave -noupdate -group {Default FIFO} -radix hexadecimal /tb_fifo/dutDefault/depth
add wave -noupdate -group {Default FIFO} -radix hexadecimal /tb_fifo/dutDefault/wb_clk
add wave -noupdate -group {Default FIFO} -radix hexadecimal /tb_fifo/dutDefault/wb_rst
add wave -noupdate -group {Default FIFO} -radix hexadecimal /tb_fifo/dutDefault/push
add wave -noupdate -group {Default FIFO} -radix hexadecimal /tb_fifo/dutDefault/pop
add wave -noupdate -group {Default FIFO} -radix hexadecimal /tb_fifo/dutDefault/data_in
add wave -noupdate -group {Default FIFO} -radix hexadecimal /tb_fifo/dutDefault/data_out
add wave -noupdate -group {Default FIFO} -radix hexadecimal /tb_fifo/dutDefault/empty
add wave -noupdate -group {Default FIFO} -radix hexadecimal /tb_fifo/dutDefault/full
add wave -noupdate -group {Default FIFO} -radix hexadecimal /tb_fifo/dutDefault/number_samples
add wave -noupdate -group {Default FIFO} -radix hexadecimal /tb_fifo/dutDefault/rd_ptr
add wave -noupdate -group {Default FIFO} -radix hexadecimal /tb_fifo/dutDefault/wr_ptr
add wave -noupdate -group {Default FIFO} -radix hexadecimal /tb_fifo/dutDefault/memory
add wave -noupdate -group {Default FIFO} -radix hexadecimal /tb_fifo/dutDefault/i
add wave -noupdate -expand -group {Short And Narrow} -radix hexadecimal /tb_fifo/dutShortNarrow/dw
add wave -noupdate -expand -group {Short And Narrow} -radix hexadecimal /tb_fifo/dutShortNarrow/depth
add wave -noupdate -expand -group {Short And Narrow} -radix hexadecimal /tb_fifo/dutShortNarrow/wb_clk
add wave -noupdate -expand -group {Short And Narrow} -radix hexadecimal /tb_fifo/dutShortNarrow/wb_rst
add wave -noupdate -expand -group {Short And Narrow} -radix hexadecimal /tb_fifo/dutShortNarrow/push
add wave -noupdate -expand -group {Short And Narrow} -radix hexadecimal /tb_fifo/dutShortNarrow/pop
add wave -noupdate -expand -group {Short And Narrow} -radix hexadecimal /tb_fifo/dutShortNarrow/data_in
add wave -noupdate -expand -group {Short And Narrow} -radix hexadecimal /tb_fifo/dutShortNarrow/data_out
add wave -noupdate -expand -group {Short And Narrow} -radix hexadecimal /tb_fifo/dutShortNarrow/empty
add wave -noupdate -expand -group {Short And Narrow} -radix hexadecimal /tb_fifo/dutShortNarrow/full
add wave -noupdate -expand -group {Short And Narrow} -radix hexadecimal /tb_fifo/dutShortNarrow/number_samples
add wave -noupdate -expand -group {Short And Narrow} -radix hexadecimal /tb_fifo/dutShortNarrow/rd_ptr
add wave -noupdate -expand -group {Short And Narrow} -radix hexadecimal /tb_fifo/dutShortNarrow/wr_ptr
add wave -noupdate -expand -group {Short And Narrow} -radix hexadecimal /tb_fifo/dutShortNarrow/memory
add wave -noupdate -expand -group {Short And Narrow} -radix hexadecimal /tb_fifo/dutShortNarrow/i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 263
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
WaveRestoreZoom {650 ps} {2445 ps}
