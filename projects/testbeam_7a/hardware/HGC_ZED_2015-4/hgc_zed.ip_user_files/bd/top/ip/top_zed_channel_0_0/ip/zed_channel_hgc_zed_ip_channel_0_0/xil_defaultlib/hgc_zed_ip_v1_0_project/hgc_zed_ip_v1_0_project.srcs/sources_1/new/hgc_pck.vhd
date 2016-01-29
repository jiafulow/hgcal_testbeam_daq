library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--library UNISIM;
--use UNISIM.VComponents.all;

package hgc_pck is
	--
	constant CMD_SYNC   : std_logic_vector(5 downto 0):="111000";
	constant CMD_TRIG   : std_logic_vector(5 downto 0):="000111";
	--
	constant SYM_IDLE   : std_logic_vector(7 downto 0):="11110000"; -- dec=240 = 4*60 + 0
	constant SYM_START  : std_logic_vector(7 downto 0):="11101000"; -- dec=232 = 4*58 + 0
	constant SYM_TRIGG  : std_logic_vector(7 downto 0):="11100100"; -- dec=228 = 4*57 + 0
	constant SYM_SYNC   : std_logic_vector(7 downto 0):="11100010"; -- dec=226 = 4*56 + 2
	--
	constant SYM_0000   : std_logic_vector(7 downto 0):="01010101"; -- dec=85  = 4*21 + 1
	constant SYM_0001   : std_logic_vector(7 downto 0):="01010110"; -- dec=86  = 4*21 + 2
	constant SYM_0010   : std_logic_vector(7 downto 0):="01011001"; -- dec=89  = 4*22 + 1
	constant SYM_0011   : std_logic_vector(7 downto 0):="01011010"; -- dec=90  = 4*22 + 2
	constant SYM_0100   : std_logic_vector(7 downto 0):="01100101"; -- dec=101 = 4*25 + 1
	constant SYM_0101   : std_logic_vector(7 downto 0):="01100110"; -- dec=102 = 4*25 + 2
	constant SYM_0110   : std_logic_vector(7 downto 0):="01101001"; -- dec=105 = 4*26 + 1
	constant SYM_0111   : std_logic_vector(7 downto 0):="01101010"; -- dec=106 = 4*26 + 2
	constant SYM_1000   : std_logic_vector(7 downto 0):="10010101"; -- dec=149 = 4*37 + 1
	constant SYM_1001   : std_logic_vector(7 downto 0):="10010110"; -- dec=150 = 4*37 + 2
	constant SYM_1010   : std_logic_vector(7 downto 0):="10011001"; -- dec=153 = 4*38 + 1
	constant SYM_1011   : std_logic_vector(7 downto 0):="10011010"; -- dec=154 = 4*38 + 2
	constant SYM_1100   : std_logic_vector(7 downto 0):="10100101"; -- dec=165 = 4*41 + 1
	constant SYM_1101   : std_logic_vector(7 downto 0):="10100110"; -- dec=166 = 4*41 + 2
	constant SYM_1110   : std_logic_vector(7 downto 0):="10101001"; -- dec=169 = 4*42 + 1
	constant SYM_1111   : std_logic_vector(7 downto 0):="10101010"; -- dec=170 = 4*42 + 2
	--
	--
    type SYM_TYPE is (TYPE_INVALID, TYPE_DATA, TYPE_SYNC, TYPE_IDLE, TYPE_START, TYPE_TRIG);
	--
	--
-- **************************************************************************** 
-- The 32-bit ZED_CTRL register has the following bit-assignment:
-- (use type 'integer' for 32-bit or 64-bit, 'natural' for >=0, 'positive' for >0)
-- ****************************************************************************
-- 1. Software Application is WRITING these "command" bits (send_mem related, 4-bits):
	constant ZCTRL_INDEX_SEND_MEM_RST_WRPOINTER          : integer := 0 ;
	constant ZCTRL_INDEX_SEND_MEM_INCR                   : integer := 1 ;
	constant ZCTRL_INDEX_SEND_MEM_WRITE                  : integer := 2 ;
--	constant spare                                       : integer := 3 ;
-------------------------------------------------------------------------------
-- 2. Software Application is WRITING these "command" bits (rcv_mem related, 4-bits):
	constant ZCTRL_INDEX_RCV_MEM_RST_RPOINTER            : integer := 4 ;
	constant ZCTRL_INDEX_RCV_MEM_INCR                    : integer := 5 ;
