#-----------------------
#Loading from existing component.
ipx::open_core {./component.xml}
#-----------------------

ipx::remove_all_port [ipx::current_core]
ipx::remove_all_file_group [ipx::current_core]
ipx::remove_all_bus_interface [ipx::current_core]

#-----------------------
# SYNTHESIS FILESET
#-----------------------
ipx::add_file_group {xilinx_vhdlsynthesis} [ipx::current_core]
ipx::add_file hw_handoff/zed_channel.hwh [ipx::get_file_group xilinx_vhdlsynthesis [ipx::current_core]]
ipx::add_file ip/zed_channel_hgc_zed_ip_channel_0_0/zed_channel_hgc_zed_ip_channel_0_0.xci [ipx::get_file_group xilinx_vhdlsynthesis [ipx::current_core]]
ipx::add_file ip/zed_channel_selectio_wiz_0_0/zed_channel_selectio_wiz_0_0.xci [ipx::get_file_group xilinx_vhdlsynthesis [ipx::current_core]]
ipx::add_file ip/zed_channel_selectio_wiz_0_1/zed_channel_selectio_wiz_0_1.xci [ipx::get_file_group xilinx_vhdlsynthesis [ipx::current_core]]
ipx::add_file zed_channel_ooc.xdc [ipx::get_file_group xilinx_vhdlsynthesis [ipx::current_core]]
ipx::add_file hdl/zed_channel.vhd [ipx::get_file_group xilinx_vhdlsynthesis [ipx::current_core]]
set_property {model_name} {zed_channel} [ipx::get_file_group xilinx_vhdlsynthesis [ipx::current_core]]

#-----------------------
# SIMULATION FILESET
#-----------------------
ipx::add_file_group {xilinx_vhdlbehavioralsimulation} [ipx::current_core]
ipx::add_file hw_handoff/zed_channel.hwh [ipx::get_file_group xilinx_vhdlbehavioralsimulation [ipx::current_core]]
ipx::add_file ip/zed_channel_hgc_zed_ip_channel_0_0/zed_channel_hgc_zed_ip_channel_0_0.xci [ipx::get_file_group xilinx_vhdlbehavioralsimulation [ipx::current_core]]
ipx::add_file ip/zed_channel_selectio_wiz_0_0/zed_channel_selectio_wiz_0_0.xci [ipx::get_file_group xilinx_vhdlbehavioralsimulation [ipx::current_core]]
ipx::add_file ip/zed_channel_selectio_wiz_0_1/zed_channel_selectio_wiz_0_1.xci [ipx::get_file_group xilinx_vhdlbehavioralsimulation [ipx::current_core]]
ipx::add_file zed_channel_ooc.xdc [ipx::get_file_group xilinx_vhdlbehavioralsimulation [ipx::current_core]]
ipx::add_file hdl/zed_channel.vhd [ipx::get_file_group xilinx_vhdlbehavioralsimulation [ipx::current_core]]
set_property {model_name} {zed_channel} [ipx::get_file_group xilinx_vhdlbehavioralsimulation [ipx::current_core]]

#-----------------------
# PORTS 
#-----------------------
ipx::add_ports_from_hdl [::ipx::current_core] -top_level_hdl_file ./hdl/zed_channel.vhd -top_module_name zed_channel

#-----------------------
# BUS INTERFACES 
#-----------------------
#------------------
#   Adding S00_AXI
#------------------
ipx::add_bus_interface {S00_AXI} [ipx::current_core]
set_property interface_mode {slave} [ipx::get_bus_interface {S00_AXI} [ipx::current_core]]
set_property display_name {S00_AXI} [ipx::get_bus_interface {S00_AXI} [ipx::current_core]]

#   Adding Bus Type VNLV xilinx.com:interface:aximm:1.0
set_property {bus_type_vlnv} {xilinx.com:interface:aximm:1.0}  [ipx::get_bus_interface S00_AXI [ipx::current_core]]

#   Adding Abstraction VNLV xilinx.com:interface:aximm_rtl:1.0
set_property {abstraction_type_vlnv} {xilinx.com:interface:aximm_rtl:1.0}  [ipx::get_bus_interface S00_AXI [ipx::current_core]]

