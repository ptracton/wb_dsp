#! /usr/bin/env python3

"""
ram_image_hack.py

Ugly hack to get different RAM images loaded in the testbench for icarus.

"""


import re
import sys
import argparse

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description='RAM HACK')
    parser.add_argument("-D", "--debug",
                        help="Debug this script",
                        action="store_true")
    parser.add_argument("--simulation",
                        help="Which simulation to use",
                        required = True,
                        action="store")

    args = parser.parse_args()
    if args.debug:
        print(args)

    try:
        lines = open(args.simulation, "r").readlines()
    except:
        print ("Failed to read %s" % args.simulation)
        sys.exit(-1)

    try:
        out_file = open("hack.vh", "w")
    except:
        print ("Failed to open hack.vh")
        sys.exit(-1)
        
    for x in lines:
        y = re.search('ram_image', x, re.IGNORECASE)
        if y:
            out_file.write(x)
        z = re.search('channel0_adc_image', x, re.IGNORECASE)
        if z:
            out_file.write(x)
            
    out_file.close()
    
    sys.exit(0)
