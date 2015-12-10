
      

../rtl/syscon.v
../rtl/wb_dsp.v
../rtl/wb_dsp_control.v
../rtl/wb_dsp_slave_registers.v
../rtl/wb_dsp_top.v
../rtl/wb_master_interface.v      
../testbench/testbench.v -i ../testbench
../testbench/test_tasks.v
../testbench/arbiter.v
../testbench/wb_dsp_testbench_intercon.v
../testbench/wb_dump.v
../cores/orpsoc-cores/cores/wb_intercon/wb_mux.v -i ../cores/orpsoc-cores/cores/verilog_utils/
../cores/orpsoc-cores/cores/wb_intercon/wb_arbiter.v
../cores/orpsoc-cores/cores/wb_intercon/wb_data_resize.v      
../cores/orpsoc-cores/cores/wb_bfm/wb_bfm-0/wb_bfm_master.v
../cores/orpsoc-cores/cores/wb_ram/rtl/verilog/wb_ram.v -i ../cores/orpsoc-cores/cores/wb_common/      
../cores/orpsoc-cores/cores/wb_ram/rtl/verilog/wb_ram_generic.v      
