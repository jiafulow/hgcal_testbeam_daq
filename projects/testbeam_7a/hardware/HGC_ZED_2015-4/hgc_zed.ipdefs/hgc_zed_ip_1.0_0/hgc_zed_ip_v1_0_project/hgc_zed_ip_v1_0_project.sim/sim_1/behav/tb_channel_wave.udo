onerror {resume}
quietly virtual signal -install /hgc_zed_channel_tb { /hgc_zed_channel_tb/reg3_out(31 downto 24)} zed_status_31_24_rcv_memb_packet_length32
quietly virtual signal -install /hgc_zed_channel_tb { /hgc_zed_channel_tb/reg3_out(23 downto 16)} zed_status_23_16_send_mema_packet_length32
quietly virtual signal -install /hgc_zed_channel_tb {/hgc_zed_channel_tb/reg3_out(15)  } zed_status_15_MFSMstatRCVTRIGGER
quietly virtual signal -install /hgc_zed_channel_tb {/hgc_zed_channel_tb/reg3_out(14)  } zed_status_14_MFSMstatRCVFULL
quietly virtual signal -install /hgc_zed_channel_tb {/hgc_zed_channel_tb/reg3_out(13)  } zed_status_13_MFSMstatRCVPACKET
quietly virtual signal -install /hgc_zed_channel_tb {/hgc_zed_channel_tb/reg3_out(12)  } zed_status_12_MFSMstatERROR
quietly virtual signal -install /hgc_zed_channel_tb {/hgc_zed_channel_tb/reg3_out(11)  } zed_status_11_MFSMstatTIMEOUT
quietly virtual signal -install /hgc_zed_channel_tb {/hgc_zed_channel_tb/reg3_out(10)  } zed_status_10_MFSMstatSYNC
quietly virtual signal -install /hgc_zed_channel_tb {/hgc_zed_channel_tb/reg3_out(9)  } zed_status_9_MFSMstatBUSY
quietly virtual signal -install /hgc_zed_channel_tb {/hgc_zed_channel_tb/reg3_out(8)  } zed_status_8_MFSMstatIDLE
quietly virtual signal -install /hgc_zed_channel_tb {/hgc_zed_channel_tb/reg3_out(5)  } zed_status_5_rcv_memb_packet_length_woverflow
quietly virtual signal -install /hgc_zed_channel_tb {/hgc_zed_channel_tb/reg3_out(4)  } zed_status_4_rcv_memb_full
quietly virtual signal -install /hgc_zed_channel_tb {/hgc_zed_channel_tb/reg3_out(1)  } zed_status_1_send_memb_packet_length_roverflow
quietly virtual signal -install /hgc_zed_channel_tb {/hgc_zed_channel_tb/reg3_out(0)  } zed_status_0_send_mem_not_empty
quietly WaveActivateNextPane {} 0
add wave -noupdate /hgc_zed_channel_tb/clk_40
add wave -noupdate /hgc_zed_channel_tb/clk_80
add wave -noupdate /hgc_zed_channel_tb/testid
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/rx_data
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/tx_data
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/reg0_in
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/reg1_in
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/reg2_in
add wave -noupdate -radix hexadecimal -subitemconfig {/hgc_zed_channel_tb/reg3_in(31) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_in(30) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_in(29) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_in(28) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_in(27) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_in(26) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_in(25) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_in(24) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_in(23) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_in(22) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_in(21) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_in(20) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_in(19) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_in(18) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_in(17) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_in(16) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_in(15) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_in(14) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_in(13) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_in(12) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_in(11) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_in(10) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_in(9) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_in(8) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_in(7) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_in(6) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_in(5) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_in(4) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_in(3) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_in(2) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_in(1) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_in(0) {-height 18 -radix hexadecimal}} /hgc_zed_channel_tb/reg3_in
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/reg0_out
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/reg1_out
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/reg2_out
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/zed_status_31_24_rcv_memb_packet_length32
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/zed_status_23_16_send_mema_packet_length32
add wave -noupdate /hgc_zed_channel_tb/zed_status_15_MFSMstatRCVTRIGGER
add wave -noupdate /hgc_zed_channel_tb/zed_status_14_MFSMstatRCVFULL
add wave -noupdate /hgc_zed_channel_tb/zed_status_13_MFSMstatRCVPACKET
add wave -noupdate /hgc_zed_channel_tb/zed_status_12_MFSMstatERROR
add wave -noupdate /hgc_zed_channel_tb/zed_status_11_MFSMstatTIMEOUT
add wave -noupdate /hgc_zed_channel_tb/zed_status_10_MFSMstatSYNC
add wave -noupdate /hgc_zed_channel_tb/zed_status_9_MFSMstatBUSY
add wave -noupdate /hgc_zed_channel_tb/zed_status_8_MFSMstatIDLE
add wave -noupdate /hgc_zed_channel_tb/zed_status_5_rcv_memb_packet_length_woverflow
add wave -noupdate /hgc_zed_channel_tb/zed_status_4_rcv_memb_full
add wave -noupdate /hgc_zed_channel_tb/zed_status_1_send_memb_packet_length_roverflow
add wave -noupdate /hgc_zed_channel_tb/zed_status_0_send_mem_not_empty
add wave -noupdate -radix hexadecimal -subitemconfig {/hgc_zed_channel_tb/reg3_out(31) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_out(30) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_out(29) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_out(28) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_out(27) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_out(26) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_out(25) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_out(24) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_out(23) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_out(22) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_out(21) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_out(20) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_out(19) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_out(18) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_out(17) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_out(16) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_out(15) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_out(14) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_out(13) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_out(12) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_out(11) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_out(10) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_out(9) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_out(8) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_out(7) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_out(6) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_out(5) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_out(4) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_out(3) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_out(2) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_out(1) {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/reg3_out(0) {-height 18 -radix hexadecimal}} /hgc_zed_channel_tb/reg3_out
add wave -noupdate /hgc_zed_channel_tb/rx_data_delay
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/tb_cnt
add wave -noupdate /glbl/GSR
add wave -noupdate -divider -height 30 MasterFSM.vhd
add wave -noupdate -subitemconfig {/hgc_zed_channel_tb/uut/zynq_in.send_memb_rdata {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/uut/zynq_in.sym_recieved {-height 18 -radix hexadecimal}} -expand -subitemconfig {/hgc_zed_channel_tb/uut/zynq_in.send_memb_rdata {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/uut/zynq_in.sym_recieved {-height 18 -radix hexadecimal}} /hgc_zed_channel_tb/uut/zynq_in
add wave -noupdate -subitemconfig {/hgc_zed_channel_tb/uut/zynq_out.rcv_memb_wdata {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/uut/zynq_out.sym_to_send {-height 18 -radix hexadecimal}} -expand -subitemconfig {/hgc_zed_channel_tb/uut/zynq_out.rcv_memb_wdata {-height 18 -radix hexadecimal} /hgc_zed_channel_tb/uut/zynq_out.sym_to_send {-height 18 -radix hexadecimal}} /hgc_zed_channel_tb/uut/zynq_out
add wave -noupdate /hgc_zed_channel_tb/uut/masterfsm_inst/state
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/uut/masterfsm_inst/delay_cnt
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/uut/masterfsm_inst/time_out
add wave -noupdate /hgc_zed_channel_tb/uut/masterfsm_inst/wait_once
add wave -noupdate -divider -height 30 align_deser_data.vhd
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/uut/align_deser_data_inst/deser_data
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/uut/align_deser_data_inst/deser_data_offset
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/uut/align_deser_data_inst/deser_data_aligned
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/uut/align_deser_data_inst/deser_data_15to0_ff
add wave -noupdate -divider -height 30 ctrl_send_mem.vhd
add wave -noupdate -divider inputs
add wave -noupdate /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/clear
add wave -noupdate /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/reset
add wave -noupdate /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/sw_send_mema_rst_wrpointer
add wave -noupdate /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/sw_send_mema_incr
add wave -noupdate /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/sw_send_mema_write
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/sw_send_mema_wdata
add wave -noupdate /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/sw_send_memb_send_packet
add wave -noupdate /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_memb_readnext
add wave -noupdate -divider outputs
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/sw_send_mema_rdata
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_memb_rdata
add wave -noupdate /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_memb_rdata_stb
add wave -noupdate -radix hexadecimal -subitemconfig {/hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mema_packet_length32(7) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mema_packet_length32(6) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mema_packet_length32(5) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mema_packet_length32(4) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mema_packet_length32(3) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mema_packet_length32(2) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mema_packet_length32(1) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mema_packet_length32(0) {-radix hexadecimal}} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mema_packet_length32
add wave -noupdate /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_memb_packet_length_roverflow
add wave -noupdate /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_memb_not_empty
add wave -noupdate -divider tdpram_32x256
add wave -noupdate /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_wea
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_addra
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_dina
add wave -noupdate -radix hexadecimal -subitemconfig {/hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_douta(31) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_douta(30) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_douta(29) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_douta(28) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_douta(27) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_douta(26) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_douta(25) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_douta(24) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_douta(23) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_douta(22) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_douta(21) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_douta(20) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_douta(19) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_douta(18) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_douta(17) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_douta(16) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_douta(15) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_douta(14) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_douta(13) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_douta(12) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_douta(11) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_douta(10) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_douta(9) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_douta(8) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_douta(7) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_douta(6) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_douta(5) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_douta(4) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_douta(3) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_douta(2) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_douta(1) {-radix hexadecimal} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_douta(0) {-radix hexadecimal}} /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_douta
add wave -noupdate /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_web
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_addrb
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_dinb
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/uut/ctrl_send_mem_inst/send_mem_doutb
add wave -noupdate -divider -height 30 ctrl_rcv_mem.vhd
add wave -noupdate -divider inputs
add wave -noupdate /hgc_zed_channel_tb/uut/ctrl_rcv_mem_inst/reset
add wave -noupdate /hgc_zed_channel_tb/uut/ctrl_rcv_mem_inst/clear
add wave -noupdate /hgc_zed_channel_tb/uut/ctrl_rcv_mem_inst/sw_rcv_mema_rst_rpointer
add wave -noupdate /hgc_zed_channel_tb/uut/ctrl_rcv_mem_inst/sw_rcv_mema_incr
add wave -noupdate /hgc_zed_channel_tb/uut/ctrl_rcv_mem_inst/rcv_memb_rst_wpointer
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/uut/ctrl_rcv_mem_inst/rcv_memb_wdata
add wave -noupdate /hgc_zed_channel_tb/uut/ctrl_rcv_mem_inst/rcv_memb_wdata_stb
add wave -noupdate -divider outputs
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/uut/ctrl_rcv_mem_inst/sw_rcv_mema_rdata
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/uut/ctrl_rcv_mem_inst/rcv_memb_packet_length32
add wave -noupdate /hgc_zed_channel_tb/uut/ctrl_rcv_mem_inst/rcv_memb_packet_length_woverflow
add wave -noupdate /hgc_zed_channel_tb/uut/ctrl_rcv_mem_inst/rcv_memb_full
add wave -noupdate -divider tdpram_32x256
add wave -noupdate /hgc_zed_channel_tb/uut/ctrl_rcv_mem_inst/rcv_mem_wea
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/uut/ctrl_rcv_mem_inst/rcv_mem_addra
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/uut/ctrl_rcv_mem_inst/rcv_mem_dina
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/uut/ctrl_rcv_mem_inst/rcv_mem_douta
add wave -noupdate /hgc_zed_channel_tb/uut/ctrl_rcv_mem_inst/rcv_mem_web
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/uut/ctrl_rcv_mem_inst/rcv_mem_addrb
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/uut/ctrl_rcv_mem_inst/rcv_mem_dinb
add wave -noupdate -radix hexadecimal /hgc_zed_channel_tb/uut/ctrl_rcv_mem_inst/rcv_mem_doutb
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {23637500 ps} 0} {{Cursor 2} {25912500 ps} 0}
configure wave -namecolwidth 530
configure wave -valuecolwidth 114
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
WaveRestoreZoom {22020143 ps} {26754839 ps}
