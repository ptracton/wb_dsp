#! /usr/bin/env python3

import matplotlib.pyplot as plt
import numpy as np

fs = 44100
t = np.arange(-0.002, .002, 1.0/fs)
f0 = 1000
phi = np.pi/2
A = .8
x = A * np.sin(2 * np.pi * f0 * t + phi)

#y = .6 * np.sin(2 * np.pi * 1500 * t + 100)
#z = x + y
#print (x)
fixed_x = [int(i*256) for i in x]
back_x = [i/256 for i in fixed_x]
plt.plot(t, x)
plt.plot(t, back_x)
#plt.plot(t, z)
#plt.axis([-0.002, .002, -1, 1])
#plt.xlabel('time')
#plt.ylabel('amplitude')
plt.show()
