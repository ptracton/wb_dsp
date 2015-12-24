#! /usr/bin/env python3
"""
Top Level GUI for wb_dsp.py program
"""

from PyQt4 import QtCore
from PyQt4 import QtGui

import UI_central

class UI(QtGui.QMainWindow):

    '''
    Our top level UI widget
    '''

    def __init__(self, configuration=None, parent=None):
        super(UI, self).__init__(parent)
        self.statusBar().showMessage('Started ')

        self.config_file = configuration
        self.central = UI_central.UI_central()

        menubar = self.menuBar()
        fileMenu = menubar.addMenu('&File')
        helpMenu = menubar.addMenu('&Help')

        exitAction = QtGui.QAction(
            QtGui.QIcon('application-exit.png'),
            '&Exit', self)
        exitAction.setShortcut('Ctrl+Q')
        exitAction.setStatusTip('Exit application')
        exitAction.triggered.connect(QtGui.qApp.quit)
        fileMenu.addAction(exitAction)

        aboutAction = QtGui.QAction('&About', self)
        aboutAction.setShortcut('Ctrl+A')
        aboutAction.setStatusTip('About')
        aboutAction.triggered.connect(self.aboutAction)
        helpMenu.addAction(aboutAction)

        self.toolbar = self.addToolBar('Exit')
        self.toolbar.addAction(exitAction)
        self.toolbar.addAction(aboutAction)

#        self.connect(self.central.add_button,
#                     QtCore.SIGNAL("clicked()"),
#                     self.add_button_clicked)
        self.setCentralWidget(self.central)
        self.setWindowTitle('WishBone (WB)  DSP')
        self.show()

    def aboutAction(self):
#        about = UI_about.UI_about()
#        about.exec_()
        return
        
