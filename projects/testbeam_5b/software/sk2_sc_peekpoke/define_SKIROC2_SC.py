#!/usr/bin/env python

"""
This python script records the SKIROC2 Slow Control Register info:
  - register name
  - number of bits (all channels)
  - sub-address
  - default value (per channel)
  - number of channels
The info is currently entered by hand.
"""

skiroc2_slow_control_register_nbits = 616

skiroc2_slow_control_register_nwords = (skiroc2_slow_control_register_nbits + 31) / 32

skiroc2_slow_control_register = [
# Tuple format: (register name, number of bits, subaddress, default value, number of channels)
("EN_PA"                               ,   1,   0,          0b1,  1),
("PP_PA"                               ,   1,   1,          0b0,  1),
('GC_PA_Comp'                          ,   3,   2,        0b111,  1),
('GC_PA_Fdbck'                         ,   4,   5,       0b1111,  1),
('PA_ch/PA_In_calib_ch/PA_I_leakage_ch', 192,   9,        0b000, 64),
('EN_SS_G1'                            ,   1, 201,          0b1,  1),
('PP_SS_G1'                            ,   1, 202,          0b0,  1),
('EN_SS_G10'                           ,   1, 203,          0b1,  1),
('PP_SS_G10'                           ,   1, 204,          0b0,  1),
('EN_FS'                               ,   1, 205,          0b1,  1),
('PP_FS'                               ,   1, 206,          0b0,  1),
('GC_FS_time_const'                    ,   2, 207,         0b00,  1),
('EN_SCA'                              ,   1, 209,          0b1,  1),
('PP_SCA'                              ,   1, 210,          0b0,  1),
('GC_SCA_backup_sel'                   ,   1, 211,          0b0,  1),
('EN_SCA_backup'                       ,   1, 212,          0b1,  1),
('PP_SCA_backup'                       ,   1, 213,          0b0,  1),
('GC_SCA_bias_sel'                     ,   1, 214,          0b0,  1),
('EN_Output_OTA'                       ,   1, 215,          0b1,  1),
('PP_Output_OTA'                       ,   1, 216,          0b0,  1),
('EN_Probe_OTA'                        ,   1, 217,          0b1,  1),
('PP_Probe_OTA'                        ,   1, 218,          0b0,  1),
('EN_DAC_4bit'                         ,   1, 219,          0b1,  1),
('PP_DAC_4bit'                         ,   1, 220,          0b0,  1),
('EN_Trigger'                          ,   1, 221,          0b1,  1),
('PP_Trigger'                          ,   1, 222,          0b0,  1),
('DA_ch'                               , 256, 223,       0b0001, 64),
('TM_ch'                               ,  64, 479,          0b0, 64),
('EN_Delay_Trigger'                    ,   1, 543,          0b1,  1),
('PP_Delay_Trigger'                    ,   1, 544,          0b0,  1),
('GC_Delay_Trigger'                    ,   8, 545,   0b01110000,  1),
('GC_Auto_Gain'                        ,   1, 553,          0b1,  1),
('GC_Forced_Gain'                      ,   1, 554,          0b0,  1),
('GC_Bypass_Latch'                     ,   1, 555,          0b0,  1),
('EC_ADC_Test_sel'                     ,   1, 556,          0b0,  1),
('PP_Gain_Select_Discri'               ,   1, 557,          0b0,  1),
('EN_Gain_Select_Discri'               ,   1, 558,          0b1,  1),
('EN_ADC_Discri'                       ,   1, 559,          0b1,  1),
('PP_ADC_Discri'                       ,   1, 560,          0b0,  1),
('EN_Bandgap'                          ,   1, 561,          0b1,  1),
('PP_Bandgap'                          ,   1, 562,          0b0,  1),
('EN_DAC_10bit_Dual'                   ,   1, 563,          0b1,  1),
('PP_DAC_10bit_Dual'                   ,   1, 564,          0b0,  1),
('GC_DAC0_Trigger'                     ,  10, 565, 0b1111111111,  1),
('GC_DAC1_Gain_Select'                 ,  10, 575, 0b1111111111,  1),
('EN_TDC_Ramp'                         ,   1, 585,          0b1,  1),
('PP_TDC_Ramp'                         ,   1, 586,          0b0,  1),
('GC_TDC_Ramp_Comp'                    ,   1, 587,          0b0,  1),
('GC_TDC_Ramp_Slope'                   ,   1, 588,          0b1,  1),
('EN_ADC_Ramp'                         ,   1, 589,          0b1,  1),
('PP_ADC_Ramp'                         ,   1, 590,          0b0,  1),
('EC_ADC_Ramp_Ext_Sel'                 ,   1, 591,          0b0,  1),
('GC_ADC_Ramp_Comp'                    ,   1, 592,          0b0,  1),
('GC_ADC_Ramp_Slope'                   ,   1, 593,          0b0,  1),
('GC_TDC_On'                           ,   1, 594,          0b1,  1),
('GC_Flag_TDC_Ext_Sel'                 ,   1, 595,          0b0,  1),
('GC_Flag_TDC_Ext_Forced'              ,   1, 596,          0b0,  1),
('EC_TDC_Ramp_Ext_Sel'                 ,   1, 597,          0b0,  1),
('GC_Chip_ID'                          ,   8, 598,   0b11111111,  1),
('EC_Trig_Ext_Sel'                     ,   1, 606,          0b1,  1),
('EC_Trig_Out_EN'                      ,   1, 607,          0b1,  1),
('PP_LVDS_rec'                         ,   1, 608,          0b1,  1),
('EC_End_ReadOut'                      ,   1, 609,          0b1,  1),
('EC_Start_ReadOut'                    ,   1, 610,          0b1,  1),
('EC_ChipSat'                          ,   1, 611,          0b1,  1),
('EC_TransmitOn2'                      ,   1, 612,          0b1,  1),
('EC_TransmitOn1'                      ,   1, 613,          0b1,  1),
('EC_Dout2'                            ,   1, 614,          0b1,  1),
('EC_Dout1'                            ,   1, 615,          0b1,  1),
]


