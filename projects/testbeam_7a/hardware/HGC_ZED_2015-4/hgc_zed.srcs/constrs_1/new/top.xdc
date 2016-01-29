#-------------------------------------------------------------------------------
# FPGA Bank VCC  Schematic      FMC_LA        ThisDesignPins
#-------------------------------------------------------------------------------
# N19  34   2V5  FMC_LA01CC_P   LA01CC_P      data_out_to_pins_p[0]
# N20  34   2V5  FMC_LA01CC_N   LA01CC_N      data_out_to_pins_n[0]
# P17  34   2V5  FMC_LA02_P     LA02_P        M_RXTX_DATA_P[1]
# P18  34   2V5  FMC_LA02_N     LA02_N        M_RXTX_DATA_N[1]
# N22  34   2V5  FMC_LA03_P     LA03_P        M_RXTX_DATA_P[2]
# P22  34   2V5  FMC_LA03_N     LA03_N        M_RXTX_DATA_N[2]
# M21  34   2V5  FMC_LA04_P     LA04_P        M_RXTX_DATA_P[3]
# M22  34   2V5  FMC_LA04_N     LA04_N        M_RXTX_DATA_N[3]
# J18  34   2V5  FMC_LA05_P     LA05_P        M_RXTX_DATA_P[4]
# K18  34   2V5  FMC_LA05_N     LA05_N        M_RXTX_DATA_N[4]
# L21  34   2V5  FMC_LA06_P     LA06_P        M_RXTX_DATA_P[5]
# L22  34   2V5  FMC_LA06_N     LA06_N        M_RXTX_DATA_N[5]
# T16  34   2V5  FMC_LA07_P     LA07_P        M_RXTX_DATA_P[6]
# T17  34   2V5  FMC_LA07_N     LA07_N        M_RXTX_DATA_N[6]
# J21  34   2V5  FMC_LA08_P     LA08_P        M_RXTX_DATA_P[7]
# J22  34   2V5  FMC_LA08_N     LA08_N        M_RXTX_DATA_N[7]
# M19  34   2V5  FMC_LA00_CC_P  LA00_CC_P     clk_out_ref_p
# M20  34   2V5  FMC_LA00_CC_N  LA00_CC_N     clk_out_ref_n    
#
set_property PACKAGE_PIN N19 [get_ports {data_out_to_pins_p[0]}]
set_property PACKAGE_PIN N20 [get_ports {data_out_to_pins_n[0]}]
set_property PACKAGE_PIN M19 [get_ports clk_out_ref_p]
set_property PACKAGE_PIN M20 [get_ports clk_out_ref_n]
#
# J20  34   2V5  FMC_LA16_P     LA16_P        M_RXTX_CTRL_P[0]
# K21  34   2V5  FMC_LA16_N     LA16_N        M_RXTX_CTRL_N[0]
# B19  35   2V5  FMC_LA17_CC_P  LA17_CC_P     M_RXTX_CTRL_P[1] #Bank35
# B20  35   2V5  FMC_LA17_CC_N  LA17_CC_N     M_RXTX_CTRL_N[1] #Bank35
# R19  34   2V5  FMC_LA10_P     LA10_P        M_RXTX_CTRL_P[2]
# T19  34   2V5  FMC_LA10_N     LA10_N        M_RXTX_CTRL_N[2]
# N17  34   2V5  FMC_LA11_P     LA11_P        data_in_from_pins_p[0]
# N18  34   2V5  FMC_LA11_N     LA11_N        data_in_from_pins_n[0]
# P20  34   2V5  FMC_LA12_P     LA12_P        M_RXTX_CTRL_P[4]
# P21  34   2V5  FMC_LA12_N     LA12_N        M_RXTX_CTRL_N[4]
# L17  34   2V5  FMC_LA13_P     LA13_P        M_RXTX_CTRL_P[5]
# M17  34   2V5  FMC_LA13_N     LA13_N        M_RXTX_CTRL_N[5]
# K19  34   2V5  FMC_LA14_P     LA14_P        M_RXTX_CTRL_P[6]
# K20  34   2V5  FMC_LA14_N     LA14_N        M_RXTX_CTRL_N[6]
# J16  34   2V5  FMC_LA15_P     LA15_P        M_RXTX_CTRL_P[7]
# J17  34   2V5  FMC_LA15_N     LA15_N        M_RXTX_CTRL_N[7]
# D20  35   2V5  FMC_LA18_CC_P  LA18_CC_P     M_REF_CLK_P      #Bank35
# C20  35   2V5  FMC_LA18_CC_N  LA18_CC_N     M_REF_CLK_N      #Bank35
#
set_property PACKAGE_PIN N17 [get_ports {data_in_from_pins_p[0]}]
set_property PACKAGE_PIN N18 [get_ports {data_in_from_pins_n[0]}]
#
#set_property IOSTANDARD LVCMOS25 [get_ports -filter { IOBANK == 34 }]
#set_property IOSTANDARD LVCMOS25 [get_ports -filter { IOBANK == 35 }]
#
#########################################################
## LED constraints #
#########################################################
#set_property IOSTANDARD LVCMOS33 [get_ports {LED_OUT[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED_OUT[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED_OUT[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED_OUT[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED_OUT[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED_OUT[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED_OUT[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED_OUT[0]}]
#set_property PACKAGE_PIN U14 [get_ports {LED_OUT[7]}]
#set_property PACKAGE_PIN U19 [get_ports {LED_OUT[6]}]
#set_property PACKAGE_PIN W22 [get_ports {LED_OUT[5]}]
#set_property PACKAGE_PIN V22 [get_ports {LED_OUT[4]}]
#set_property PACKAGE_PIN U21 [get_ports {LED_OUT[3]}]
#set_property PACKAGE_PIN U22 [get_ports {LED_OUT[2]}]
#set_property PACKAGE_PIN T21 [get_ports {LED_OUT[1]}]
#set_property PACKAGE_PIN T22 [get_ports {LED_OUT[0]}]
#########################################################
## Switch constraints #
#########################################################
#set_property IOSTANDARD LVCMOS25 [get_ports {SW_IN[7]}]
#set_property IOSTANDARD LVCMOS25 [get_ports {SW_IN[6]}]
#set_property IOSTANDARD LVCMOS25 [get_ports {SW_IN[5]}]
#set_property IOSTANDARD LVCMOS25 [get_ports {SW_IN[4]}]
#set_property IOSTANDARD LVCMOS25 [get_ports {SW_IN[3]}]
#set_property IOSTANDARD LVCMOS25 [get_ports {SW_IN[2]}]
#set_property IOSTANDARD LVCMOS25 [get_ports {SW_IN[1]}]
#set_property IOSTANDARD LVCMOS25 [get_ports {SW_IN[0]}]
#set_property PACKAGE_PIN M15 [get_ports {SW_IN[7]}]
#set_property PACKAGE_PIN H17 [get_ports {SW_IN[6]}]
#set_property PACKAGE_PIN H18 [get_ports {SW_IN[5]}]
#set_property PACKAGE_PIN H19 [get_ports {SW_IN[4]}]
#set_property PACKAGE_PIN F21 [get_ports {SW_IN[3]}]
#set_property PACKAGE_PIN H22 [get_ports {SW_IN[2]}]
#set_property PACKAGE_PIN G22 [get_ports {SW_IN[1]}]
#set_property PACKAGE_PIN F22 [get_ports {SW_IN[0]}]