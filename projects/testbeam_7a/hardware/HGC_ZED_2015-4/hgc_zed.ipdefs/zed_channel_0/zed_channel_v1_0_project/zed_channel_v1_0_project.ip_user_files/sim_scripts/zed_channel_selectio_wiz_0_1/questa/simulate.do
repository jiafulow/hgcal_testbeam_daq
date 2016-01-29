onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib zed_channel_selectio_wiz_0_1_opt

do {wave.do}

view wave
view structure
view signals

do {zed_channel_selectio_wiz_0_1.udo}

run -all

quit -force
