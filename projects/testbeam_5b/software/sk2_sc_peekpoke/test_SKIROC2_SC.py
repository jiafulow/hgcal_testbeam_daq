#!/usr/bin/env python

"""
This python script calls the C programs (peek, poke) for all the
registers.
"""

import os
import subprocess

hw_info = 'SKIROC2_SC_hw.txt'
reset = './sk2_sc_reset'
scan = './sk2_sc_scan'
peek = './sk2_sc_peek'
poke = './sk2_sc_poke'


# ______________________________________________________________________
if __name__ == '__main__':

    print("Testing %s" % reset)
    subprocess.call("%s" % (reset), shell=True)

    print("Testing %s" % scan)
    subprocess.call("%s" % (scan), shell=True)

    print("Testing %s" % peek)

    with open(hw_info) as f:
        for line in f.readlines():
            subprocess.call("%s %s" % (peek, line.strip()), shell=True)

    print("Testing %s" % poke)

    with open(hw_info) as f:
        for line in f.readlines():
            subprocess.call("%s %s 1" % (poke, line.strip()), shell=True)
