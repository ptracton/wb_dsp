#! /usr/bin/env python3

from PyQt4 import QtGui
import matplotlib
import matplotlib.gridspec as gridspec
from matplotlib.backends.backend_qt4agg import FigureCanvasQTAgg


class QtMpl(FigureCanvasQTAgg):
    def __init__(self, parent):

        self.fig = matplotlib.figure.Figure()
        self.list_of_signals = []
        self.list_of_subplots = []
        self.sub_plot_number = 0
        self.grid_spec = gridspec.GridSpec(5, 1)
        
        #self.fig.gca().xaxis.set_major_formatter(
        #    mdates.DateFormatter('%m/%d/%Y'))
        #self.fig.gca().xaxis.set_major_locator(
        #    mdates.DayLocator())
        FigureCanvasQTAgg.__init__(self, self.fig)
        self.setParent(parent)

        #self.axes = self.fig.add_subplot(self.grid_spec[0])
        #self.axes = self.fig.add_subplot(111)
        # self.axes.set_ylabel("Y-Axis")
        # self.axes.set_xlabel("X-Axis")

        # we define the widget as expandable
        FigureCanvasQTAgg.setSizePolicy(self,
                                        QtGui.QSizePolicy.Expanding,
                                        QtGui.QSizePolicy.Expanding)
        # notify the system of updated policy
        FigureCanvasQTAgg.updateGeometry(self)

    def redraw(self):
        self.fig.canvas.draw()
        #self.fig.autofmt_xdate()

        return
        
    def addLine(self, x, y, title):

        self.axes.plot_date(x, y, label=title, ls='-')
        self.axes.legend()

        # http://stackoverflow.com/questions/4098131/matplotlib-update-a-plot

        self.fig.canvas.draw()
        self.fig.autofmt_xdate()
        return
        
    def addSignal(self, signal):

        #print (self.sub_plot_number)
        
        self.list_of_signals.append(signal)
        #print (len(self.list_of_signals))

        self.sub_plot_number = self.sub_plot_number + 1
        #self.grid_spec = gridspec.GridSpec(self.sub_plot_number, 1)
        subplot = self.fig.add_subplot(self.grid_spec[self.sub_plot_number])
        subplot.set_title("Signal %d" % (self.sub_plot_number-1))
        self.list_of_subplots.append(subplot)
        subplot.plot(signal.time, signal.data)
        #self.axes.plot(signal.time, signal.data)
        self.redraw()
        return
        
    def removeSignal(self):
        self.sub_plot_number = self.sub_plot_number - 1
        remove = self.list_of_subplots[-1]
        self.list_of_subplots.pop()
        self.list_of_signals.pop()
        self.fig.delaxes(remove)
        self.redraw()
        return
