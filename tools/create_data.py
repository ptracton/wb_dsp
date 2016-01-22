#! /usr/bin/env python3

import argparse
import json
import sys

import numpy as np

import WBDSP

class SignalData:
    
    def __init__(self, signal=None, start_address = None, data_width = None):
        self.signal = signal
        self.start_address = start_address
        self.data_width = data_width
        return
        

if __name__ == "__main__":
    print ("Create Data")
    parser = argparse.ArgumentParser(
        description='Create Data and Results for WB DSP')
    parser.add_argument("-D", "--debug",
                        help="Debug this script",
                        action="store_true")
    parser.add_argument("--json_file",
                        help = "JSON Configuration",
                        required = True,
                        action = "store")
    
    args = parser.parse_args()
    if args.debug:
        print(args)
    
    try:
        f = open(args.json_file, "r")
        json_data = json.load(f)
    except:
        print("Failed to load or read %s" % (args.json_file))
        sys.exit(-1)

    results_file = json_data["results_file"]
    try:
        result_file_handle = open(results_file, "w")
    except:
        print("Failed to open for writing %s" % (results_file))
        sys.exit(-1)

    channels_list = json_data["channels"]
    list_of_signals = []
    for channel in channels_list:
        channel_data = json_data[channel]
        print (channel_data["type"])
        current_signal = WBDSP.Signal.Signal(start_time = float(channel_data["start_time"]),
                                             end_time   = float(channel_data["end_time"]),
                                             signal_frequency= float(channel_data["signal_frequency"]),
                                             sample_frequency= float(channel_data["sample_frequency"]),
                                             amplitude= float(channel_data["amplitude"]),
                                             offset = float(channel_data["offset"])
                                         )
        
        if (channel_data["type"] == "sine"):
            current_signal.CreateSinusoid()
        elif (channel_data["type"] == "square"):
            current_signal.CreateSquare()
        elif (channel_data["type"] == "triangle"):
            current_signal.CreateSawTooth()

        current_signal_data = SignalData(signal = current_signal,
                                         start_address=int(channel_data["starting_address"]),
                                         data_width=int(channel_data["data_width"])
                                     )
        
        list_of_signals.append(current_signal_data)
        print (current_signal.data)
        del (current_signal)

        
    for signal in list_of_signals:
        print ("@%d" %(signal.start_address))
        for data in signal.signal.data.astype(dtype=np.uint8):
            print ("%d" %  data)

    result_file_handle.close()
    sys.exit(0)
