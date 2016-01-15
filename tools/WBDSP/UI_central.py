#! /usr/bin/env python3
'''
Central widget for WB DSP
'''

from PyQt4 import QtGui
from PyQt4 import QtCore
import numpy as np

import QtMpl
import UI_InputSignal
import Signal

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

        self.connect(self.InputSignal.MixSignalsPushButton,
                     QtCore.SIGNAL("clicked()"),
                     self.MixedSignalPushButton_Clicked)
        
        self.connect(self.InputSignal.RemovePushButton,
                     QtCore.SIGNAL("clicked()"),
                     self.RemovePushButton_Clicked)

        self.connect(self.InputSignal.WriteDataPushButton,
                     QtCore.SIGNAL("clicked()"),
                     self.WriteFilePushButton_Clicked)

        
        self.graph = QtMpl.QtMpl(parent=None)
        vbox.addWidget(self.graph)

        self.setLayout(vbox)
        return

    def GraphPushButton_Clicked(self):
        """
        """

        print ("Graph Clicked")
        amplitude = float(self.InputSignal.AmplitudeInput.displayText())
        frequency = float(self.InputSignal.FrequencyInput.displayText())
        sample_frequency = float(self.InputSignal.SampleFrequencyInput.displayText())
        start_time     = float(self.InputSignal.StartTimeInput.displayText())
        end_time     = float(self.InputSignal.EndTimeInput.displayText())
        phase     = float(self.InputSignal.PhaseInput.displayText())
        signal    = self.InputSignal.SignalTypeComboBox.currentText()

        #print (amplitude)
        #print (frequency)
        #print (phase)
        print (signal)
        #print(sample_frequency)

        self.InputSignal.Signal.amplitude = amplitude
        self.InputSignal.Signal.sample_frequency = sample_frequency
        self.InputSignal.Signal.signal_frequency = frequency
        self.InputSignal.Signal.end_time = end_time
        self.InputSignal.Signal.start_time = start_time
        self.InputSignal.Signal.offset = phase

        if (signal == 'sine'):
            self.InputSignal.Signal.CreateSinusoid()
        if (signal == 'triangle'):
            self.InputSignal.Signal.CreateSawTooth()
        if (signal == 'square'):
            self.InputSignal.Signal.CreateSquare()
        
        print (len(self.InputSignal.Signal.data))
        print (self.InputSignal.Signal.data)
        self.graph.addSignal(self.InputSignal.Signal)
        return
        
    def MixedSignalPushButton_Clicked(self):        
        print ("Mixed Signals Clicked")
        temp = Signal.Signal(start_time=self.graph.list_of_signals[0].start_time,
                             end_time = self.graph.list_of_signals[0].end_time,
                             sample_frequency=self.graph.list_of_signals[0].sample_frequency)
        temp.CreateSawTooth()
        print (len(self.graph.list_of_signals))
        for x in self.graph.list_of_signals:
            print (len(x.data))
            print (x.data)
            temp.data = temp.data + x.data
            
        self.graph.addSignal(temp)
        return
        
    def RemovePushButton_Clicked(self):
        print ("Remove Clicked")
        self.graph.removeSignal()
        return

    def WriteFilePushButton_Clicked(self):
        print ("Write File Push Button Clicked")
        return
