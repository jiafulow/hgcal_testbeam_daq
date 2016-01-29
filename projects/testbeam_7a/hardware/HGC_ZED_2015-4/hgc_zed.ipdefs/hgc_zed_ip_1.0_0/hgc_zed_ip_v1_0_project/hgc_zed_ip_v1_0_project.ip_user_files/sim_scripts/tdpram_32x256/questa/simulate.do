onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib tdpram_32x256_opt

do {wave.do}

view wave
view structure
view signals

do {tdpram_32x256.udo}

run -all

quit -force