--	constant spare                                       : integer := 6 ;
--	constant spare                                       : integer := 7 ;
-------------------------------------------------------------------------------
-- 3. Software Application is WRITING these "command" bits (MasterFSM related, 8-bits):
	constant ZCTRL_INDEX_MFSM_CLEAR_ERR                  : integer := 8 ;  -- PMR: ctrl_CLEAR_ERR
	constant ZCTRL_INDEX_MFSM_SEND_SYNC                  : integer := 9  ; -- PMR: ctrl_SYNC
	constant ZCTRL_INDEX_MFSM_SEND_TRIGGER               : integer := 10 ; -- PMR: ctrl_SEND_TRIG
	constant ZCTRL_INDEX_MFSM_SEND_PACKET                : integer := 11 ; -- PMR: ctrl_SEND_DATA
--	constant spare                                       : integer := 12 ;
--	constant spare                                       : integer := 13 ;
--	constant spare                                       : integer := 14 ;
	constant ZCTRL_INDEX_RESET_FPGA                      : integer := 15 ;
	constant ctrl_CLEAR_ERR         : std_logic_vector(7 downto 0):=X"01";
	constant ctrl_SEND_SYNC         : std_logic_vector(7 downto 0):=X"02";
	constant ctrl_SEND_TRIG         : std_logic_vector(7 downto 0):=X"04";
	constant ctrl_SEND_DATA         : std_logic_vector(7 downto 0):=X"08";
	constant ctrl_RESET_FPGA        : std_logic_vector(7 downto 0):=X"80";
-------------------------------------------------------------------------------
-- 4. Software Application is WRITING these "command" bits (.... related, 16-bits):
--	constant spare                                          : integer := 16 ;
--	constant spare                                          : integer := 17 ;
--	constant spare                                          : integer := 18 ;
--	constant spare                                          : integer := 19 ;
--	constant spare                                          : integer := 20 ;
--	constant spare                                          : integer := 21 ;
--	constant spare                                          : integer := 22 ;
--	constant spare                                          : integer := 23 ;
--	constant spare                                          : integer := 24 ;
--	constant spare                                          : integer := 25 ;
--	constant spare                                          : integer := 26 ;
--	constant spare                                          : integer := 27 ;
--	constant spare                                          : integer := 28 ;
--	constant spare                                          : integer := 29 ;
--	constant spare                                          : integer := 30 ;
--	constant spare                                          : integer := 31 ;
-------------------------------------------------------------------------------
	--
	--
-- **************************************************************************** 
-- The 32-bit ZED_STATUS register has the following bit-assignment:
-- (use type 'integer' for 32-bit or 64-bit, 'natural' for >=0, 'positive' for >0)
-- ****************************************************************************
-- 1. Software Application is READING these "status" bits (send_mem related, 4-bits): ??? NO send_mem status bits ???
	constant ZSTATUS_INDEX_SEND_MEM_NOT_EMPTY            : integer := 0 ;
	constant ZSTATUS_INDEX_SEND_MEM_ROVERFLOW            : integer := 1 ;
--	constant spare                                       : integer := 2 ;
--	constant spare                                       : integer := 3 ;
-------------------------------------------------------------------------------
-- 2. Software Application is READING these "status" bits (rcv_mem related, 4-bits):
	constant ZSTATUS_INDEX_RCV_MEM_FULL                  : integer := 4 ;
	constant ZSTATUS_INDEX_RCV_MEM_WOVERFLOW             : integer := 5 ;
