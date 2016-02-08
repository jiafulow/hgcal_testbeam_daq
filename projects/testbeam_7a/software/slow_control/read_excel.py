#!/usr/bin/env python

import xlrd
import sys
import re

# ______________________________________________________________________
# Excel configurations
excel_name = 'Skiroc2_chip.xls'
sheet_name = u'SKIROC2 Slow Control Register'

row_first, row_last = 5, 73
col_first, col_last = 'B', 'F'

ncolumns = 5
use_pmr_dvalues = True

short_names = [
  'EN_PA'                               ,
  'PP_PA'                               ,
  'GC_PA_Comp'                          ,
  'GC_PA_Fdbck'                         ,
  'PA_ch/PA_In_calib_ch/PA_I_leakage_ch',
  'EN_SS_G1'                            ,
  'PP_SS_G1'                            ,
  'EN_SS_G10'                           ,
  'PP_SS_G10'                           ,
  'EN_FS'                               ,
  'PP_FS'                               ,
  'GC_FS_time_const'                    ,
  'EN_SCA'                              ,
  'PP_SCA'                              ,
  'GC_SCA_backup_sel'                   ,
  'EN_SCA_backup'                       ,
  'PP_SCA_backup'                       ,
  'GC_SCA_bias_sel'                     ,
  'EN_Output_OTA'                       ,
  'PP_Output_OTA'                       ,
  'EN_Probe_OTA'                        ,
  'PP_Probe_OTA'                        ,
  'EN_DAC_4bit'                         ,
  'PP_DAC_4bit'                         ,
  'EN_Trigger'                          ,
  'PP_Trigger'                          ,
  'DA_ch'                               ,
  'TM_ch'                               ,
  'EN_Delay_Trigger'                    ,
  'PP_Delay_Trigger'                    ,
  'GC_Delay_Trigger'                    ,
  'GC_Auto_Gain'                        ,
  'GC_Forced_Gain'                      ,
  'GC_Bypass_Latch'                     ,
  'EC_ADC_Test_sel'                     ,
  'PP_Gain_Select_Discri'               ,
  'EN_Gain_Select_Discri'               ,
  'EN_ADC_Discri'                       ,
  'PP_ADC_Discri'                       ,
  'EN_Bandgap'                          ,
  'PP_Bandgap'                          ,
  'EN_DAC_10bit_Dual'                   ,
  'PP_DAC_10bit_Dual'                   ,
  'GC_DAC0_Trigger'                     ,
  'GC_DAC1_Gain_Select'                 ,
  'EN_TDC_Ramp'                         ,
  'PP_TDC_Ramp'                         ,
  'GC_TDC_Ramp_Comp'                    ,
  'GC_TDC_Ramp_Slope'                   ,
  'EN_ADC_Ramp'                         ,
  'PP_ADC_Ramp'                         ,
  'EC_ADC_Ramp_Ext_Sel'                 ,
  'GC_ADC_Ramp_Comp'                    ,
  'GC_ADC_Ramp_Slope'                   ,
  'GC_TDC_On'                           ,
  'GC_Flag_TDC_Ext_Sel'                 ,
  'GC_Flag_TDC_Ext_Forced'              ,
  'EC_TDC_Ramp_Ext_Sel'                 ,
  'GC_Chip_ID'                          ,
  'EC_Trig_Ext_Sel'                     ,
  'EC_Trig_Out_EN'                      ,
  'PP_LVDS_rec'                         ,
  'EC_End_ReadOut'                      ,
  'EC_Start_ReadOut'                    ,
  'EC_ChipSat'                          ,
  'EC_TransmitOn2'                      ,
  'EC_TransmitOn1'                      ,
  'EC_Dout2'                            ,
  'EC_Dout1'                            ,
]

pmr_dvalues = [
  0x1,
  0x1,
  0x7,
  0xf,
  0x0,
  0x1,
  0x1,
  0x1,
  0x1,
  0x1,
  0x1,
  0x0,
  0x1,
  0x1,
  0x0,
  0x1,
  0x1,
  0x0,
  0x1,
  0x1,
  0x1,
  0x1,
  0x1,
  0x1,
  0x0,
  0x0,
  0x1,
  0x0,
  0x0,
  0x0,
  0x7,
  0x1,
  0x0,
  0x0,
  0x0,
  0x1,
  0x1,
  0x1,
  0x1,
  0x1,
  0x1,
  0x1,
  0x1,
  0x3FF,
  0x3FF,
  0x1,
  0x1,
  0x0,
  0x1,
  0x1,
  0x1,
  0x0,
  0x0,
  0x0,
  0x1,
  0x0,
  0x0,
  0x0,
  0xFF,
  0x1,
  0x1,
  0x1,
  0x1,
  0x1,
  0x1,
  0x1,
  0x1,
  0x1,
  0x1,
]
assert(len(short_names) == len(pmr_dvalues))

