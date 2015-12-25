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
        hbox = QtGui.QHBoxLayout()

        self.InputSignal = UI_InputSignal.UI_InputSignal()
        hbox.addWidget(self.InputSignal)
        self.connect(self.InputSignal.GraphPushButton,
                     QtCore.SIGNAL("clicked()"),
                     self.GraphPushButton_Clicked)
        self.graph = QtMpl.QtMpl(parent=None)
        hbox.addWidget(self.graph)

        self.setLayout(hbox)
        return

    def GraphPushButton_Clicked(self):
        """
        """

        print ("Clicked")
        amplitude = float(self.InputSignal.AmplitudeInput.displayText())
        frequency = float(self.InputSignal.FrequencyInput.displayText())
        phase     = float(self.InputSignal.PhaseInput.displayText())
        signal    = self.InputSignal.SignalTypeComboBox.currentText()

        print (amplitude)
        print (frequency)
        print (phase)
        print (signal)
        fs = 44100
        time = np.arange(-.002, .002, 1/fs)
        sine_wave = amplitude * np.sin(2 * np.pi * frequency * time + phase)
        print (sine_wave)
        self.graph.addLine(time, sine_wave, "Graph")
        return
