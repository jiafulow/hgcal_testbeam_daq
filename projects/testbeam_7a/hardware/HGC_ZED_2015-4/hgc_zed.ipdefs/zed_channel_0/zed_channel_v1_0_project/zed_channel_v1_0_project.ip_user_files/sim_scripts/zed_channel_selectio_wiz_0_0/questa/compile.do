vlib work
vlib msim

vlib msim/xil_defaultlib

vmap xil_defaultlib msim/xil_defaultlib

vlog -work xil_defaultlib -64 \
"../../../../../ip/zed_channel_selectio_wiz_0_0/zed_channel_selectio_wiz_0_0_selectio_wiz.v" \
"../../../../../ip/zed_channel_selectio_wiz_0_0/zed_channel_selectio_wiz_0_0.v" \


vlog -work xil_defaultlib "glbl.v"

