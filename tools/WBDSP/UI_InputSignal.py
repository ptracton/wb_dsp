#! /usr/bin/env python3

from PyQt4 import QtGui
import Signal


class UI_InputSignal(QtGui.QDialog):
    """
    """

    def __init__(self, parent=None):
        super(UI_InputSignal, self).__init__(parent)
        vbox = QtGui.QVBoxLayout()
        label = QtGui.QLabel("Input Signal")
        vbox.addWidget(label)

        self.Signal = Signal.Signal()

        self.StartTimeLabel = QtGui.QLabel("Start Time:")
        self.StartTimeInput = QtGui.QLineEdit("-1")
        self.StartTimeHBox = QtGui.QHBoxLayout()
        self.StartTimeHBox.addWidget(self.StartTimeLabel)
        self.StartTimeHBox.addWidget(self.StartTimeInput)
        vbox.addLayout(self.StartTimeHBox)

        self.EndTimeLabel = QtGui.QLabel("End Time:")
        self.EndTimeInput = QtGui.QLineEdit("1")
        self.EndTimeHBox = QtGui.QHBoxLayout()
        self.EndTimeHBox.addWidget(self.EndTimeLabel)
        self.EndTimeHBox.addWidget(self.EndTimeInput)
        vbox.addLayout(self.EndTimeHBox)
        
        self.SampleFrequencyLabel = QtGui.QLabel("Sample Frequency:")
        self.SampleFrequencyInput = QtGui.QLineEdit("1000")
        self.SampleFrequencyHBox = QtGui.QHBoxLayout()
        self.SampleFrequencyHBox.addWidget(self.SampleFrequencyLabel)
        self.SampleFrequencyHBox.addWidget(self.SampleFrequencyInput)
        vbox.addLayout(self.SampleFrequencyHBox)
        
        self.SignalTypeLabel = QtGui.QLabel("Signal Type:")
        self.SignalTypeHBox = QtGui.QHBoxLayout()
        self.SignalTypeComboBox = QtGui.QComboBox()
        self.SignalTypeComboBox.addItem("sine")
        self.SignalTypeComboBox.addItem("square")
        self.SignalTypeComboBox.addItem("triangle")
        self.SignalTypeHBox.addWidget(self.SignalTypeLabel)
        self.SignalTypeHBox.addWidget(self.SignalTypeComboBox)
        vbox.addLayout(self.SignalTypeHBox)

        self.AmplitudeLabel = QtGui.QLabel("Amplitude:")
        self.AmplitudeInput = QtGui.QLineEdit("0.75")
        self.AmplitudeHBox = QtGui.QHBoxLayout()
        self.AmplitudeHBox.addWidget(self.AmplitudeLabel)
        self.AmplitudeHBox.addWidget(self.AmplitudeInput)
        vbox.addLayout(self.AmplitudeHBox)

        self.FrequencyLabel = QtGui.QLabel("Signal Frequency:")
        self.FrequencyInput = QtGui.QLineEdit("10")
        self.FrequencyHBox = QtGui.QHBoxLayout()
        self.FrequencyHBox.addWidget(self.FrequencyLabel)
        self.FrequencyHBox.addWidget(self.FrequencyInput)
        vbox.addLayout(self.FrequencyHBox)

        self.PhaseLabel = QtGui.QLabel("Phase:")
        self.PhaseInput = QtGui.QLineEdit("0")
        self.PhaseHBox = QtGui.QHBoxLayout()
        self.PhaseHBox.addWidget(self.PhaseLabel)
        self.PhaseHBox.addWidget(self.PhaseInput)
        vbox.addLayout(self.PhaseHBox)

        self.DataLabel = QtGui.QLabel("Data Size:")
        self.DataInput = QtGui.QLineEdit("0")
        self.DataHBox = QtGui.QHBoxLayout()
        self.DataHBox.addWidget(self.DataLabel)
        self.DataHBox.addWidget(self.DataInput)
        vbox.addLayout(self.DataHBox)
        
        self.GraphPushButton = QtGui.QPushButton("Graph It")
        vbox.addWidget(self.GraphPushButton)
        self.MixSignalsPushButton = QtGui.QPushButton("Mix Signals")
        vbox.addWidget(self.MixSignalsPushButton)        
        self.RemovePushButton = QtGui.QPushButton("Remove Last Graph")
        vbox.addWidget(self.RemovePushButton)
        self.WriteDataPushButton = QtGui.QPushButton("Write File")
        vbox.addWidget(self.WriteDataPushButton)        
       
        self.setLayout(vbox)
        return


