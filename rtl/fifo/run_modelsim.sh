#! /usr/bin/env sh

rm -rf vsim.wlf work/

vsim -c -do fifo_modelsim.f

./a.out
