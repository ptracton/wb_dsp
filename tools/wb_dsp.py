#! /usr/bin/env python3

import logging
import sys

from PyQt4 import QtGui

import WBDSP

if __name__ == "__main__":

    log_file_name = "default.log"
    logging.basicConfig(filename=log_file_name,
                        level=logging.DEBUG,
                        format='%(asctime)s,%(levelname)s,%(message)s',
                        datefmt='%m/%d/%Y %I:%M:%S %p')
    logging.info("Program Started")
    
    print ("WB DSP")
    app = QtGui.QApplication(sys.argv)
    gui = WBDSP.UI.UI()
    gui.show()
    app.exec_()
