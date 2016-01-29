vlib work
vlib msim

vlib msim/xil_defaultlib

vmap xil_defaultlib msim/xil_defaultlib

vlog -work xil_defaultlib -64 \
"../../../../../ip/zed_channel_selectio_wiz_0_1/zed_channel_selectio_wiz_0_1_selectio_wiz.v" \
"../../../../../ip/zed_channel_selectio_wiz_0_1/zed_channel_selectio_wiz_0_1.v" \


vlog -work xil_defaultlib "glbl.v"