#   Adding PortMaps
set_property {physical_name} {S00_AXI_awaddr} [ipx::add_port_map {AWADDR}  [ipx::get_bus_interface {S00_AXI} [ipx::current_core]]]
set_property {physical_name} {S00_AXI_awprot} [ipx::add_port_map {AWPROT}  [ipx::get_bus_interface {S00_AXI} [ipx::current_core]]]
set_property {physical_name} {S00_AXI_awvalid} [ipx::add_port_map {AWVALID}  [ipx::get_bus_interface {S00_AXI} [ipx::current_core]]]
set_property {physical_name} {S00_AXI_awready} [ipx::add_port_map {AWREADY}  [ipx::get_bus_interface {S00_AXI} [ipx::current_core]]]
set_property {physical_name} {S00_AXI_wdata} [ipx::add_port_map {WDATA}  [ipx::get_bus_interface {S00_AXI} [ipx::current_core]]]
set_property {physical_name} {S00_AXI_wstrb} [ipx::add_port_map {WSTRB}  [ipx::get_bus_interface {S00_AXI} [ipx::current_core]]]
set_property {physical_name} {S00_AXI_wvalid} [ipx::add_port_map {WVALID}  [ipx::get_bus_interface {S00_AXI} [ipx::current_core]]]
set_property {physical_name} {S00_AXI_wready} [ipx::add_port_map {WREADY}  [ipx::get_bus_interface {S00_AXI} [ipx::current_core]]]
set_property {physical_name} {S00_AXI_bresp} [ipx::add_port_map {BRESP}  [ipx::get_bus_interface {S00_AXI} [ipx::current_core]]]
set_property {physical_name} {S00_AXI_bvalid} [ipx::add_port_map {BVALID}  [ipx::get_bus_interface {S00_AXI} [ipx::current_core]]]
set_property {physical_name} {S00_AXI_bready} [ipx::add_port_map {BREADY}  [ipx::get_bus_interface {S00_AXI} [ipx::current_core]]]
set_property {physical_name} {S00_AXI_araddr} [ipx::add_port_map {ARADDR}  [ipx::get_bus_interface {S00_AXI} [ipx::current_core]]]
set_property {physical_name} {S00_AXI_arprot} [ipx::add_port_map {ARPROT}  [ipx::get_bus_interface {S00_AXI} [ipx::current_core]]]
set_property {physical_name} {S00_AXI_arvalid} [ipx::add_port_map {ARVALID}  [ipx::get_bus_interface {S00_AXI} [ipx::current_core]]]
set_property {physical_name} {S00_AXI_arready} [ipx::add_port_map {ARREADY}  [ipx::get_bus_interface {S00_AXI} [ipx::current_core]]]
set_property {physical_name} {S00_AXI_rdata} [ipx::add_port_map {RDATA}  [ipx::get_bus_interface {S00_AXI} [ipx::current_core]]]
set_property {physical_name} {S00_AXI_rresp} [ipx::add_port_map {RRESP}  [ipx::get_bus_interface {S00_AXI} [ipx::current_core]]]
set_property {physical_name} {S00_AXI_rvalid} [ipx::add_port_map {RVALID}  [ipx::get_bus_interface {S00_AXI} [ipx::current_core]]]
set_property {physical_name} {S00_AXI_rready} [ipx::add_port_map {RREADY}  [ipx::get_bus_interface {S00_AXI} [ipx::current_core]]]
#------------------
#   Adding Parameters
ipx::add_bus_parameter {SUPPORTS_NARROW_BURST}  [ipx::get_bus_interface S00_AXI [ipx::current_core]]
set_property {value} {0} [ipx::get_bus_parameter {SUPPORTS_NARROW_BURST}   [ipx::get_bus_interface S00_AXI [ipx::current_core]]]

#------------------
#   Adding CLK.s00_axi_aclk
#------------------
ipx::add_bus_interface {CLK.s00_axi_aclk} [ipx::current_core]
set_property display_name {Clk} [ipx::get_bus_interface {CLK.s00_axi_aclk} [ipx::current_core]]
set_property interface_mode {slave} [ipx::get_bus_interface {CLK.s00_axi_aclk} [ipx::current_core]]

#   Adding Bus Type VNLV xilinx.com:signal:clock:1.0
set_property {bus_type_vlnv} {xilinx.com:signal:clock:1.0}  [ipx::get_bus_interface CLK.s00_axi_aclk [ipx::current_core]]

#   Adding Abstraction VNLV xilinx.com:signal:clock_rtl:1.0
set_property {abstraction_type_vlnv} {xilinx.com:signal:clock_rtl:1.0}  [ipx::get_bus_interface CLK.s00_axi_aclk [ipx::current_core]]

