-- ****************************************************************************
--	MODULE  	: hgc_zed_channel.vhd
--	AUTHOR  	: Cristian Gingu
--	VERSION 	: v1.00
--	DATE		: 01.07.2016
-- ****************************************************************************
--	REVISION HISTORY:
--	-----------------
-- ****************************************************************************
--	FUNCTION DESCRIPTION:
-------------------------------------------------------------------------------
-- Ports description:
-------------------------------------------------------------------------------
-- ****************************************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.all;

use work.hgc_pck.all;

entity hgc_zed_channel is
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
end hgc_zed_channel;

architecture rtl of hgc_zed_channel is
--
component menc_nibble is
	port ( 
	clk               : in std_logic;
	menc_data_in_type : in SYM_TYPE;
	menc_data_in      : in std_logic_vector(3 downto 0);
	menc_data_out     : out std_logic_vector(7 downto 0)
	);
end component;
--
component mdec_nibble is
	port ( 
	clk                 : in std_logic;
	mdec_data_in        : in std_logic_vector(7 downto 0);
	mdec_data_out_type  : out SYM_TYPE;
	mdec_data_out       : out std_logic_vector(3 downto 0)
	);
end component;
--
component ctrl_send_mem is
	port ( 
	clk                               : in std_logic;
	clear                             : in std_logic;
	reset                             : in std_logic;
	-- Port A interface signals
	sw_send_mema_rst_wrpointer        : in std_logic;
	sw_send_mema_incr                 : in std_logic;
	sw_send_mema_write                : in std_logic;
	sw_send_mema_wdata                : in std_logic_vector(31 downto 0);
	sw_send_mema_rdata                : out std_logic_vector(31 downto 0);
	-- Port B interface signals
	sw_send_memb_send_packet          : in std_logic;
	send_memb_readnext                : in std_logic;
	send_memb_rdata                   : out std_logic_vector(31 downto 0);
	send_memb_rdata_stb               : out std_logic;
	-- Auxiliary signals
	send_mema_packet_length32         : out std_logic_vector(7 downto 0);
	send_memb_packet_length_roverflow : out std_logic;
	send_memb_not_empty               : out std_logic
	--
	);
end component;
--
component ctrl_rcv_mem is
	port ( 
	clk                               : in std_logic;
	clear                             : in std_logic;
	reset                             : in std_logic;
	-- Port A interface signals
	sw_rcv_mema_rst_rpointer          : in std_logic;
	sw_rcv_mema_incr                  : in std_logic;
	sw_rcv_mema_rdata                 : out std_logic_vector(31 downto 0);
	-- Port B interface signals
	rcv_memb_rst_wpointer             : in std_logic;
	rcv_memb_wdata_stb                : in std_logic;
	rcv_memb_wdata                    : in std_logic_vector(31 downto 0);
	-- Auxiliary signals
	rcv_memb_packet_length32          : out std_logic_vector(7 downto 0);
	rcv_memb_packet_length_woverflow  : out std_logic;
	rcv_memb_full                     : out std_logic
	--
	);
end component;
--
component MasterFSM is
	port ( 
	clk        : in std_logic; --40Mhz
	reset      : in std_logic; --system wide
    ZYNQ_IN    : in ZYNQ_MASTERFSM_INPUT;
    ZYNQ_OUT   : out ZYNQ_MASTERFSM_OUTPUT
	);
end component;
--
component align_deser_data is
	port ( 
	clk                 : in std_logic;
	deser_data          : in std_logic_vector(7 downto 0);
	deser_data_offset   : in std_logic_vector(2 downto 0);
	deser_data_aligned  : out std_logic_vector(7 downto 0)
	);
