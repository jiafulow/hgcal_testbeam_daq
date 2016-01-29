-- ****************************************************************************
--	MODULE  	: hgc_zed_channel_tb.vhd
--	AUTHOR  	: Cristian Gingu
--	VERSION 	: v1.00
--	DATE		: 01.11.2016
-- ****************************************************************************
--	REVISION HISTORY:
--	-----------------
-- ****************************************************************************
--	FUNCTION DESCRIPTION:
-------------------------------------------------------------------------------
-- Ports description:
-------------------------------------------------------------------------------
-- ****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.hgc_pck.all;

entity hgc_zed_channel_tb is
end hgc_zed_channel_tb;

architecture bhv of hgc_zed_channel_tb is 
--
component hgc_zed_channel
	generic (
	C_S_AXI_DATA_WIDTH	: integer	:= 32
	);
	port ( 
	-- Ports to/from UPPER in hierarchy WRAPPER file
	-- custom AXI IP module hgc_zed_ip_v1_0.vhd
	CLK_40    : in std_logic;
	RX_DATA   : in std_logic_vector(7 downto 0);
	TX_DATA   : out std_logic_vector(7 downto 0);
	--
	-- Ports to/from SAME LEVEL of hierarchy 
	-- custom AXI IP module hgc_zed_ip_v1_0_S00_AXI.vhd
	reg0_in   : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	reg1_in   : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	reg2_in   : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	reg3_in   : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	reg0_out  : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	reg1_out  : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	reg2_out  : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	reg3_out  : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0)
	);
