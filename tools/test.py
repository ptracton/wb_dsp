#! /usr/bin/env python3

import matplotlib.pyplot as plt
import numpy as np
import matplotlib.gridspec as gridspec
import WBDSP

##
## Number of samples
##
sample_frequency = 1000
start_time = -10*np.pi
end_time = 10*np.pi


##
## Signal we want
##
signal = WBDSP.Signal.Signal(start_time=start_time, end_time=end_time, signal_frequency=1, sample_frequency=sample_frequency,
                             amplitude=1, offset = 0)
signal.CreateSinusoid()

noise_signal = WBDSP.Signal.Signal(start_time=start_time, end_time=end_time, signal_frequency=1, sample_frequency=sample_frequency,
                                   amplitude=1.8, offset = 1)
noise_signal.CreateSquare()

noise_signal2 = WBDSP.Signal.Signal(start_time=start_time, end_time=end_time, signal_frequency=3, sample_frequency=sample_frequency,
                                    amplitude=2, offset = 0, function=np.sinc)
noise_signal2.CreateSquare()


mixed_signal = noise_signal.data + noise_signal2.data + signal.data

figure = plt.figure()
gs1 = gridspec.GridSpec(4, 1)

signal_plot = figure.add_subplot(gs1[0])
signal_plot.plot(signal.time, signal.data)
signal_plot.set_title("Signal We Want")

noise_plot = figure.add_subplot(gs1[1], sharex=signal_plot, sharey=signal_plot)
noise_plot.plot(noise_signal.time, noise_signal.data)
noise_plot.set_title("First Noise")

noise_plot2 = figure.add_subplot(gs1[2], sharex=signal_plot, sharey=signal_plot)
noise_plot2.plot(noise_signal2.time, noise_signal2.data)
noise_plot2.set_title("Second Noise")

mixed_plot = figure.add_subplot(gs1[3], sharex=signal_plot, sharey=signal_plot)
mixed_plot.plot(signal.time, mixed_signal.data)
mixed_plot.set_title("Sampled Signal")

gs1.tight_layout(figure)

figure.show()
plt.show()

#np.set_printoptions(formatter={'int': hex})
#new_list = mixed_signal.view(dtype=np.int8)
#new_list = [int(np.binary_repr(x), 16) for x in mixed_signal]
#mixed_signal.astype(dtype='int8')
#print(new_list)