end component;
--
-- Output Signals related to component menc_nibble.vhd
signal menc_data_out        : std_logic_vector(7 downto 0);
--
-- Output Signals related to component mdec_nibble.vhd
signal mdec_data_out_type   : SYM_TYPE;
signal mdec_data_out        : std_logic_vector(3 downto 0);
--
-- Output Signals related to component ctrl_send_mem.vhd
signal send_memb_rdata                    : std_logic_vector(31 downto 0);
signal send_memb_rdata_stb                : std_logic;
signal send_mema_packet_length32          : std_logic_vector(7 downto 0);
signal send_memb_packet_length_roverflow  : std_logic;
signal send_memb_not_empty                : std_logic;
--
-- Output Signals related to component ctrl_rcv_mem
signal sw_rcv_mema_rdata                  : std_logic_vector(31 downto 0);
signal rcv_memb_packet_length32           : std_logic_vector(7 downto 0);
signal rcv_memb_packet_length_woverflow   : std_logic;
signal rcv_memb_full                      : std_logic;
--
-- Signals related to component MasterFSM
signal zynq_in                            : ZYNQ_MASTERFSM_INPUT;
signal zynq_out                           : ZYNQ_MASTERFSM_OUTPUT;
--
-- Output Signals related to component align_deser_data
signal align_deser_data_out               : std_logic_vector(7 downto 0);
--
-- Software Application related signals 
signal zed_command                        : std_logic_vector(31 downto 0);
signal zed_status                         : std_logic_vector(31 downto 0);
signal clear_err                          : std_logic;
signal reset_fpga                         : std_logic;
signal sw_send_mema_rst_wrpointer         : std_logic;
signal sw_send_mema_incr                  : std_logic;
signal sw_send_mema_write                 : std_logic;
signal sw_send_mema_wdata                 : std_logic_vector(31 downto 0);
signal sw_send_mema_rdata                 : std_logic_vector(31 downto 0);
signal sw_send_memb_send_packet           : std_logic;
signal sw_rcv_mema_rst_rpointer           : std_logic;
signal sw_rcv_mema_incr                   : std_logic;
--
--
begin
-- 
--
-- Software Application 32-bit Register related to ctrl_send_mem.vhd (write and read)
sw_send_mema_wdata    <= reg0_in;             -- to   ctrl_send_mem.vhd
reg0_out              <= sw_send_mema_rdata;  -- from ctrl_send_mem.vhd
--
-- Software Application 32-bit Register related to ctrl_rcv_mem.vhd (read only)
--                    <= reg1_in;             -- NOT USED
reg1_out              <= sw_rcv_mema_rdata;   -- from ctrl_send_mem.vhd
--
-- Software Application 32-bit Register related to further uses (write and read)
--                    <= reg2_in;             -- NOT USED: firmware update related...
--reg2_out            <= ;                    -- NOT USED: firmware update related...
reg2_out              <= reg2_in;             -- loop-back, debug, scratch registers...

--
-- Software Application 32-bit Register related to COMMANDS (write) and STATUS (read)
zed_command           <= reg3_in;             -- Software WRITE command
reg3_out              <= zed_status;          -- Software READ  status
--
-- Bit assignments for COMMANDS (write)
sw_send_mema_rst_wrpointer  <= zed_command(ZCTRL_INDEX_SEND_MEM_RST_WRPOINTER);  -- index=0
sw_send_mema_incr           <= zed_command(ZCTRL_INDEX_SEND_MEM_INCR);           -- index=1
sw_send_mema_write          <= zed_command(ZCTRL_INDEX_SEND_MEM_WRITE);          -- index=2
--                                                                               -- index=3
sw_rcv_mema_rst_rpointer    <= zed_command(ZCTRL_INDEX_RCV_MEM_RST_RPOINTER);    -- index=4
sw_rcv_mema_incr            <= zed_command(ZCTRL_INDEX_RCV_MEM_INCR);            -- index=5
--                                                                               -- index=6
--                                                                               -- index=7
clear_err                   <= zed_command(ZCTRL_INDEX_MFSM_CLEAR_ERR);          -- index=8
--                          <= zed_command(ZCTRL_INDEX_MFSM_SEND_SYNC);          -- index=9
--                          <= zed_command(ZCTRL_INDEX_MFSM_SEND_TRIGGER);       -- index=10
sw_send_memb_send_packet    <= zed_command(ZCTRL_INDEX_MFSM_SEND_PACKET);        -- index=11
--                          <= zed_command();                                    -- index=12..14
reset_fpga                  <= zed_command(ZCTRL_INDEX_RESET_FPGA);              -- index=15
--                          <= zed_command();                                    -- index=16..31
--
-- Bit assignments for STATUS (read)
zed_status(ZSTATUS_INDEX_SEND_MEM_NOT_EMPTY)  <= send_memb_not_empty;                 -- index 0
zed_status(ZSTATUS_INDEX_SEND_MEM_ROVERFLOW)  <= send_memb_packet_length_roverflow;   -- index 1
zed_status(2)                                 <= '0';                                 -- index 2 not used
zed_status(3)                                 <= '0';                                 -- index 3 not used
zed_status(ZSTATUS_INDEX_RCV_MEM_FULL)        <= rcv_memb_full;                       -- index 4
zed_status(ZSTATUS_INDEX_RCV_MEM_WOVERFLOW)   <= rcv_memb_packet_length_woverflow;    -- index 5
zed_status(6)                                 <= '0';                                 -- index 6 not used
zed_status(7)                                 <= '0';                                 -- index 7 not used
zed_status(15 downto 8)                       <= zynq_out.zSTATUS;                    -- index=8..15
zed_status(ZSTATUS_INDEX_SEND_MEM_LENGTH_BIT7 downto ZSTATUS_INDEX_SEND_MEM_LENGTH_BIT0) <= send_mema_packet_length32; -- index 16..23
zed_status(ZSTATUS_INDEX_RCV_MEM_LENGTH_BIT7  downto ZSTATUS_INDEX_RCV_MEM_LENGTH_BIT0 ) <= rcv_memb_packet_length32;  -- index 24..31
--
--
menc_nibble_inst: menc_nibble
	port map( 
	clk                 => CLK_40,
	menc_data_in_type   => zynq_out.sym_to_send_type,
	menc_data_in        => zynq_out.sym_to_send,
	menc_data_out       => menc_data_out
	);