--	constant spare                                       : integer := 6 ;
--	constant spare                                       : integer := 7 ;
-------------------------------------------------------------------------------
-- 3. Software Application is READING these "status" bits (MasterFSM related, 8-bits):
-------------------------------------------------------------------------------
	constant ZSTATUS_INDEX_HW_MFSM_IDLE                  : integer := 8 ;  -- PMR: statIDLE
	constant ZSTATUS_INDEX_HW_MFSM_BUSY                  : integer := 9 ;  -- PMR: statBUSY
	constant ZSTATUS_INDEX_HW_MFSM_SYNC                  : integer := 10 ; -- PMR: statSYNC
	constant ZSTATUS_INDEX_HW_MFSM_TIMEOUT               : integer := 11 ; -- PMR: statTIMEOUT
	constant ZSTATUS_INDEX_HW_MFSM_ERROR                 : integer := 12 ; -- PMR: statERROR
	constant ZSTATUS_INDEX_HW_MFSM_RCV_NEW_PACKET        : integer := 13 ;
	constant ZSTATUS_INDEX_HW_MFSM_RCV_FULL              : integer := 14 ;
	constant ZSTATUS_INDEX_HW_MFSM_RCV_TRIGGER           : integer := 15 ;
	constant MFSMstatIDLE           : std_logic_vector(7 downto 0):=X"01"; -- is it necessary?? IDLE=not(BUSY)...
	constant MFSMstatBUSY           : std_logic_vector(7 downto 0):=X"02";
	constant MFSMstatSYNC           : std_logic_vector(7 downto 0):=X"04";
	constant MFSMstatTIMEOUT        : std_logic_vector(7 downto 0):=X"08";
	constant MFSMstatERROR          : std_logic_vector(7 downto 0):=X"10";
	constant MFSMstatRCVPACKET      : std_logic_vector(7 downto 0):=X"20";
	constant MFSMstatRCVFULL        : std_logic_vector(7 downto 0):=X"40"; -- should be included in MFSMstatERROR ???
	constant MFSMstatRCVTRIGGER     : std_logic_vector(7 downto 0):=X"80"; -- should be included in MFSMstatRCVPACKET ???
-------------------------------------------------------------------------------
-- 4. Software Application is READING these "status" bits (.... related, 16-bits):
	constant ZSTATUS_INDEX_SEND_MEM_LENGTH_BIT0             : integer := 16 ;
	constant ZSTATUS_INDEX_SEND_MEM_LENGTH_BIT1             : integer := 17 ;
	constant ZSTATUS_INDEX_SEND_MEM_LENGTH_BIT2             : integer := 18 ;
	constant ZSTATUS_INDEX_SEND_MEM_LENGTH_BIT3             : integer := 19 ;
	constant ZSTATUS_INDEX_SEND_MEM_LENGTH_BIT4             : integer := 20 ;
	constant ZSTATUS_INDEX_SEND_MEM_LENGTH_BIT5             : integer := 21 ;
	constant ZSTATUS_INDEX_SEND_MEM_LENGTH_BIT6             : integer := 22 ;
	constant ZSTATUS_INDEX_SEND_MEM_LENGTH_BIT7             : integer := 23 ;
	constant ZSTATUS_INDEX_RCV_MEM_LENGTH_BIT0              : integer := 24 ;
	constant ZSTATUS_INDEX_RCV_MEM_LENGTH_BIT1              : integer := 25 ;
	constant ZSTATUS_INDEX_RCV_MEM_LENGTH_BIT2              : integer := 26 ;
	constant ZSTATUS_INDEX_RCV_MEM_LENGTH_BIT3              : integer := 27 ;
	constant ZSTATUS_INDEX_RCV_MEM_LENGTH_BIT4              : integer := 28 ;
	constant ZSTATUS_INDEX_RCV_MEM_LENGTH_BIT5              : integer := 29 ;
	constant ZSTATUS_INDEX_RCV_MEM_LENGTH_BIT6              : integer := 30 ;
	constant ZSTATUS_INDEX_RCV_MEM_LENGTH_BIT7              : integer := 31 ;
-------------------------------------------------------------------------------
	--
	--
	constant PACKET_LENGTH32_MAX    : std_logic_vector(7 downto 0):=X"FC";
	--
    --
	type ZYNQ_MASTERFSM_INPUT is
	record
		zCNTRL                      : std_logic_vector(7 downto 0); -- from software application
		send_memb_not_empty         : std_logic;                    -- from ctrl_send_mem.vhd
		send_memb_rdata             : std_logic_vector(31 downto 0);-- from ctrl_send_mem.vhd
		send_memb_rdata_stb         : std_logic;                    -- from ctrl_send_mem.vhd
		rcv_memb_full               : std_logic;                    -- from ctrl_rcv_mem.vhd
