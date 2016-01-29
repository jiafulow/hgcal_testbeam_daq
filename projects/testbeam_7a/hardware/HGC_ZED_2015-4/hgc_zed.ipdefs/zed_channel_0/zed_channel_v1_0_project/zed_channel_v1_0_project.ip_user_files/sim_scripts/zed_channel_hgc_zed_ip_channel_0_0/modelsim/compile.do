vlib work
vlib msim

vlib msim/blk_mem_gen_v8_3_1
vlib msim/xil_defaultlib

vmap blk_mem_gen_v8_3_1 msim/blk_mem_gen_v8_3_1
vmap xil_defaultlib msim/xil_defaultlib

vcom -work blk_mem_gen_v8_3_1 -64 -93 \
"../../../ipstatic/blk_mem_gen_v8_3_1/simulation/blk_mem_gen_v8_3.vhd" \
"../../../../../ip/zed_channel_hgc_zed_ip_channel_0_0/hgc_zed_ip_v1_0_project/hgc_zed_ip_v1_0_project.srcs/sources_1/ip/tdpram_32x256/sim/tdpram_32x256.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../../../ip/zed_channel_hgc_zed_ip_channel_0_0/xil_defaultlib/hgc_zed_ip_v1_0_project/hgc_zed_ip_v1_0_project.srcs/sources_1/new/hgc_pck.vhd" \
"../../../../../ip/zed_channel_hgc_zed_ip_channel_0_0/xil_defaultlib/hgc_zed_ip_v1_0_project/hgc_zed_ip_v1_0_project.srcs/sources_1/new/hgc_zed_channel.vhd" \
"../../../../../ip/zed_channel_hgc_zed_ip_channel_0_0/xil_defaultlib/hgc_zed_ip_v1_0_project/hgc_zed_ip_v1_0_project.srcs/sources_1/new/menc_nibble.vhd" \
"../../../../../ip/zed_channel_hgc_zed_ip_channel_0_0/xil_defaultlib/hgc_zed_ip_v1_0_project/hgc_zed_ip_v1_0_project.srcs/sources_1/new/mdec_nibble.vhd" \
"../../../../../ip/zed_channel_hgc_zed_ip_channel_0_0/xil_defaultlib/hgc_zed_ip_v1_0_project/hgc_zed_ip_v1_0_project.srcs/sources_1/new/ctrl_send_mem.vhd" \
"../../../../../ip/zed_channel_hgc_zed_ip_channel_0_0/xil_defaultlib/hgc_zed_ip_v1_0_project/hgc_zed_ip_v1_0_project.srcs/sources_1/new/ctrl_rcv_mem.vhd" \
"../../../../../ip/zed_channel_hgc_zed_ip_channel_0_0/xil_defaultlib/hgc_zed_ip_v1_0_project/hgc_zed_ip_v1_0_project.srcs/sources_1/new/MasterFSM.vhd" \
"../../../../../ip/zed_channel_hgc_zed_ip_channel_0_0/xil_defaultlib/hgc_zed_ip_v1_0_project/hgc_zed_ip_v1_0_project.srcs/sources_1/new/align_deser_data.vhd" \
"../../../../../ip/zed_channel_hgc_zed_ip_channel_0_0/sim/zed_channel_hgc_zed_ip_channel_0_0.vhd" \

