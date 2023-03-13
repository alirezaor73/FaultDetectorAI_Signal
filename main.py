# This Python file uses the following encoding: utf-8
import sys
import pandas as pd
import numpy as np
import plotly.express as px
import matplotlib.pyplot as plt
import plotly.graph_objects as go

#import qrc

from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtCore import Slot , QObject , QUrl
#from PySide2.Qt import *
#from PySide2.QtQuick import *



class SetFile(QObject):

    def __init__(self):
        QObject.__init__(self)

    @Slot(str)
    def fileToBackend(self, name):
        if name:
            #read the data
            df = pd.read_csv(name)
            acc = df[df.columns[1]].values.tolist()


            #g to m/s**2
            for i in range(len(acc)):
                acc[i] = acc[i]*9.81



            #signal specifications
            time_step = 1/5
            samp_freq = 50000
            num_samp = int(samp_freq/time_step)
            fstep = samp_freq/num_samp
            time_vec = np.arange (0, 5, 5/num_samp)
            f = (1/5) * np.arange(num_samp)


            #acc
            A_sig_fft = np.fft.fft(acc,num_samp)
            A_fft = np.abs(A_sig_fft)/num_samp
            A_f_plot = f[0:int((num_samp/2))]
            A_mag_plot = 2*A_fft[0:int((num_samp/2))]
            A_mag_plot[0] = A_mag_plot[0]/2






            def fig_from_df(a,b):
                 fig = go.Figure()
                 for col in df.columns:
                           fig.add_trace(go.Scatter(x = a,y = b,name= col ))
                 return fig

            fig1 = fig_from_df(A_f_plot,A_mag_plot )
            fig1.write_html('file.html', full_html=False ,include_plotlyjs='cdn')




if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    setFile = SetFile()
    engine.rootContext().setContextProperty('backend', setFile)
#    qml_file = Path(__file__).resolve().parent / "./main.qml"
    engine.load(QUrl("main.qml"))
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
