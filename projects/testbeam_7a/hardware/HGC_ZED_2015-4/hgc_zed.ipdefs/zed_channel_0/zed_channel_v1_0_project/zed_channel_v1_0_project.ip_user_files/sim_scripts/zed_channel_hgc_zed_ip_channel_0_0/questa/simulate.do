onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib zed_channel_hgc_zed_ip_channel_0_0_opt

do {wave.do}

view wave
view structure
view signals

do {zed_channel_hgc_zed_ip_channel_0_0.udo}

run -all

quit -force