TX_DATA <= menc_data_out;
--
mdec_nibble_inst: mdec_nibble
	port map( 
	clk                 => CLK_40,
	mdec_data_in        => align_deser_data_out,  -- from align_deser_data.vhd
	mdec_data_out_type  => mdec_data_out_type,    -- used: zynq_in.sym_recieved_type <= mdec_data_out_type;
	mdec_data_out       => mdec_data_out          -- used: zynq_in.sym_recieved      <= mdec_data_out;
	);
--
ctrl_send_mem_inst: ctrl_send_mem
	port map( 
	clk                               => CLK_40,
	clear                             => clear_err,
	reset                             => reset_fpga,
	-- Port A interface signals
	sw_send_mema_rst_wrpointer        => sw_send_mema_rst_wrpointer,        -- from software application
	sw_send_mema_incr                 => sw_send_mema_incr,                 -- from software application
	sw_send_mema_write                => sw_send_mema_write,                -- from software application
	sw_send_mema_wdata                => sw_send_mema_wdata,                -- this module input port
	sw_send_mema_rdata                => sw_send_mema_rdata,                -- this module output port
	-- Port B interface signals
	sw_send_memb_send_packet          => sw_send_memb_send_packet,          -- from software application
	send_memb_readnext                => zynq_out.send_memb_readnext,       -- from MasterFSM.vhd
	send_memb_rdata                   => send_memb_rdata,                   -- used: zynq_in.send_memb_rdata     <= send_memb_rdata;
	send_memb_rdata_stb               => send_memb_rdata_stb,               -- used: zynq_in.send_memb_rdata_stb <= send_memb_rdata_stb;
	-- Auxiliary signals
	send_mema_packet_length32         => send_mema_packet_length32,         -- to software application
	send_memb_packet_length_roverflow => send_memb_packet_length_roverflow, -- to software application
	send_memb_not_empty               => send_memb_not_empty                -- to software application and zynq_in
	--
	);
--
ctrl_rcv_mem_inst: ctrl_rcv_mem
	port map( 
	clk                               => CLK_40,
	clear                             => clear_err,
	reset                             => reset_fpga,
	-- Port A interface signals
	sw_rcv_mema_rst_rpointer          => sw_rcv_mema_rst_rpointer,          -- from software application
	sw_rcv_mema_incr                  => sw_rcv_mema_incr,                  -- from software application
	sw_rcv_mema_rdata                 => sw_rcv_mema_rdata,                 -- this module output port
	-- Port B interface signals
	rcv_memb_rst_wpointer             => zynq_out.rcv_memb_rst_wpointer,    -- from MasterFSM.vhd
	rcv_memb_wdata_stb                => zynq_out.rcv_memb_wdata_stb,       -- from MasterFSM.vhd
	rcv_memb_wdata                    => zynq_out.rcv_memb_wdata,           -- from MasterFSM.vhd
	-- Auxiliary signals
	rcv_memb_packet_length32          => rcv_memb_packet_length32,          -- to software application
	rcv_memb_packet_length_woverflow  => rcv_memb_packet_length_woverflow,  -- to software application
	rcv_memb_full                     => rcv_memb_full                      -- to software application and zynq_in
	--
	);
--
MasterFSM_inst: MasterFSM
	port map( 
	clk       => CLK_40,
	reset     => reset_fpga,
	ZYNQ_IN   => zynq_in,
	ZYNQ_OUT  => zynq_out
	);
zynq_in.zCNTRL         <= zed_command(15 downto 8); -- from software application
zynq_in.send_memb_not_empty <= send_memb_not_empty; -- from ctrl_send_mem.vhd
zynq_in.send_memb_rdata     <= send_memb_rdata;     -- from ctrl_send_mem.vhd
zynq_in.send_memb_rdata_stb <= send_memb_rdata_stb; -- from ctrl_send_mem.vhd
zynq_in.rcv_memb_full       <= rcv_memb_full;       -- from ctrl_rcv_mem.vhd
zynq_in.sym_recieved_type   <= mdec_data_out_type;  -- from mdec_nibble.vhd
zynq_in.sym_recieved        <= mdec_data_out;       -- from mdec_nibble.vhd
--<= zynq_out.zSTATUS;                -- to software application
--<= zynq_out.send_memb_readnext;     -- to ctrl_send_mem.vhd
--<= zynq_out.rcv_memb_rst_wpointer;  -- to ctrl_rcv_mem.vhd
--<= zynq_out.rcv_memb_wdata;         -- to ctrl_rcv_mem.vhd
--<= zynq_out.rcv_memb_wdata_stb;     -- to ctrl_rcv_mem.vhd
--<= zynq_out.sym_to_send_type;       -- to menc_nibble.vhd
--<= zynq_out.sym_to_send;            -- to menc_nibble.vhd
--<= zynq_out.deser_data_offset;      -- to align_deser_data.vhd
--
align_deser_data_inst: align_deser_data
	port map( 
	clk                 => CLK_40,                     --
	deser_data          => RX_DATA,                    --
	deser_data_offset   => zynq_out.deser_data_offset, -- from MasterFSM.vhd
	deser_data_aligned  => align_deser_data_out        -- to mdec_niblle.vhd
	);
--
--
end rtl;