#   Adding PortMap
set_property {physical_name} {s00_axi_aclk} [ipx::add_port_map {CLK}  [ipx::get_bus_interface {CLK.s00_axi_aclk} [ipx::current_core]]]
#   Adding Parameters
ipx::add_bus_parameter {ASSOCIATED_BUSIF}  [ipx::get_bus_interface CLK.s00_axi_aclk [ipx::current_core]]
set_property {value} {S00_AXI} [ipx::get_bus_parameter {ASSOCIATED_BUSIF}   [ipx::get_bus_interface CLK.s00_axi_aclk [ipx::current_core]]]

#------------------
#   Adding RST.s00_axi_aresetn
#------------------
ipx::add_bus_interface {RST.s00_axi_aresetn} [ipx::current_core]
set_property display_name {Reset} [ipx::get_bus_interface {RST.s00_axi_aresetn} [ipx::current_core]]
set_property interface_mode {slave} [ipx::get_bus_interface {RST.s00_axi_aresetn} [ipx::current_core]]

#   Adding Bus Type VNLV xilinx.com:signal:reset:1.0
set_property {bus_type_vlnv} {xilinx.com:signal:reset:1.0}  [ipx::get_bus_interface RST.s00_axi_aresetn [ipx::current_core]]

#   Adding Abstraction VNLV xilinx.com:signal:reset_rtl:1.0
set_property {abstraction_type_vlnv} {xilinx.com:signal:reset_rtl:1.0}  [ipx::get_bus_interface RST.s00_axi_aresetn [ipx::current_core]]

#   Adding PortMap
set_property {physical_name} {s00_axi_aresetn} [ipx::add_port_map {RST}  [ipx::get_bus_interface {RST.s00_axi_aresetn} [ipx::current_core]]]
#   Adding Parameters
ipx::add_bus_parameter {POLARITY}  [ipx::get_bus_interface RST.s00_axi_aresetn [ipx::current_core]]
set_property {value} {ACTIVE_LOW} [ipx::get_bus_parameter {POLARITY}   [ipx::get_bus_interface RST.s00_axi_aresetn [ipx::current_core]]]

#------------------
#   Adding CLK.CLK_320
#------------------
ipx::add_bus_interface {CLK.CLK_320} [ipx::current_core]
set_property display_name {Clk1} [ipx::get_bus_interface {CLK.CLK_320} [ipx::current_core]]
set_property interface_mode {slave} [ipx::get_bus_interface {CLK.CLK_320} [ipx::current_core]]

#   Adding Bus Type VNLV xilinx.com:signal:clock:1.0
set_property {bus_type_vlnv} {xilinx.com:signal:clock:1.0}  [ipx::get_bus_interface CLK.CLK_320 [ipx::current_core]]

#   Adding Abstraction VNLV xilinx.com:signal:clock_rtl:1.0
set_property {abstraction_type_vlnv} {xilinx.com:signal:clock_rtl:1.0}  [ipx::get_bus_interface CLK.CLK_320 [ipx::current_core]]

#   Adding PortMap
set_property {physical_name} {CLK_320} [ipx::add_port_map {CLK}  [ipx::get_bus_interface {CLK.CLK_320} [ipx::current_core]]]
#   Adding Parameters
#------------------
#   Adding CLK.CLK_40
#------------------
ipx::add_bus_interface {CLK.CLK_40} [ipx::current_core]
set_property display_name {Clk2} [ipx::get_bus_interface {CLK.CLK_40} [ipx::current_core]]
set_property interface_mode {slave} [ipx::get_bus_interface {CLK.CLK_40} [ipx::current_core]]

#   Adding Bus Type VNLV xilinx.com:signal:clock:1.0
set_property {bus_type_vlnv} {xilinx.com:signal:clock:1.0}  [ipx::get_bus_interface CLK.CLK_40 [ipx::current_core]]

#   Adding Abstraction VNLV xilinx.com:signal:clock_rtl:1.0
set_property {abstraction_type_vlnv} {xilinx.com:signal:clock_rtl:1.0}  [ipx::get_bus_interface CLK.CLK_40 [ipx::current_core]]

#   Adding PortMap
set_property {physical_name} {CLK_40} [ipx::add_port_map {CLK}  [ipx::get_bus_interface {CLK.CLK_40} [ipx::current_core]]]
#   Adding Parameters

#-----------------------
# SAVE CORE TO REPOS
#-----------------------
ipx::create_default_gui_files [ipx::current_core]
ipx::save_core [ipx::current_core]
ipx::check_integrity  [ipx::current_core]
update_ip_catalog