# ______________________________________________________________________
# Slow control configurations

slow_control_nbits = 616
slow_control_nwords = (slow_control_nbits + 31) / 32

# ______________________________________________________________________
# Export slow control to C

c_file = 'SKIROC2_SC_hw.h'
c_file_include = 'SKIROC2_SC.h'
c_file_define = '_SKIROC2_SC_HW_H_'
c_file_info = 'SKIROC2_SC_hw.txt'

# ______________________________________________________________________
# Read Excel

def i_row(i):
  return i - 1

def j_col(a):
  return ord(a.upper()) - 65

def read_excel(**kwds):
  """Extract data from the Excel file"""

  verbose = kwds.pop('verbose', False)

  # Open the Excel file
  book = xlrd.open_workbook(excel_name)
  print "The number of worksheets is", book.nsheets
  print "Worksheet name(s):", book.sheet_names()

  # Get the Excel sheet
  sheet = book.sheet_by_name(sheet_name)
  print sheet.name, sheet.nrows, sheet.ncols

  data = []

  # Make sure the no of short names matches with the no of rows
  assert(len(short_names) == row_last - row_first + 1)

  # Make sure the no of expected columns matches with the no of columns
  assert(ncolumns == ord(col_last) - ord(col_first) + 1)

  for i in range(sheet.nrows):
    if i_row(row_first) <= i <= i_row(row_last):

      # Make sure the no of columns is correct
      row = sheet.row(i)
      assert(len(row) == sheet.ncols)

      row = []
      row.append(short_names[i - i_row(row_first)])

      for j, (value, typ) in enumerate(zip(sheet.row_values(i), sheet.row_types(i))):
        if j_col(col_first) <= j <= j_col(col_last):
          if isinstance(value, unicode):
            value = value.encode('utf8')
          if use_pmr_dvalues:
            if j == j_col(col_last):
              value = "{0:b}".format(pmr_dvalues[i - i_row(row_first)])
          row.append(value)

      # Make sure we get all the columns
      assert(len(row) == ncolumns + 1)

      data.append(row)

  # Make sure we get all the rows
  assert(len(short_names) == len(data))

  if verbose:
    for d in data:
      print d
  return data

# ______________________________________________________________________
# Parse data

# This scary looking regex finds the default value "[0-1]+" that might
# be surrounded by "64 x" and "(blah blah)"
regex_dvalue = re.compile(r'(64\s*x)?\s*([01 ]+)\s*?(\(.*?\))?.*')
def parse_as_tuple(line):
  name = line[0]
  nbits = line[2]
  subaddr = line[4]
  dvalue = line[5]
  nchannels = 1

  # Parse
  nbits = int(nbits)
  subaddr = int(subaddr)
  if isinstance(dvalue, float):
    dvalue = str(int(dvalue))
  if name.endswith("_ch"):
    nchannels = 64

  m = regex_dvalue.match(dvalue)
  if m:
    dvalue = m.group(2)
    if ' ' in dvalue:
      dvalue = dvalue.replace(' ', '')
    dvalue = int(dvalue, base=2)
  else:
    raise Exception("Failed to parse dvalue: %s" % dvalue)
  return (name, nbits, subaddr, dvalue, nchannels)

def pretty_print_tuple(t):
  return "({0:40s}, {1:4d}, {2:4d}, {3:4d}, {4:4d})".format("\""+t[0]+"\"", t[1], t[2], t[3], t[4])

def parse_data(data, **kwds):
  """Parse the Excel data as tuples"""

  verbose = kwds.pop('verbose', False)

  tuples = []

  # Parse data
  for line in data:
    t = parse_as_tuple(line)
    tuples.append(t)

  if verbose:
    for t in tuples:
      print pretty_print_tuple(t)
  return tuples

# ______________________________________________________________________
# Check for errors

def check_for_errors_in_type(reg):
  for r in reg:
    if len(r) != 5:
      raise Exception("Tuple length %d is not 5" % len(r))

    (name, nbits, subaddr, dvalue, nchannels) = r
    if type(name) != str or type(nbits) != int or type(subaddr) != int or type(dvalue) != int or type(nchannels) != int:
      raise Exception("Type check failed: %s" % repr(r))

