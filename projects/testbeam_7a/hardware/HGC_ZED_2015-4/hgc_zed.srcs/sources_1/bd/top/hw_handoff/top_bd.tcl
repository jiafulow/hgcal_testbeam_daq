
################################################################
# This is a generated script based on design: top
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2015.4
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source top_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7z020clg484-1
#    set_property BOARD_PART em.avnet.com:zed:part0:1.0 [current_project]

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}



# CHANGE DESIGN NAME HERE
set design_name top

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "ERROR: Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      puts "INFO: Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   puts "INFO: Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   puts "INFO: Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]

  # Create ports
  set clk_out_ref_n [ create_bd_port -dir O clk_out_ref_n ]
  set clk_out_ref_p [ create_bd_port -dir O clk_out_ref_p ]
  set data_in_from_pins_n [ create_bd_port -dir I -from 0 -to 0 data_in_from_pins_n ]
  set data_in_from_pins_p [ create_bd_port -dir I -from 0 -to 0 data_in_from_pins_p ]
  set data_out_to_pins_n [ create_bd_port -dir O -from 0 -to 0 data_out_to_pins_n ]
  set data_out_to_pins_p [ create_bd_port -dir O -from 0 -to 0 data_out_to_pins_p ]

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.2 clk_wiz_0 ]
  set_property -dict [ list \
CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {40} \
CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {320} \
CONFIG.CLKOUT2_USED {true} \
CONFIG.PRIMITIVE {MMCM} \
CONFIG.PRIM_IN_FREQ {40} \
CONFIG.PRIM_SOURCE {Global_buffer} \
CONFIG.USE_BOARD_FLOW {false} \
CONFIG.USE_RESET {false} \
 ] $clk_wiz_0

  # Create instance: hgc_zed_common_0, and set properties
  set hgc_zed_common_0 [ create_bd_cell -type ip -vlnv fnal.gov:user:hgc_zed_common:1.0 hgc_zed_common_0 ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
CONFIG.PCW_EN_CLK1_PORT {1} \
CONFIG.PCW_EN_CLK2_PORT {0} \
CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {40} \
CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {40} \
CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {50} \
CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0} \
CONFIG.preset {ZedBoard} \
 ] $processing_system7_0

  # Create instance: processing_system7_0_axi_periph, and set properties
  set processing_system7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 processing_system7_0_axi_periph ]
  set_property -dict [ list \
CONFIG.NUM_MI {1} \
 ] $processing_system7_0_axi_periph

  # Create instance: rst_processing_system7_0_100M, and set properties
  set rst_processing_system7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_100M ]

  # Create instance: zed_channel_0, and set properties
  set zed_channel_0 [ create_bd_cell -type ip -vlnv fnal.gov:ip:zed_channel:1.0 zed_channel_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins processing_system7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M00_AXI [get_bd_intf_pins processing_system7_0_axi_periph/M00_AXI] [get_bd_intf_pins zed_channel_0/S00_AXI]

  # Create port connections
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins hgc_zed_common_0/clk_in] [get_bd_pins zed_channel_0/CLK_40]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins zed_channel_0/CLK_320]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins hgc_zed_common_0/locked]
  connect_bd_net -net data_in_from_pins_n_1 [get_bd_ports data_in_from_pins_n] [get_bd_pins zed_channel_0/data_in_from_pins_n]
  connect_bd_net -net data_in_from_pins_p_1 [get_bd_ports data_in_from_pins_p] [get_bd_pins zed_channel_0/data_in_from_pins_p]
  connect_bd_net -net hgc_zed_common_0_clk_out_n [get_bd_ports clk_out_ref_n] [get_bd_pins hgc_zed_common_0/clk_out_n]
  connect_bd_net -net hgc_zed_common_0_clk_out_p [get_bd_ports clk_out_ref_p] [get_bd_pins hgc_zed_common_0/clk_out_p]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0_axi_periph/ACLK] [get_bd_pins processing_system7_0_axi_periph/M00_ACLK] [get_bd_pins processing_system7_0_axi_periph/S00_ACLK] [get_bd_pins rst_processing_system7_0_100M/slowest_sync_clk] [get_bd_pins zed_channel_0/s00_axi_aclk]
  connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins processing_system7_0/FCLK_CLK1]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_processing_system7_0_100M/ext_reset_in]
  connect_bd_net -net rst_processing_system7_0_100M_interconnect_aresetn [get_bd_pins processing_system7_0_axi_periph/ARESETN] [get_bd_pins rst_processing_system7_0_100M/interconnect_aresetn]
  connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins processing_system7_0_axi_periph/M00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_processing_system7_0_100M/peripheral_aresetn] [get_bd_pins zed_channel_0/s00_axi_aresetn]
  connect_bd_net -net zed_channel_0_data_out_to_pins_n [get_bd_ports data_out_to_pins_n] [get_bd_pins zed_channel_0/data_out_to_pins_n]
  connect_bd_net -net zed_channel_0_data_out_to_pins_p [get_bd_ports data_out_to_pins_p] [get_bd_pins zed_channel_0/data_out_to_pins_p]

  # Create address segments
  create_bd_addr_seg -range 0x10000 -offset 0x43C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zed_channel_0/S00_AXI/Reg] SEG_zed_channel_0_Reg

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   da_ps7_cnt: "1",
   guistr: "# # String gsaved with Nlview 6.5.5  2015-06-26 bk=1.3371 VDI=38 GEI=35 GUI=JA:1.8
