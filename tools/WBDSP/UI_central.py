#! /usr/bin/env python3
'''
Central widget for WB DSP
'''

from PyQt4 import QtGui
from PyQt4 import QtCore
import numpy as np

import QtMpl
import UI_InputSignal


class UI_central(QtGui.QDialog):

    '''
    Our top level UI widget
    '''

    def __init__(self, parent=None):
        super(UI_central, self).__init__(parent)
        vbox = QtGui.QVBoxLayout()

        self.InputSignal = UI_InputSignal.UI_InputSignal()
        vbox.addWidget(self.InputSignal)
        self.connect(self.InputSignal.GraphPushButton,
                     QtCore.SIGNAL("clicked()"),
                     self.GraphPushButton_Clicked)
        self.graph = QtMpl.QtMpl(parent=None)
        vbox.addWidget(self.graph)

        self.setLayout(vbox)
        return

    def GraphPushButton_Clicked(self):
        """
        """

        print ("Clicked")
        amplitude = float(self.InputSignal.AmplitudeInput.displayText())
        frequency = float(self.InputSignal.FrequencyInput.displayText())
        sample_frequency = float(self.InputSignal.SampleFrequencyInput.displayText())
        start_time     = float(self.InputSignal.StartTimeInput.displayText())
        end_time     = float(self.InputSignal.EndTimeInput.displayText())
        phase     = float(self.InputSignal.PhaseInput.displayText())
        signal    = self.InputSignal.SignalTypeComboBox.currentText()

        print (amplitude)
        print (frequency)
        print (phase)
        print (signal)
        print(sample_frequency)

        self.InputSignal.Signal.amplitude = amplitude
        self.InputSignal.Signal.sample_frequency = sample_frequency
        self.InputSignal.Signal.frequency = frequency
        self.InputSignal.Signal.end_time = end_time
        self.InputSignal.Signal.start_time = start_time
        self.InputSignal.Signal.offset = phase

        if (signal == 'sine'):
            self.InputSignal.Signal.CreateSinusoid()
        if (signal == 'triangle'):
            self.InputSignal.Signal.CreateSawTooth()
        if (signal == 'square'):
            self.InputSignal.Signal.CreateSquare()
        
#        fs = 44100
#        time = np.arange(-.002, .002, 1/fs)
#        sine_wave = amplitude * np.sin(2 * np.pi * frequency * time + phase)
        #print (sine_wave)
        print (self.InputSignal.Signal.data)
        #self.graph.addLine(self.InputSignal.Signal.time, self.InputSignal.Signal.data, "Graph")
        self.graph.addSignal(self.InputSignal.Signal)
        return
