#!/usr/bin/env python

import unittest

import subprocess

def mystrip(s):
    # Remove white space
    return s.replace(" ","").replace("\n","")

class MyTest(unittest.TestCase):
    """My dumb unit test"""

    def grep_txn(self, s):
        pattern = "Dump txn:\n"
        m = s.find(pattern)
        if m:
            s = s[m+len(pattern):]
        return s

    def call_write_txn(self, args):
        # Call the executable with stdout pipe
        prog = "./sk2_sc_write_txn"
        command = [prog,] + args.split(" ")

        p = subprocess.Popen(command, stdout=subprocess.PIPE)
        output = p.communicate()[0]
        return output

    def call_read_txn(self, args):
        # Call the executable with stdout pipe
        prog = "./sk2_sc_read_txn"
        command = [prog,] + args.split(" ")

        p = subprocess.Popen(command, stdout=subprocess.PIPE)
        output = p.communicate()[0]
        return output

    def test_write_txn_0(self):
        # Test write transaction
        args = "0"
        result = """Request:
  addr=0xDEADBEEF, nwords=0, words=
Dump txn:
0x0EEF001F

Response:
  addr=0x00000EEF, nwords=0
Dump txn:
0x0EEF0010
"""
        output = self.call_write_txn(args)
        self.assertEqual(mystrip(result), mystrip(output))

    def test_write_txn_4(self):
        # Test write transaction
        args = "4 0x12 0x34 0x99 0xFF"
        result = """Request:
  addr=0xDEADBEEF, nwords=4, words=
  0x00000012 0x00000034 0x00000099 0x000000FF
Dump txn:
0x0EEF041F
0x00000012
0x00000034
0x00000099
0x000000FF

Response:
  addr=0x00000EEF, nwords=4
Dump txn:
0x0EEF0410
"""
        output = self.call_write_txn(args)
        self.assertEqual(mystrip(result), mystrip(output))

    def test_read_txn_0(self):
        # Test read transaction
        args = "0"
        result = """Request:
  addr=0xDEADBEEF, nwords=0
Dump txn:
0x0EEF000F

Response:
  addr=0x00000EEF, nwords=0, words=
Dump txn:
0x0EEF0000
"""
        output = self.call_read_txn(args)
        self.assertEqual(mystrip(result), mystrip(output))

    def test_read_txn_4(self):
        # Test read transaction
        args = "4"
        result = """Request:
  addr=0xDEADBEEF, nwords=4
Dump txn:
0x0EEF040F

Response:
  addr=0x00000EEF, nwords=4, words=
  0x00000000 0x00000001 0x00000002 0x00000003
Dump txn:
0x0EEF0400
0x00000000
0x00000001
0x00000002
0x00000003
"""
        output = self.call_read_txn(args)
        self.assertEqual(mystrip(result), mystrip(output))

# ______________________________________________________________________
if __name__ == '__main__':
    unittest.main()
