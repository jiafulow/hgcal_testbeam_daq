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
bitbang = './sk2_sc_bitbang'
bitbang_ipbus = './sk2_sc_bitbang_ipbus'


# ______________________________________________________________________
if __name__ == '__main__':

    cmd = "%s" % (reset)
    print("$ %s" % cmd)
    subprocess.call(cmd, shell=True)

    cmd = "%s" % (scan)
    print("$ %s" % cmd)
    subprocess.call(cmd, shell=True)

    with open(hw_info) as f:
        for line in f.readlines():
            cmd = "%s %s" % (peek, line.strip())
            print("$ %s" % cmd)
            subprocess.call(cmd, shell=True)

    with open(hw_info) as f:
        for line in f.readlines():
            cmd = "%s %s 1" % (poke, line.strip())
            print("$ %s" % cmd)
            subprocess.call(cmd, shell=True)

    cmd = "%s" % (bitbang)
    print("$ %s" % cmd)
    subprocess.call(cmd, shell=True)

    cmd = "%s" % (bitbang_ipbus)
    print("$ %s" % cmd)
    subprocess.call(cmd, shell=True)