#  -string -flagsOSRD
preplace port DDR -pg 1 -y 400 -defaultsOSRD
preplace port clk_out_ref_n -pg 1 -y 520 -defaultsOSRD
preplace port FIXED_IO -pg 1 -y 420 -defaultsOSRD
preplace port clk_out_ref_p -pg 1 -y 500 -defaultsOSRD
preplace portBus data_out_to_pins_n -pg 1 -y 160 -defaultsOSRD
preplace portBus data_out_to_pins_p -pg 1 -y 180 -defaultsOSRD
preplace portBus data_in_from_pins_n -pg 1 -y 250 -defaultsOSRD
preplace portBus data_in_from_pins_p -pg 1 -y 270 -defaultsOSRD
preplace inst rst_processing_system7_0_100M -pg 1 -lvl 1 -y 90 -defaultsOSRD
preplace inst zed_channel_0 -pg 1 -lvl 3 -y 170 -defaultsOSRD
preplace inst hgc_zed_common_0 -pg 1 -lvl 3 -y 510 -defaultsOSRD
preplace inst clk_wiz_0 -pg 1 -lvl 2 -y 500 -defaultsOSRD
preplace inst processing_system7_0_axi_periph -pg 1 -lvl 2 -y 110 -defaultsOSRD
preplace inst processing_system7_0 -pg 1 -lvl 1 -y 460 -defaultsOSRD
preplace netloc processing_system7_0_DDR 1 1 3 630 400 NJ 400 NJ
preplace netloc clk_wiz_0_locked 1 2 1 N
preplace netloc processing_system7_0_axi_periph_M00_AXI 1 2 1 N
preplace netloc processing_system7_0_M_AXI_GP0 1 1 1 620
preplace netloc zed_channel_0_data_out_to_pins_n 1 3 1 N
preplace netloc data_in_from_pins_n_1 1 0 3 NJ 250 NJ 250 1100
preplace netloc hgc_zed_common_0_clk_out_n 1 3 1 N
preplace netloc processing_system7_0_FCLK_RESET0_N 1 0 2 210 190 610
preplace netloc zed_channel_0_data_out_to_pins_p 1 3 1 N
preplace netloc hgc_zed_common_0_clk_out_p 1 3 1 N
preplace netloc rst_processing_system7_0_100M_peripheral_aresetn 1 1 2 630 230 NJ
preplace netloc processing_system7_0_FIXED_IO 1 1 3 650 420 NJ 420 NJ
preplace netloc clk_wiz_0_clk_out1 1 2 1 1120
preplace netloc clk_wiz_0_clk_out2 1 2 1 1090
preplace netloc processing_system7_0_FCLK_CLK0 1 0 3 200 180 640 240 NJ
preplace netloc rst_processing_system7_0_100M_interconnect_aresetn 1 1 1 610
preplace netloc processing_system7_0_FCLK_CLK1 1 1 1 630
preplace netloc data_in_from_pins_p_1 1 0 3 NJ 270 NJ 270 1130
levelinfo -pg 1 180 410 940 1360 1570 -top 0 -bot 580
",
   }
{
   da_axi4_cnt: "1",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


