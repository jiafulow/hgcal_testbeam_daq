################################################################################

# This XDC is used only for OOC mode of synthesis, implementation
# This constraints file contains default clock frequencies to be used during
# out-of-context flows such as OOC Synthesis and Hierarchical Designs.
# This constraints file is not used in normal top-down synthesis (default flow
# of Vivado)
################################################################################
create_clock -name s00_axi_aclk -period 25 [get_ports s00_axi_aclk]
create_clock -name CLK_320 -period 3.125 [get_ports CLK_320]
create_clock -name CLK_40 -period 25 [get_ports CLK_40]

################################################################################