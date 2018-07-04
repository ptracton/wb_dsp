#! /usr/bin/env sh

rm -f a.out dump.vcd
iverilog -f fifo_sim.f
./a.out | tee  fifo_iverilog.log
