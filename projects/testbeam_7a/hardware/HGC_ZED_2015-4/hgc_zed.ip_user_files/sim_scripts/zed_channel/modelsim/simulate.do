onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -pli "/opt/Xilinx/Vivado/2015.4/lib/lnx64.o/libxil_vsim.so" -L unisims_ver -L unimacro_ver -L secureip -L xil_defaultlib -L blk_mem_gen_v8_3_1 -lib xil_defaultlib xil_defaultlib.zed_channel xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {zed_channel.udo}

run -all

quit -force
