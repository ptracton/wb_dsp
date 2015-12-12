vlib work

      
vlog ../rtl/syscon.v 
vlog ../rtl/wb_dsp.v
vlog ../rtl/wb_dsp_control.v +incdir+../rtl/
vlog ../rtl/wb_dsp_slave_registers.v +incdir+../rtl/
vlog ../rtl/wb_dsp_top.v
vlog ../rtl/wb_master_interface.v
vlog ../testbench/test_tasks.v -timescale 1ns/1ns
vlog ../testbench/testbench.v  +incdir+../testbench +define+SIM
vlog ../testbench/arbiter.v
vlog ../testbench/wb_dsp_testbench_intercon.v
vlog ../testbench/wb_dump.v +define+SIM
vlog ../cores/orpsoc-cores/cores/wb_intercon/wb_mux.v +incdir+../cores/orpsoc-cores/cores/verilog_utils/ 
vlog ../cores/orpsoc-cores/cores/wb_intercon/wb_arbiter.v +incdir+../cores/orpsoc-cores/cores/verilog_utils/
vlog ../cores/orpsoc-cores/cores/wb_intercon/wb_data_resize.v      
vlog ../cores/orpsoc-cores/cores/wb_bfm/wb_bfm-0/wb_bfm_master.v +incdir+../cores/orpsoc-cores/cores/wb_bfm/wb_bfm-0/ -timescale 1ns/1ns
vlog ../cores/orpsoc-cores/cores/wb_ram/rtl/verilog/wb_ram.v  +incdir+../cores/orpsoc-cores/cores/wb_common/ 
vlog ../cores/orpsoc-cores/cores/wb_ram/rtl/verilog/wb_ram_generic.v      

vlog ../simulation/simple_slave_00.v -timescale 1ns/1ns +define+SIM

      
vsim -voptargs=+acc work.testbench
run -all
      