end component;
--
constant AXI_DATA_WIDTH : integer	:= 32;
--
signal CLK_40    : std_logic:='0';
signal CLK_80    : std_logic:='0';
signal RX_DATA   : std_logic_vector(7 downto 0):=(others=>'0');
signal TX_DATA   : std_logic_vector(7 downto 0):=(others=>'0');
--
signal reg0_in   : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
signal reg1_in   : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
signal reg2_in   : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
signal reg3_in   : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
signal reg0_out  : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
signal reg1_out  : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
signal reg2_out  : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
signal reg3_out  : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
--
signal testid           :string(1 to 10) := "          ";  -- test bench tracking id
constant CLK_40_Period  : time := 25.0 ns;
signal rx_data_delay    : time := 10*CLK_40_Period;
signal RX_DATA_delyed   : std_logic_vector(7 downto 0):=(others=>'0');
signal tb_cnt           : std_logic_vector(7 downto 0):=(others=>'0');
--
signal MFSMstatIDLE           : std_logic;
signal MFSMstatBUSY           : std_logic;
signal MFSMstatSYNC           : std_logic;
signal MFSMstatTIMEOUT        : std_logic;
signal MFSMstatERROR          : std_logic;
signal MFSMstatRCVPACKET      : std_logic;
signal MFSMstatRCVFULL        : std_logic;
signal MFSMstatRCVTRIGGER     : std_logic;
--
signal ZCTRL_SEND_MEM_RST_WRPOINTER : std_logic:='0';
signal ZCTRL_SEND_MEM_INCR          : std_logic:='0';
signal ZCTRL_SEND_MEM_WRITE         : std_logic:='0';
signal ZCTRL_RCV_MEM_RST_RPOINTER   : std_logic:='0';
signal ZCTRL_RCV_MEM_INCR           : std_logic:='0';
signal ZCTRL_MFSM_CLEAR_ERR         : std_logic:='0';
signal ZCTRL_MFSM_SEND_SYNC         : std_logic:='0';
signal ZCTRL_MFSM_SEND_TRIGGER      : std_logic:='0';
signal ZCTRL_MFSM_SEND_PACKET       : std_logic:='0';
signal ZCTRL_RESET_FPGA             : std_logic:='0';
--
--
BEGIN
--
uut: hgc_zed_channel 
generic map(
	C_S_AXI_DATA_WIDTH	=> AXI_DATA_WIDTH
)
port map(
	-- Ports to/from UPPER in hierarchy WRAPPER file
	-- custom AXI IP module hgc_zed_ip_v1_0.vhd
	CLK_40    => CLK_40,
	RX_DATA   => RX_DATA,
	TX_DATA   => TX_DATA,
	--
	-- Ports to/from SAME LEVEL of hierarchy 
	-- custom AXI IP module hgc_zed_ip_v1_0_S00_AXI.vhd
	reg0_in   => reg0_in,
	reg1_in   => reg1_in,
	reg2_in   => reg2_in,
	reg3_in   => reg3_in,
	reg0_out  => reg0_out,
	reg1_out  => reg1_out,
	reg2_out  => reg2_out,
	reg3_out  => reg3_out
);
--
CLK_40  <= not CLK_40 after 0.5*CLK_40_Period;
RX_DATA_delyed <= transport TX_DATA after rx_data_delay;
--
MFSMstatIDLE           <= reg3_out(8);
MFSMstatBUSY           <= reg3_out(9);
MFSMstatSYNC           <= reg3_out(10);
MFSMstatTIMEOUT        <= reg3_out(11);
MFSMstatERROR          <= reg3_out(12);
MFSMstatRCVPACKET      <= reg3_out(13);
MFSMstatRCVFULL        <= reg3_out(14);
MFSMstatRCVTRIGGER     <= reg3_out(15);
--
reg3_in(0)  <= ZCTRL_SEND_MEM_RST_WRPOINTER;
reg3_in(1)  <= ZCTRL_SEND_MEM_INCR;
reg3_in(2)  <= ZCTRL_SEND_MEM_WRITE;
reg3_in(3)  <= '0';
reg3_in(4)  <= ZCTRL_RCV_MEM_RST_RPOINTER;
reg3_in(5)  <= ZCTRL_RCV_MEM_INCR;
reg3_in(6)  <= '0';
reg3_in(7)  <= '0';
reg3_in(8)  <= ZCTRL_MFSM_CLEAR_ERR;
reg3_in(9)  <= ZCTRL_MFSM_SEND_SYNC;
reg3_in(10) <= ZCTRL_MFSM_SEND_TRIGGER;
reg3_in(11) <= ZCTRL_MFSM_SEND_PACKET;
reg3_in(14 downto 12) <= "000";
reg3_in(15) <= ZCTRL_RESET_FPGA;
reg3_in(31 downto 16) <= X"0000";
--
--
--
--
-- *** Test Bench - User Defined Section ***
tb: PROCESS
--
BEGIN
--
reg0_in     <= X"00000000";
reg1_in     <= X"00000000";
reg2_in     <= X"00000000";
--
wait until rising_edge(CLK_40);
--	
-- ****************************************************************************
-- TEST 1.0. Start up... simulate the power on process. 
-- The GSR (GlobalSetReset) forces async reset...
-- Testing MasterFSM.vhd and align_deserdata.vhd.
-- ****************************************************************************
testid   <= "TST 1.0   ";
-- wait for MasterFSM: sync_find, sync_stable, idle_find, idle_stable, idle
wait until MFSMstatSYNC = '1';
wait for 20*CLK_40_Period;
--	
-- ****************************************************************************
-- TEST 1.1. 
-- Testing MasterFSM.vhd and align_deser_data.vhd.
--
-- The "tb_rx_data" process shifts the RX data such as:
-- RX_DATA <= RX_DATA_delyed(3 downto 0) & RX_DATA_delyed(7 downto 4);
-- Check that align_deser_data->deser_data_offset goes to 4 and 
-- Wait for MasterFSM: sync_find, sync_stable, idle_find, idle_stable, idle
-- ****************************************************************************
testid   <= "TST 1.1   ";
wait until MFSMstatSYNC = '1';
wait for 20*CLK_40_Period;
--	
-- ****************************************************************************
-- TEST 1.2. 
-- Testing MasterFSM.vhd and align_deserdata.vhd.
--
-- The "tb_rx_data" process shifts the RX data such as:
-- RX_DATA <= RX_DATA_delyed(1 downto 0) & RX_DATA_delyed(7 downto 2);
-- Check that align_deser_data->deser_data_offset goes to 6 and 
-- Wait for MasterFSM: sync_find, sync_stable, idle_find, idle_stable, idle
-- ****************************************************************************
testid   <= "TST 1.2   ";
wait until MFSMstatSYNC = '1';
wait for 20*CLK_40_Period;
--	
-- ****************************************************************************
-- TEST 1.3. 
-- Testing MasterFSM.vhd and align_deserdata.vhd.
--
-- The "tb_rx_data" process shifts the RX data such as:
-- RX_DATA <= RX_DATA_delyed;
-- Check that align_deser_data->deser_data_offset goes to 0 and 
-- Wait for MasterFSM: sync_find, sync_stable, idle_find, idle_stable, idle
-- ****************************************************************************
testid   <= "TST 1.3   ";
wait until MFSMstatSYNC = '1';
wait for 20*CLK_40_Period;
--	
-- ****************************************************************************
-- TEST 2.1. 
-- Testing command CLEAR_ERR.
-- ****************************************************************************
testid   <= "TST 2.1   ";
wait for 1*CLK_40_Period; ZCTRL_MFSM_CLEAR_ERR <= '1';
wait for 1*CLK_40_Period; ZCTRL_MFSM_CLEAR_ERR <= '0';
wait for 20*CLK_40_Period;
--	
-- ****************************************************************************
-- TEST 2.2. 
-- Testing command SEND_SYNC.
-- ****************************************************************************
testid   <= "TST 2.2   ";
wait for 1*CLK_40_Period; ZCTRL_MFSM_SEND_SYNC <= '1';
wait for 1*CLK_40_Period; ZCTRL_MFSM_SEND_SYNC <= '0';
wait until MFSMstatSYNC = '1';
wait for 20*CLK_40_Period;
--	
-- ****************************************************************************
-- TEST 2.3. 
-- Testing command SEND_TRIG.
-- ****************************************************************************
testid   <= "TST 2.3   ";
wait for 1*CLK_40_Period; ZCTRL_MFSM_SEND_TRIGGER <= '1';
wait for 1*CLK_40_Period; ZCTRL_MFSM_SEND_TRIGGER <= '0';
wait until MFSMstatSYNC = '1' and MFSMstatRCVTRIGGER = '1';
wait for 20*CLK_40_Period;
--	
-- ****************************************************************************
-- TEST 2.4. 
-- Testing command SEND_PACKET.
-- ****************************************************************************
testid   <= "TST 2.4   ";
wait for 1*CLK_40_Period; ZCTRL_MFSM_SEND_PACKET <= '1';
wait for 1*CLK_40_Period; ZCTRL_MFSM_SEND_PACKET <= '0';
wait for 20*CLK_40_Period;
--	
-- ****************************************************************************
-- TEST 2.5. 
-- Testing command RESET_FPGA.
-- ****************************************************************************
testid   <= "TST 2.5   ";
wait for 1*CLK_40_Period; ZCTRL_RESET_FPGA <= '1';
wait for 1*CLK_40_Period; ZCTRL_RESET_FPGA <= '0';
wait until MFSMstatSYNC = '1';
wait for 20*CLK_40_Period;
--	
-- ****************************************************************************
-- TEST 2.6. 
-- Testing symbol received SYM_TRIGG.
-- ****************************************************************************
testid   <= "TST 2.6   ";
wait for 1*CLK_40_Period;
wait for 1*CLK_40_Period;
wait until MFSMstatRCVTRIGGER = '1';
wait for 20*CLK_40_Period;
--	
-- ****************************************************************************
-- TEST 2.7. 
-- Testing symbol received SYM_SYNC.
-- ****************************************************************************
testid   <= "TST 2.7   ";
wait for 1*CLK_40_Period;
wait for 1*CLK_40_Period;
wait until MFSMstatSYNC = '1';
wait for 20*CLK_40_Period;
--	
-- ****************************************************************************
-- TEST 2.8. 
-- Testing symbol received SYM_START.
-- ****************************************************************************
testid   <= "TST 2.8   ";
wait for 1*CLK_40_Period;
wait for 1*CLK_40_Period;
wait until MFSMstatERROR = '1';
wait for 20*CLK_40_Period;
--	
-- ****************************************************************************
-- TEST 2.1. 
-- Testing command CLEAR_ERR.
-- ****************************************************************************
testid   <= "TST 2.1   ";
wait for 1*CLK_40_Period; ZCTRL_MFSM_CLEAR_ERR <= '1';
wait for 1*CLK_40_Period; ZCTRL_MFSM_CLEAR_ERR <= '0';
wait for 20*CLK_40_Period;
--	
-- ****************************************************************************
-- TEST 2.9. 
-- Testing symbol received TYPE_DATA (value SYM_1010=decimal_10).
-- ****************************************************************************
testid   <= "TST 2.9   ";
wait for 1*CLK_40_Period;
wait for 1*CLK_40_Period;
wait until MFSMstatERROR = '1';
wait for 20*CLK_40_Period;
--	
-- ****************************************************************************
-- TEST 2.1. 
-- Testing command CLEAR_ERR.
-- ****************************************************************************
testid   <= "TST 2.1   ";
wait for 1*CLK_40_Period; ZCTRL_MFSM_CLEAR_ERR <= '1';
wait for 1*CLK_40_Period; ZCTRL_MFSM_CLEAR_ERR <= '0';
wait for 20*CLK_40_Period;
--
-- ****************************************************************************
-- TEST 3.1. 
-- Testing ctrl_send_mem.vhd; WRITE (and READ) send mem packet.
-- a) SW Write / Read send_mem
-- b) SW send the command SEND_PACKET.
-- c) SW wait until MFSMstatRCVPACKET = '1'
-- d) SW Read rcv_mem
-- ****************************************************************************
testid   <= "TST 3.1   ";
-- TESTBENCH: set rx_data_delay to be longer than the time required to send out
-- a packet consisting in three 32-bit words (minim 3*(32/4)=24 CLK_40_Period)
rx_data_delay <= 30*CLK_40_Period;
--
-- sw reset send_mem address pointer
wait for 1*CLK_40_Period; ZCTRL_SEND_MEM_RST_WRPOINTER <= '1';
wait for 5*CLK_40_Period; ZCTRL_SEND_MEM_RST_WRPOINTER <= '0';
--
wait for 1*CLK_40_Period; reg0_in <= X"12345678";
-- sw write send_mem data input from register reg0_in
wait for 1*CLK_40_Period; ZCTRL_SEND_MEM_WRITE <= '1';
wait for 5*CLK_40_Period; ZCTRL_SEND_MEM_WRITE <= '0';
-- sw read send_mem data output from register reg0_out
wait for 10*CLK_40_Period;
--
-- sw incremet send_mem address pointer
wait for 1*CLK_40_Period; ZCTRL_SEND_MEM_INCR <= '1';
wait for 5*CLK_40_Period; ZCTRL_SEND_MEM_INCR <= '0';
wait for 1*CLK_40_Period; reg0_in <= X"9abcdef0";
-- sw write send_mem data input from register reg0_in
wait for 1*CLK_40_Period; ZCTRL_SEND_MEM_WRITE <= '1';
wait for 5*CLK_40_Period; ZCTRL_SEND_MEM_WRITE <= '0';
-- sw read send_mem data output from register reg0_out
wait for 10*CLK_40_Period;
--
-- sw incremet send_mem address pointer
wait for 1*CLK_40_Period; ZCTRL_SEND_MEM_INCR <= '1';
wait for 5*CLK_40_Period; ZCTRL_SEND_MEM_INCR <= '0';
wait for 1*CLK_40_Period; reg0_in <= X"87654321";
-- sw write send_mem data input from register reg0_in
wait for 1*CLK_40_Period; ZCTRL_SEND_MEM_WRITE <= '1';
wait for 5*CLK_40_Period; ZCTRL_SEND_MEM_WRITE <= '0';
-- sw read send_mem data output from register reg0_out
wait for 10*CLK_40_Period;
--
-- sw incremet send_mem address pointer (before sending the packet
wait for 1*CLK_40_Period; ZCTRL_SEND_MEM_INCR <= '1';
wait for 5*CLK_40_Period; ZCTRL_SEND_MEM_INCR <= '0';
--
wait for 10*CLK_40_Period;
--	
-- sw command SEND_PACKET 
wait for 1*CLK_40_Period; ZCTRL_MFSM_SEND_PACKET <= '1';
wait for 5*CLK_40_Period; ZCTRL_MFSM_SEND_PACKET <= '0';
wait until MFSMstatRCVPACKET = '1';
wait for 20*CLK_40_Period;
--
-- sw reset rcv_mem address pointer
wait for 1*CLK_40_Period; ZCTRL_RCV_MEM_RST_RPOINTER <= '1';
wait for 5*CLK_40_Period; ZCTRL_RCV_MEM_RST_RPOINTER <= '0';
-- sw read rcv_mem data output from register reg1_out
wait for 10*CLK_40_Period;
--
-- sw incremet rcv_mem address pointer
wait for 1*CLK_40_Period; ZCTRL_RCV_MEM_INCR <= '1';
wait for 5*CLK_40_Period; ZCTRL_RCV_MEM_INCR <= '0';
-- sw read rcv_mem data output from register reg1_out
wait for 10*CLK_40_Period;
--
-- sw incremet rcv_mem address pointer
wait for 1*CLK_40_Period; ZCTRL_RCV_MEM_INCR <= '1';
wait for 5*CLK_40_Period; ZCTRL_RCV_MEM_INCR <= '0';
-- sw read rcv_mem data output from register reg1_out
wait for 10*CLK_40_Period;
--
--
wait for 10*CLK_40_Period;
--
testid   <= "TST END   ";
wait; -- will wait forever
--
END PROCESS;
-- *** End Test Bench - User Defined Section ***
--
tb_rx_data: process(CLK_40)
begin
	if CLK_40'event then
--		RX_DATA <= transport TX_DATA after rx_data_delay;
		if testid = "TST 1.1   " then
			RX_DATA <= RX_DATA_delyed(3 downto 0) & RX_DATA_delyed(7 downto 4);
		elsif testid = "TST 1.2   " then
			RX_DATA <= RX_DATA_delyed(1 downto 0) & RX_DATA_delyed(7 downto 2);
		elsif testid = "TST 2.6   " then
			RX_DATA <= SYM_TRIGG;
			tb_cnt  <= (others=>'0');
		elsif testid = "TST 2.7   " then
			if tb_cnt = conv_std_logic_vector(20,8) then
				RX_DATA <= RX_DATA_delyed;
				tb_cnt  <= tb_cnt;
			else
				RX_DATA <= SYM_SYNC;
				tb_cnt  <= tb_cnt + 1;
			end if;
		elsif testid = "TST 2.8   " then
			if tb_cnt = conv_std_logic_vector(40,8) then
				RX_DATA <= RX_DATA_delyed;
				tb_cnt  <= tb_cnt;
			else
				RX_DATA <= SYM_START;
				tb_cnt  <= tb_cnt + 1;
			end if;			
		elsif testid = "TST 2.9   " then
			if tb_cnt = conv_std_logic_vector(60,8) then
				RX_DATA <= RX_DATA_delyed;
				tb_cnt  <= tb_cnt;
			else
				RX_DATA <= SYM_1010;
				tb_cnt  <= tb_cnt + 1;
			end if;
			
		else
		
			RX_DATA <= RX_DATA_delyed;
		end if;
	end if;
end process;
--
END;