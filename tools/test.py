#! /usr/bin/env python3

import matplotlib.pyplot as plt
import numpy as np
import matplotlib.gridspec as gridspec


##
## Number of samples
##
sample_frequency = 1000

##
## Time, these are the x-axis points where we sample
##
time = np.arange(start=0, stop=np.pi/4, step=1/sample_frequency)

##
## Amplitude is the height of the waveform
##
amplitude = 1

##
## phase is the offset of the start
##
phase = 0

##
## F0
##
f0 = 1

frequency = 100

##
## Signal we want
##
signal = amplitude * np.sin(2*np.pi * frequency * time + phase)

noise_frequency = 220
noise_amplitude = 1.8
noise_phase = 1
noise_f0 = 1
noise_signal = noise_amplitude * np.cos(2*np.pi * noise_frequency * time + noise_phase)

noise_frequency2 = 20
noise_amplitude2 = 0.76
noise_phase2 = 1
noise_f02 = 1
noise_signal2 = noise_amplitude2 * np.sin(2*np.pi * noise_frequency2 * time + noise_phase2)


mixed_signal = noise_signal + noise_signal2 + signal

figure = plt.figure()
gs1 = gridspec.GridSpec(4, 1)

signal_plot = figure.add_subplot(gs1[0])
signal_plot.plot(time, signal)

noise_plot = figure.add_subplot(gs1[1], sharex=signal_plot, sharey=signal_plot)
noise_plot.plot(time, noise_signal)

noise_plot2 = figure.add_subplot(gs1[2], sharex=signal_plot,
                                 sharey=signal_plot)
noise_plot2.plot(time, noise_signal2)

mixed_plot = figure.add_subplot(gs1[3], sharex=signal_plot, sharey=signal_plot)
mixed_plot.plot(time, mixed_signal)

gs1.tight_layout(figure)

figure.show()
#plt.show()

np.set_printoptions(formatter={'int': hex})
#new_list = mixed_signal.view(dtype=np.int8)
new_list = [int(np.binary_repr(x), 16) for x in mixed_signal]
#mixed_signal.astype(dtype='int8')
print(new_list)
