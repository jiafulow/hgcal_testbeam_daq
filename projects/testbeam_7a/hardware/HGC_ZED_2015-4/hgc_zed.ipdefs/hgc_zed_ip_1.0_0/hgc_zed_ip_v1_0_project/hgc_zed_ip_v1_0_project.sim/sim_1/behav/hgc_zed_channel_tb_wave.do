onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /hgc_zed_channel_tb/clk_40
add wave -noupdate /hgc_zed_channel_tb/clk_80
add wave -noupdate /hgc_zed_channel_tb/testid
add wave -noupdate /hgc_zed_channel_tb/rx_data
add wave -noupdate /hgc_zed_channel_tb/tx_data
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/reg0_in
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/reg1_in
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/reg2_in
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/reg3_in
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/reg0_out
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/reg1_out
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/reg2_out
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/reg3_out
add wave -noupdate /glbl/GSR
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {425000 ps} 0} {{Cursor 2} {675000 ps} 0}
configure wave -namecolwidth 355
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1670812 ps}
