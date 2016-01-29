onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L unisims_ver -L unimacro_ver -L secureip -L xil_defaultlib -lib xil_defaultlib xil_defaultlib.zed_channel_selectio_wiz_0_0 xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {zed_channel_selectio_wiz_0_0.udo}

run -all

quit -force
