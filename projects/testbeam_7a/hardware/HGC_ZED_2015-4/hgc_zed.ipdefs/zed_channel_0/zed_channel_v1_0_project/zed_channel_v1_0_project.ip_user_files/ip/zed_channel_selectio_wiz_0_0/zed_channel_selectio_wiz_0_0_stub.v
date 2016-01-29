// Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2015.4 (lin64) Build 1412921 Wed Nov 18 09:44:32 MST 2015
// Date        : Fri Jan 29 05:27:48 2016
// Host        : athena running 64-bit Ubuntu 14.04.3 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/jlow/Work/Vivado/testbeam_7a/HGC_ZED_0/hgc_zed/hgc_zed.srcs/sources_1/bd/zed_channel/ip/zed_channel_selectio_wiz_0_0/zed_channel_selectio_wiz_0_0_stub.v
// Design      : zed_channel_selectio_wiz_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module zed_channel_selectio_wiz_0_0(data_out_from_device, data_out_to_pins_p, data_out_to_pins_n, clk_in, clk_div_in, io_reset)
/* synthesis syn_black_box black_box_pad_pin="data_out_from_device[7:0],data_out_to_pins_p[0:0],data_out_to_pins_n[0:0],clk_in,clk_div_in,io_reset" */;
  input [7:0]data_out_from_device;
  output [0:0]data_out_to_pins_p;
  output [0:0]data_out_to_pins_n;
  input clk_in;
  input clk_div_in;
  input io_reset;
endmodule
