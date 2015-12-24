#! /usr/bin/env python3
'''
Central widget for WB DSP
'''

from PyQt4 import QtCore
from PyQt4 import QtGui

import QtMpl

class UI_central(QtGui.QDialog):

    '''
    Our top level UI widget
    '''

    def __init__(self, parent=None):
        super(UI_central, self).__init__(parent)
        vbox = QtGui.QVBoxLayout()
        self.graph = QtMpl.QtMpl(parent=None)
        vbox.addWidget(self.graph)
        self.setLayout(vbox)
        return
