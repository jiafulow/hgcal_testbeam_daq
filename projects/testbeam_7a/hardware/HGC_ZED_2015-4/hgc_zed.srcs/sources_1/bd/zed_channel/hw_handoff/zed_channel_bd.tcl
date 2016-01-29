
################################################################
# This is a generated script based on design: zed_channel
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
# source zed_channel_script.tcl

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
set design_name zed_channel

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
  set S00_AXI [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI ]
  set_property -dict [ list \
CONFIG.ADDR_WIDTH {32} \
CONFIG.ARUSER_WIDTH {0} \
CONFIG.AWUSER_WIDTH {0} \
CONFIG.BUSER_WIDTH {0} \
CONFIG.DATA_WIDTH {32} \
CONFIG.HAS_BRESP {1} \
CONFIG.HAS_BURST {1} \
CONFIG.HAS_CACHE {1} \
CONFIG.HAS_LOCK {1} \
CONFIG.HAS_PROT {1} \
CONFIG.HAS_QOS {1} \
CONFIG.HAS_REGION {1} \
CONFIG.HAS_RRESP {1} \
CONFIG.HAS_WSTRB {1} \
CONFIG.ID_WIDTH {0} \
CONFIG.MAX_BURST_LENGTH {1} \
CONFIG.NUM_READ_OUTSTANDING {1} \
CONFIG.NUM_WRITE_OUTSTANDING {1} \
CONFIG.PROTOCOL {AXI4LITE} \
CONFIG.READ_WRITE_MODE {READ_WRITE} \
CONFIG.RUSER_WIDTH {0} \
CONFIG.SUPPORTS_NARROW_BURST {0} \
CONFIG.WUSER_WIDTH {0} \
 ] $S00_AXI

  # Create ports
  set CLK_40 [ create_bd_port -dir I -type clk CLK_40 ]
  set_property -dict [ list \
CONFIG.FREQ_HZ {40000000} \
 ] $CLK_40
  set CLK_320 [ create_bd_port -dir I -type clk CLK_320 ]
  set_property -dict [ list \
CONFIG.FREQ_HZ {320000000} \
 ] $CLK_320
  set data_in_from_pins_n [ create_bd_port -dir I -from 0 -to 0 data_in_from_pins_n ]
  set data_in_from_pins_p [ create_bd_port -dir I -from 0 -to 0 data_in_from_pins_p ]
  set data_out_to_pins_n [ create_bd_port -dir O -from 0 -to 0 data_out_to_pins_n ]
  set data_out_to_pins_p [ create_bd_port -dir O -from 0 -to 0 data_out_to_pins_p ]
  set s00_axi_aclk [ create_bd_port -dir I -type clk s00_axi_aclk ]
  set_property -dict [ list \
CONFIG.FREQ_HZ {40000000} \
 ] $s00_axi_aclk
  set s00_axi_aresetn [ create_bd_port -dir I -type rst s00_axi_aresetn ]

  # Create instance: hgc_zed_ip_channel_0, and set properties
  set hgc_zed_ip_channel_0 [ create_bd_cell -type ip -vlnv fnal.gov:user:hgc_zed_ip_channel:1.0 hgc_zed_ip_channel_0 ]

  # Create instance: selectio_deserializer, and set properties
  set selectio_deserializer [ create_bd_cell -type ip -vlnv xilinx.com:ip:selectio_wiz:5.1 selectio_deserializer ]
  set_property -dict [ list \
CONFIG.BUS_IO_STD {LVDS_25} \
CONFIG.BUS_SIG_TYPE {DIFF} \
CONFIG.SELIO_BUS_IN_DELAY {NONE} \
CONFIG.SELIO_CLK_BUF {MMCM} \
CONFIG.SERIALIZATION_FACTOR {8} \
CONFIG.USE_SERIALIZATION {true} \
 ] $selectio_deserializer

  # Create instance: selectio_serializer, and set properties
  set selectio_serializer [ create_bd_cell -type ip -vlnv xilinx.com:ip:selectio_wiz:5.1 selectio_serializer ]
  set_property -dict [ list \
CONFIG.BUS_DIR {OUTPUTS} \
CONFIG.BUS_IO_STD {LVDS_25} \
CONFIG.BUS_SIG_TYPE {DIFF} \
CONFIG.SELIO_CLK_BUF {MMCM} \
CONFIG.SERIALIZATION_FACTOR {8} \
CONFIG.USE_SERIALIZATION {true} \
 ] $selectio_serializer

  # Create interface connections
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_ports S00_AXI] [get_bd_intf_pins hgc_zed_ip_channel_0/S00_AXI]

  # Create port connections
  connect_bd_net -net CLK_320_1 [get_bd_ports CLK_320] [get_bd_pins selectio_deserializer/clk_in] [get_bd_pins selectio_serializer/clk_in]
  connect_bd_net -net CLK_40_1 [get_bd_ports CLK_40] [get_bd_pins hgc_zed_ip_channel_0/CLK_40] [get_bd_pins selectio_deserializer/clk_div_in] [get_bd_pins selectio_serializer/clk_div_in]
  connect_bd_net -net data_in_from_pins_n_1 [get_bd_ports data_in_from_pins_n] [get_bd_pins selectio_deserializer/data_in_from_pins_n]
  connect_bd_net -net data_in_from_pins_p_1 [get_bd_ports data_in_from_pins_p] [get_bd_pins selectio_deserializer/data_in_from_pins_p]
  connect_bd_net -net hgc_zed_ip_channel_0_TX_DATA [get_bd_pins hgc_zed_ip_channel_0/TX_DATA] [get_bd_pins selectio_serializer/data_out_from_device]
  connect_bd_net -net s00_axi_aclk_1 [get_bd_ports s00_axi_aclk] [get_bd_pins hgc_zed_ip_channel_0/s00_axi_aclk]
  connect_bd_net -net s00_axi_aresetn_1 [get_bd_ports s00_axi_aresetn] [get_bd_pins hgc_zed_ip_channel_0/s00_axi_aresetn]
  connect_bd_net -net selectio_deserializer_data_in_to_device [get_bd_pins hgc_zed_ip_channel_0/RX_DATA] [get_bd_pins selectio_deserializer/data_in_to_device]
  connect_bd_net -net selectio_serializer_data_out_to_pins_n [get_bd_ports data_out_to_pins_n] [get_bd_pins selectio_serializer/data_out_to_pins_n]
  connect_bd_net -net selectio_serializer_data_out_to_pins_p [get_bd_ports data_out_to_pins_p] [get_bd_pins selectio_serializer/data_out_to_pins_p]

  # Create address segments
  create_bd_addr_seg -range 0x10000 -offset 0x44A00000 [get_bd_addr_spaces S00_AXI] [get_bd_addr_segs hgc_zed_ip_channel_0/S00_AXI/S00_AXI_reg] SEG_hgc_zed_ip_channel_0_S00_AXI_reg

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview version 6.4-r1  2014-02-28 bk=1.3047 VDI=34 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port s00_axi_aresetn -pg 1 -y 360 -defaultsOSRD
preplace port S00_AXI -pg 1 -y 280 -defaultsOSRD
preplace port CLK_320 -pg 1 -y 100 -defaultsOSRD
preplace port CLK_40 -pg 1 -y 120 -defaultsOSRD
preplace port s00_axi_aclk -pg 1 -y 340 -defaultsOSRD
preplace portBus data_out_to_pins_n -pg 1 -y 250 -defaultsOSRD
preplace portBus data_out_to_pins_p -pg 1 -y 230 -defaultsOSRD
preplace portBus data_in_from_pins_n -pg 1 -y 80 -defaultsOSRD
preplace portBus data_in_from_pins_p -pg 1 -y 60 -defaultsOSRD
preplace inst hgc_zed_ip_channel_0 -pg 1 -lvl 2 -y 320 -defaultsOSRD
preplace inst selectio_deserializer -pg 1 -lvl 1 -y 110 -defaultsOSRD
preplace inst selectio_serializer -pg 1 -lvl 3 -y 240 -defaultsOSRD
preplace netloc selectio_serializer_data_out_to_pins_n 1 3 1 N
preplace netloc CLK_40_1 1 0 3 220 220 560 230 NJ
preplace netloc selectio_serializer_data_out_to_pins_p 1 3 1 N
preplace netloc data_in_from_pins_n_1 1 0 1 N
preplace netloc S00_AXI_1 1 0 2 NJ 280 N
preplace netloc CLK_320_1 1 0 3 220 10 NJ 10 830
preplace netloc s00_axi_aclk_1 1 0 2 NJ 340 N
preplace netloc s00_axi_aresetn_1 1 0 2 NJ 360 N
preplace netloc data_in_from_pins_p_1 1 0 1 N
preplace netloc selectio_deserializer_data_in_to_device 1 1 1 570
preplace netloc hgc_zed_ip_channel_0_TX_DATA 1 2 1 830
levelinfo -pg 1 200 390 710 1010 1220
",
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


