vlib work
vlib msim

vlib msim/xil_defaultlib
vlib msim/blk_mem_gen_v8_3_1

vmap xil_defaultlib msim/xil_defaultlib
vmap blk_mem_gen_v8_3_1 msim/blk_mem_gen_v8_3_1

vcom -work xil_defaultlib -64 \
"../../../bd/zed_channel/ip/zed_channel_hgc_zed_ip_channel_0_0/xil_defaultlib/hgc_zed_ip_v1_0_project/hgc_zed_ip_v1_0_project.srcs/sources_1/new/hgc_pck.vhd" \

vcom -work blk_mem_gen_v8_3_1 -64 \
"../../../../hgc_zed.srcs/sources_1/bd/zed_channel/ip/zed_channel_hgc_zed_ip_channel_0_0/hgc_zed_ip_v1_0_project/hgc_zed_ip_v1_0_project.srcs/sources_1/ip/tdpram_32x256/blk_mem_gen_v8_3_1/simulation/blk_mem_gen_v8_3.vhd" \
"../../../bd/zed_channel/ip/zed_channel_hgc_zed_ip_channel_0_0/hgc_zed_ip_v1_0_project/hgc_zed_ip_v1_0_project.srcs/sources_1/ip/tdpram_32x256/sim/tdpram_32x256.vhd" \

vcom -work xil_defaultlib -64 \
"../../../bd/zed_channel/ip/zed_channel_hgc_zed_ip_channel_0_0/xil_defaultlib/hgc_zed_ip_v1_0_project/hgc_zed_ip_v1_0_project.srcs/sources_1/new/hgc_zed_channel.vhd" \
"../../../bd/zed_channel/ip/zed_channel_hgc_zed_ip_channel_0_0/xil_defaultlib/hgc_zed_ip_v1_0_project/hgc_zed_ip_v1_0_project.srcs/sources_1/new/menc_nibble.vhd" \
"../../../bd/zed_channel/ip/zed_channel_hgc_zed_ip_channel_0_0/xil_defaultlib/hgc_zed_ip_v1_0_project/hgc_zed_ip_v1_0_project.srcs/sources_1/new/mdec_nibble.vhd" \
"../../../bd/zed_channel/ip/zed_channel_hgc_zed_ip_channel_0_0/xil_defaultlib/hgc_zed_ip_v1_0_project/hgc_zed_ip_v1_0_project.srcs/sources_1/new/ctrl_send_mem.vhd" \
"../../../bd/zed_channel/ip/zed_channel_hgc_zed_ip_channel_0_0/xil_defaultlib/hgc_zed_ip_v1_0_project/hgc_zed_ip_v1_0_project.srcs/sources_1/new/ctrl_rcv_mem.vhd" \
"../../../bd/zed_channel/ip/zed_channel_hgc_zed_ip_channel_0_0/xil_defaultlib/hgc_zed_ip_v1_0_project/hgc_zed_ip_v1_0_project.srcs/sources_1/new/MasterFSM.vhd" \
"../../../bd/zed_channel/ip/zed_channel_hgc_zed_ip_channel_0_0/xil_defaultlib/hgc_zed_ip_v1_0_project/hgc_zed_ip_v1_0_project.srcs/sources_1/new/align_deser_data.vhd" \
"../../../bd/zed_channel/ip/zed_channel_hgc_zed_ip_channel_0_0/sim/zed_channel_hgc_zed_ip_channel_0_0.vhd" \

vlog -work xil_defaultlib -64 \
"../../../bd/zed_channel/ip/zed_channel_selectio_wiz_0_0/zed_channel_selectio_wiz_0_0_selectio_wiz.v" \
"../../../bd/zed_channel/ip/zed_channel_selectio_wiz_0_0/zed_channel_selectio_wiz_0_0.v" \
"../../../bd/zed_channel/ip/zed_channel_selectio_wiz_0_1/zed_channel_selectio_wiz_0_1_selectio_wiz.v" \
"../../../bd/zed_channel/ip/zed_channel_selectio_wiz_0_1/zed_channel_selectio_wiz_0_1.v" \

vcom -work xil_defaultlib -64 \
"../../../bd/zed_channel/hdl/zed_channel.vhd" \

vlog -work xil_defaultlib "glbl.v"

