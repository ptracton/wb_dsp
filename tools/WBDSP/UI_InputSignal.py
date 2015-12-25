#! /usr/bin/env python3

from PyQt4 import QtGui



class UI_InputSignal(QtGui.QDialog):
    """
    """

    def __init__(self, parent=None):
        super(UI_InputSignal, self).__init__(parent)
        vbox = QtGui.QVBoxLayout()
        label = QtGui.QLabel("Input Signal")
        vbox.addWidget(label)

        self.SignalTypeLabel = QtGui.QLabel("Signal Type:")
        self.SignalTypeHBox = QtGui.QHBoxLayout()
        self.SignalTypeComboBox = QtGui.QComboBox()
        self.SignalTypeComboBox.addItem("sine")
        self.SignalTypeComboBox.addItem("square")
        self.SignalTypeComboBox.addItem("triangle")
        self.SignalTypeComboBox.addItem("random")
        self.SignalTypeHBox.addWidget(self.SignalTypeLabel)
        self.SignalTypeHBox.addWidget(self.SignalTypeComboBox)
        vbox.addLayout(self.SignalTypeHBox)

        self.AmplitudeLabel = QtGui.QLabel("Amplitude:")
        self.AmplitudeInput = QtGui.QLineEdit("0.75")
        self.AmplitudeHBox = QtGui.QHBoxLayout()
        self.AmplitudeHBox.addWidget(self.AmplitudeLabel)
        self.AmplitudeHBox.addWidget(self.AmplitudeInput)
        vbox.addLayout(self.AmplitudeHBox)

        self.FrequencyLabel = QtGui.QLabel("Frequency:")
        self.FrequencyInput = QtGui.QLineEdit("1000")
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

        self.GraphPushButton = QtGui.QPushButton("Graph It")
        vbox.addWidget(self.GraphPushButton)
       
        self.setLayout(vbox)
        return


