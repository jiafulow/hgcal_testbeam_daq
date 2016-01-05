#!/usr/bin/env python

"""
This python script writes the C header file that defines the SKIROC2
Slow Control Register by specifying the offset and mask.
"""

from define_SKIROC2_SC import *

import re

hw_file = 'SKIROC2_SC_hw.h'
hw_include = 'SKIROC2_SC.h'
hw_define = 'SKIROC2_SC_HW_H_'
hw_info = 'SKIROC2_SC_hw.txt'

# ______________________________________________________________________
# Generate C code "{NAME, NBITS, SUBADDR, DEFAULT_VAL}"
def make_lut_string(name, nbits, subaddr, dvalue):
    lut_string = '    {{"{0}", {1}, {2}, {3}}},'.format(name, nbits, subaddr, dvalue)
    return lut_string

# Generate plain text "{NAME}"
def make_info_string(name):
    info_string = '    "{0}",'.format(name)
    return info_string

# Generate the hardware definitions for SKIROC2
def generate_definitions(reg):
    lut_entries = []
    info_entries = []

    # Loop over all the registers
    for r in reg:
        (name, nbits, subaddr, dvalue, nchannels) = r

        # Divide nbits by nchannels
        nbits /= nchannels

        # Unpack names
        if '/' in name:
            unpacked_names = name.split('/')

            # Divide nbits by pack size
            nbits /= len(unpacked_names)

            # Split default value by nbits
            # Assume LSB=first ... MSB=last
            unpacked_dvalues = []
            for i in xrange(len(unpacked_names)):
                mask_nbits = (1 << nbits) - 1
                unpacked_dvalues.append((dvalue >> (i * nbits)) & mask_nbits)

        else:
            unpacked_names = [name]
            unpacked_dvalues = [dvalue]

        #if '/' in name:
        #    print unpacked_names, unpacked_dvalues


        # Loop over channels and unpacked names
        for ch in xrange(nchannels):

            for name2, dvalue2 in zip(unpacked_names, unpacked_dvalues):
                # Update name
                if nchannels > 1:
                    name2 += ('%02d' % ch)
                this_name = name2.upper()

                # Update default value
                this_dvalue = dvalue2

                # Make LUT entry
                lut_entry = make_lut_string(this_name, nbits, subaddr, this_dvalue)
                lut_entries.append(lut_entry)

                # Keep the register name
                info_entry = make_info_string(this_name)
                info_entries.append(info_entry)

                # Update subaddr
                subaddr += nbits


    # Write out the lookup table
    writeme = []
    s = '#define LOOKUP_TABLE_SIZE {0}'.format(len(lut_entries))
    writeme.append(s)
    s = 'static const item_t lookup_table[LOOKUP_TABLE_SIZE+1] = {  // plus one NULL entry'
    writeme.append(s)
    for s in sorted(lut_entries):  # sorted to allow binary search
        writeme.append(s)
    s = '    {{{0}, {1}, {1}, {1}}}'.format('NULL', 0, 0, 0)
    writeme.append(s)
    s = '};'
    writeme.append(s)
    s = ''
    writeme.append(s)

    s = 'static const char * lookup_table_names_ordered[LOOKUP_TABLE_SIZE+1] = {  // plus one NULL entry'
    writeme.append(s)
    for s in info_entries:
        writeme.append(s)
    s = '    {0}'.format('NULL')
    writeme.append(s)
    s = '};'
    writeme.append(s)

    # Add wrapper
    s = '#ifndef {0}\n#define {0}\n\n#include "{1}"\n'.format(hw_define, hw_include)
    writeme.insert(0, s)
    s = '\n#endif  // {0}'.format(hw_define)
    writeme.append(s)

    with open(hw_file, 'w') as f:
        f.write('\n'.join(writeme))

    # Write out the info
    writeme = []
    for s in info_entries:
        # Extract the name
        m = re.match('    "(\w+)",', s)
        assert(m)
        writeme.append(m.group(1))
    with open(hw_info, 'w') as f:
        f.write('\n'.join(writeme))
    return

# ______________________________________________________________________
if __name__ == '__main__':

    print("Generate definitions")

    generate_definitions(skiroc2_slow_control_register)

    print(">> Definitions written to %s" % hw_file)