# ______________________________________________________________________
# Check for errors

def check_type(reg):
    """Check for type errors"""

    for r in reg:
        if len(r) != 5:
            raise Exception("Tuple length %d is not 5" % len(r))

        (name, nbits, subaddr, dvalue, nchannels) = r
        if type(name) != str or type(nbits) != int or type(subaddr) != int or type(dvalue) != int or type(nchannels) != int:
            raise Exception("Type check failed: %s" % repr(r))

def check_names(reg):
    """Check for name errors"""

    d = set()
    for r in reg:
        name = r[0]
        d.add(name)

    if len(d) != len(reg):
        raise Exception("The names are not unique!")
    return

def check_nbits(reg, nbits_chk):
    """Check for errors in number of bits"""

    n = 0
    for r in reg:
        nbits = r[1]
        if nbits == 0:
            raise Exception("The number of bits is zero")
        n += nbits

    if n != nbits_chk:
        raise Exception("The total number of bits %d does not match %d" % (n, chk))
    return

def check_subaddrs(reg):
    """Check for errors in sub-address"""

    old_nbits = 0
    old_subaddr = 0
    for i, r in enumerate(reg):
        nbits = r[1]
        subaddr = r[2]

        if i == 0:
            if subaddr != 0:
                raise Exception("First subaddr is not 0")
        else:
            if subaddr != old_subaddr + old_nbits:
                raise Exception("Subaddr %d does not match old_subaddr+old_nbits %d+%d" % (subaddr, old_subaddr, old_nbits))

        old_nbits = nbits
        old_subaddr = subaddr
    return

def check_dvalues(reg):
    """Check for errors in default value"""

    for r in reg:
        nbits = r[1]
        dvalue = r[3]
        nchannels = r[4]
        nbits_per_channel = nbits / nchannels

        if not (0 <= dvalue < (1<<nbits)):
            raise Exception("Default value %d requires more than %d bits" % (dvalue, nbits_per_channel))
    return

def check_nchannels(reg):
    """Check for errors in number of channels"""

    for r in reg:
        name = r[0]
        nbits = r[1]
        nchannels = r[4]

        if nbits % nchannels != 0:
            raise Exception("nbits %d is not divisible by nchannels %d" % (nbits, nchannels))

        if nchannels not in [1, 64]:
            raise Exception("nchannels %d is neither 1 nor 64" % nchannels)

        if nchannels == 64:
            if not name.endswith("_ch"):
                raise Exception("When nchannels=64, name %s does not end with '_ch'" % name)
    return

def check_packed_values(reg):
    """Check for errors in packed register"""

    for r in reg:
        name = r[0]
        nbits = r[1]
        nchannels = r[4]

        if '/' in name:
            pack = name.split('/')
            if ((nbits / nchannels) % len(pack)) != 0:
                raise Exception("nbits %d is not divisible by nchannels and pack size")

def check_for_errors(reg, nbits):
    """Check for all the above errors"""

    check_type(reg)
    check_names(reg)
    check_nbits(reg, nbits)
    check_subaddrs(reg)
    check_dvalues(reg)
    check_nchannels(reg)
    check_packed_values(reg)
    return


# ______________________________________________________________________
if __name__ == '__main__':

    print("Check for errors")

    check_for_errors(skiroc2_slow_control_register, skiroc2_slow_control_register_nbits)

    print(">> No known errors")