--		zfifo_in                    : std_logic_vector(31 downto 0);
--		zfifo_in_not_empty          : std_logic;                    
		sym_recieved_type           : SYM_TYPE;                     -- from mdec_nibble.vhd
		sym_recieved                : std_logic_vector(3 downto 0); -- from mdec_nibble.vhd
	end record;
	--
	--
	type ZYNQ_MASTERFSM_OUTPUT is
	record
		zSTATUS                     : std_logic_vector(7 downto 0); -- to software application
		send_memb_readnext          : std_logic;                    -- to ctrl_send_mem.vhd
		rcv_memb_rst_wpointer       : std_logic;                    -- to ctrl_rcv_mem.vhd
		rcv_memb_wdata              : std_logic_vector(31 downto 0);-- to ctrl_rcv_mem.vhd
		rcv_memb_wdata_stb          : std_logic;                    -- to ctrl_rcv_mem.vhd
		rcv_memb_wdata_done         : std_logic;                    -- to ctrl_rcv_mem.vhd
--		zfifo_out                   : std_logic_vector(31 downto 0);
--		zfifo_out_push             : std_logic;                    
		sym_to_send_type            : SYM_TYPE;                     -- to menc_nibble.vhd
		sym_to_send                 : std_logic_vector(3 downto 0); -- to menc_nibble.vhd
		deser_data_offset           : std_logic_vector(2 downto 0); -- to align_deser_data.vhd
	end record;
	--
	--
--    constant INVALID_SYM         : std_logic_vector(7 downto 0):= x"10";
--    constant SYNC_SYM            : std_logic_vector(7 downto 0):= x"11";
--    constant IDLE_SYM            : std_logic_vector(7 downto 0):= x"12";
--    constant START_SYM           : std_logic_vector(7 downto 0):= x"13";
--    constant TRIG_SYM            : std_logic_vector(7 downto 0):= x"13";
--	-- CG: see SYM_0000 to SYM_1111 defined above
--	constant x00_SYM             : std_logic_vector(7 downto 0):= x"00";
--	constant x01_SYM             : std_logic_vector(7 downto 0):= x"01";
--	constant x02_SYM             : std_logic_vector(7 downto 0):= x"02";
--	constant x03_SYM             : std_logic_vector(7 downto 0):= x"03";
--	constant x04_SYM             : std_logic_vector(7 downto 0):= x"04";
--	constant x05_SYM             : std_logic_vector(7 downto 0):= x"05";
--	constant x06_SYM             : std_logic_vector(7 downto 0):= x"06";
--	constant x07_SYM             : std_logic_vector(7 downto 0):= x"07";
--	constant x08_SYM             : std_logic_vector(7 downto 0):= x"08";
--	constant x09_SYM             : std_logic_vector(7 downto 0):= x"09";
--	constant x0a_SYM             : std_logic_vector(7 downto 0):= x"0a";
--	constant x0b_SYM             : std_logic_vector(7 downto 0):= x"0b";
--	constant x0c_SYM             : std_logic_vector(7 downto 0):= x"0c";
--	constant x0d_SYM             : std_logic_vector(7 downto 0):= x"0d";
--	constant x0e_SYM             : std_logic_vector(7 downto 0):= x"0e";
--	constant x0f_SYM             : std_logic_vector(7 downto 0):= x"0f";
--	-- CG: see ZED_CTRL_FLOW_INDEX_HW_MFSM_xxx defined above
--	constant statIDLE            : std_logic_vector(7 downto 0):= x"00";
--	constant statACK             : std_logic_vector(7 downto 0):= x"01";
--	constant statBUSY            : std_logic_vector(7 downto 0):= x"02";
--	constant statTIMEOUT         : std_logic_vector(7 downto 0):= x"04";
--	constant statERROR           : std_logic_vector(7 downto 0):= x"08";
--	constant statSYNC            : std_logic_vector(7 downto 0):= x"10";
--	-- CG: see ZED_CTRL_FLOW_INDEX_SW_xxx defined above
--	constant ctrl_NOP            : std_logic_vector(7 downto 0):= x"00";
--	constant ctrl_CLEAR_ERR      : std_logic_vector(7 downto 0):= x"01";
--	constant ctrl_SYNC           : std_logic_vector(7 downto 0):= x"02";
--	constant ctrl_SEND_TRIG      : std_logic_vector(7 downto 0):= x"03";
--	constant ctrl_SEND_DATA      : std_logic_vector(7 downto 0):= x"04";
	--
end hgc_pck;

package body hgc_pck is
end hgc_pck;