def check_for_errors_in_name(reg):
  d = set()
  for r in reg:
    (name, nbits, subaddr, dvalue, nchannels) = r
    d.add(name)

  if len(d) != len(reg):
    raise Exception("The names are not unique!")

def check_for_errors_in_nbits(reg):
  n = 0
  for r in reg:
    (name, nbits, subaddr, dvalue, nchannels) = r
    if nbits == 0:
      raise Exception("The number of bits is zero")
    n += nbits

  if n != slow_control_nbits:
    raise Exception("The total number of bits %d does not match %d" % (n, slow_control_nbits))

def check_for_errors_in_subaddr(reg):
  old_nbits = 0
  old_subaddr = 0
  for i, r in enumerate(reg):
    (name, nbits, subaddr, dvalue, nchannels) = r

    if i == 0:
      if subaddr != 0:
        raise Exception("First subaddr is not 0")
    else:
      if subaddr != old_subaddr + old_nbits:
        raise Exception("Subaddr %d does not match old_subaddr+old_nbits %d+%d" % (subaddr, old_subaddr, old_nbits))

    old_nbits = nbits
    old_subaddr = subaddr

def check_for_errors_in_dvalue(reg):
  for r in reg:
    (name, nbits, subaddr, dvalue, nchannels) = r
    nbits_per_channel = nbits / nchannels

    if not (0 <= dvalue < (1<<nbits)):
      raise Exception("Default value %d requires more than %d bits" % (dvalue, nbits_per_channel))

def check_for_errors_in_nchannels(reg):
  for r in reg:
    (name, nbits, subaddr, dvalue, nchannels) = r

    if nbits % nchannels != 0:
      raise Exception("nbits %d is not divisible by nchannels %d" % (nbits, nchannels))

    if nchannels not in [1, 64]:
      raise Exception("nchannels %d is neither 1 nor 64" % nchannels)

    if nchannels == 64:
      if not name.endswith("_ch"):
        raise Exception("When nchannels=64, name %s does not end with '_ch'" % name)

def check_for_errors_in_packed_register(reg):
  for r in reg:
    (name, nbits, subaddr, dvalue, nchannels) = r

    if '/' in name:
      pack = name.split('/')
      if ((nbits / nchannels) % len(pack)) != 0:
        raise Exception("nbits %d is not divisible by nchannels and pack size")

def check_for_errors(reg):
  """Check for all the above errors"""

  check_for_errors_in_type(reg)
  check_for_errors_in_name(reg)
  check_for_errors_in_nbits(reg)
  check_for_errors_in_subaddr(reg)
  check_for_errors_in_dvalue(reg)
  check_for_errors_in_nchannels(reg)
  check_for_errors_in_packed_register(reg)
  return

# ______________________________________________________________________
# Export slow control to C

# Generate C code "{NAME, NBITS, SUBADDR, DEFAULT_VAL}"
def make_lut_string(name, nbits, subaddr, dvalue):
    lut_string = '    {{"{0}", {1}, {2}, {3}}},'.format(name, nbits, subaddr, dvalue)
    return lut_string

# Generate plain text "{NAME}"
def make_info_string(name):
    info_string = '    "{0}",'.format(name)
    return info_string

def export_to_c(reg):
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
    #  print unpacked_names, unpacked_dvalues


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
  s = '    {{{0}, {1}, {2}, {3}}}'.format('NULL', 0, 0, 0)
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
  s = '#ifndef {0}\n#define {0}\n\n#include "{1}"\n'.format(c_file_define, c_file_include)
  writeme.insert(0, s)
  s = '\n#endif  // {0}'.format(c_file_define)
  writeme.append(s)

  with open(c_file, 'w') as f:
    f.write('\n'.join(writeme))
  print "[INFO] Wrote C file: %s" % c_file

  # Write out the info
  writeme = []
  for s in info_entries:
    # Extract the name
    m = re.match('    "(\w+)",', s)
    assert(m)
    writeme.append(m.group(1))
  with open(c_file_info, 'w') as f:
    f.write('\n'.join(writeme))
  print "[INFO] Wrote txt file: %s" % c_file_info
  return


# ______________________________________________________________________
if __name__ == "__main__":

  verbose = False
  if "-v" in sys.argv:
    verbose = True

  data = read_excel(verbose=verbose)

  slow_control = parse_data(data, verbose=verbose)

  check_for_errors(slow_control)

  export_to_c(slow_control)
