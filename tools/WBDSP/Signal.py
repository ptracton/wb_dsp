#! /usr/bin/env python3

import numpy as np
import scipy.signal

class Signal:
    def __init__(self, start_time = 0, end_time=0, signal_frequency=0, sample_frequency = 1.0, amplitude = 1.0,
                 offset = 0, function = np.sin):

        self.signal_frequency = signal_frequency
        self.sample_frequency = sample_frequency
        self.amplitude = amplitude
        self.offset = offset
        self.function = function
        self.start_time = start_time
        self.end_time = end_time
        self.time = np.arange(self.start_time, self.end_time, 1./self.sample_frequency)
        self.data = []
        return None

    def CreateSinusoid(self):
        self.time = np.arange(self.start_time, self.end_time, 1./self.sample_frequency)
        self.data = self.amplitude * self.function(2*np.pi*self.signal_frequency*self.time + self.offset)
        return

    def CreateSquare(self, duty_cycle=50):
        self.time = np.arange(self.start_time, self.end_time, 1./self.sample_frequency)
        self.data = self.amplitude * scipy.signal.square(self.time)
        return

    def CreateSawTooth(self):
        self.time = np.arange(self.start_time, self.end_time, 1./self.sample_frequency)
        self.data = self.amplitude * scipy.signal.sawtooth(self.time)
        return
        
    def period(self):
        return 1/self.signal_frequency
        
   
