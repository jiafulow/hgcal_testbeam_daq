-- ****************************************************************************
--	MODULE  	: hgc_zed_mylogic.vhd
--	AUTHOR  	: Cristian Gingu
--	VERSION 	: v1.00
--	DATE		: 12.29.2015
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

entity hgc_zed_mylogic is
	generic (
	C_S_AXI_DATA_WIDTH	: integer	:= 32
	);
	port ( 
	-- Ports to/from UPPER in hierarchy WRAPPER file
	-- custom AXI IP module hgc_zed_ip_v1_0.vhd
	CLK_40          : in std_logic;
	CLK_80          : in std_logic;
	M_RXTX_DATA_P   : inout std_logic_vector(7 downto 0);
	M_RXTX_DATA_N   : inout std_logic_vector(7 downto 0);
	M_RXTX_CLK_P    : inout std_logic;
	M_RXTX_CLK_N    : inout std_logic;
	M_RXTX_CTRL_P   : inout std_logic_vector(7 downto 0);
	M_RXTX_CTRL_N   : inout std_logic_vector(7 downto 0);
	M_REF_CLK_P     : out std_logic;
	M_REF_CLK_N     : out std_logic;
	SW_IN           : in  std_logic_vector(7 downto 0);
	LED_OUT         : out std_logic_vector(7 downto 0);
	--
	-- Ports to/from SAME LEVEL of hierarchy 
	-- custom AXI IP module hgc_zed_ip_v1_0_S00_AXI.vhd
	reg0_out      : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	reg1_out      : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	reg2_out      : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	reg3_out      : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	reg0_in       : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	reg1_in       : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	reg2_in       : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	reg3_in       : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0)
	);
end hgc_zed_mylogic;

architecture rtl of hgc_zed_mylogic is
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
	-- Port A interface signals
	sw_send_mema_rst_wrpointer        : in std_logic;
	sw_send_mema_write_and_incr       : in std_logic;
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
	-- Port A interface signals
	sw_rcv_mema_rst_rpointer          : in std_logic;
	sw_rcv_mema_read_and_incr         : in std_logic;
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
signal M_RXTX_DATA_PIN2DEV      : std_logic_vector(7 downto 0);
signal M_RXTX_DATA_DEV2PIN      : std_logic_vector(7 downto 0);
signal M_RXTX_DATA_DEV2PIN_TRI  : std_logic_vector(7 downto 0);
signal M_RXTX_CLK_PIN2DEV       : std_logic;
signal M_RXTX_CLK_DEV2PIN       : std_logic;
signal M_RXTX_CLK_DEV2PIN_TRI   : std_logic;
signal M_RXTX_CTRL_PIN2DEV      : std_logic_vector(7 downto 0);
signal M_RXTX_CTRL_DEV2PIN      : std_logic_vector(7 downto 0);
signal M_RXTX_CTRL_DEV2PIN_TRI  : std_logic_vector(7 downto 0);
signal M_REF_CLK                : std_logic;
--
signal datain0        : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
signal datain1        : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
signal datain2        : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
signal datain3        : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
signal dataout0       : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
signal dataout1       : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
signal dataout2       : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
signal dataout3       : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
--
-- Signals related to component menc_nibble
signal menc_data_in_type    : SYM_TYPE;
signal menc_data_in         : std_logic_vector(3 downto 0);
signal menc_data_out        : std_logic_vector(7 downto 0);
--
-- Signals related to component mdec_nibble
signal mdec_data_in         : std_logic_vector(7 downto 0);
signal mdec_data_out_type   : SYM_TYPE;
signal mdec_data_out        : std_logic_vector(3 downto 0);
--
-- Signals related to component ctrl_send_mem
signal clear                              : std_logic;
signal sw_send_mema_rst_wrpointer         : std_logic;
signal sw_send_mema_write_and_incr        : std_logic;
signal sw_send_mema_wdata                 : std_logic_vector(31 downto 0);
signal sw_send_mema_rdata                 : std_logic_vector(31 downto 0);
signal sw_send_memb_send_packet           : std_logic;
signal send_memb_readnext                 : std_logic;
signal send_memb_rdata                    : std_logic_vector(31 downto 0);
signal send_memb_rdata_stb                : std_logic;
signal send_mema_packet_length32          : std_logic_vector(7 downto 0);
signal send_memb_packet_length_roverflow  : std_logic;
signal send_memb_not_empty                : std_logic;
--
-- Signals related to component ctrl_rcv_mem
signal sw_rcv_mema_rst_rpointer           : std_logic;
signal sw_rcv_mema_read_and_incr          : std_logic;
signal sw_rcv_mema_rdata                  : std_logic_vector(31 downto 0);
signal rcv_memb_rst_wpointer              : std_logic;
signal rcv_memb_wdata_stb                 : std_logic;
signal rcv_memb_wdata                     : std_logic_vector(31 downto 0);
signal rcv_memb_packet_length32           : std_logic_vector(7 downto 0);
signal rcv_memb_packet_length_woverflow   : std_logic;
signal rcv_memb_full                      : std_logic;
--
-- Signals related to component MasterFSM
signal zynq_in                            : ZYNQ_MASTERFSM_INPUT;
signal zynq_out                           : ZYNQ_MASTERFSM_OUTPUT;
--
-- Signals related to component align_deser_data
signal align_deser_data_in                : std_logic_vector(7 downto 0);
signal align_deser_data_offset            : std_logic_vector(2 downto 0);
signal align_deser_data_out               : std_logic_vector(7 downto 0);
--
--
begin
-- 
--
-- *****************************************************************************
-- Instantiate IOBUFDS for FMC bidirectional ports:
-- M_RXTX_DATA_P,N(7 downto 0) and M_RXTX_CLK_P,N.
-- *****************************************************************************
gen_M_RXTX_DATA: for i in 0 to 7 generate
begin
inst_IOBUFDS_M_RXTX_DATA: IOBUFDS
generic map (
	DIFF_TERM    => "TRUE",     -- Differential Termination (TRUE/FALSE)
	IBUF_LOW_PWR => TRUE,       -- Low Power = TRUE, High Performance = FALSE
	IOSTANDARD   => "LVDS_25",  -- BLVDS_25 Specify the I/O standard
	SLEW         => "SLOW")     -- Specify the output slew rate
port map (
	O   => M_RXTX_DATA_PIN2DEV(i),    -- Buffer output
	IO  => M_RXTX_DATA_P(i),          -- Diff_p inout (connect directly to top-level port)
	IOB => M_RXTX_DATA_N(i),          -- Diff_n inout (connect directly to top-level port)
	I   => M_RXTX_DATA_DEV2PIN(i),    -- Buffer input
	T   => M_RXTX_DATA_DEV2PIN_TRI(i) -- 3-state enable input, high=input, low=output
);
end generate;
--
inst_IOBUFDS_M_RXTX_CLK: IOBUFDS
generic map (
	DIFF_TERM    => "TRUE",     -- Differential Termination (TRUE/FALSE)
	IBUF_LOW_PWR => TRUE,       -- Low Power = TRUE, High Performance = FALSE
	IOSTANDARD   => "LVDS_25",  -- BLVDS_25 Specify the I/O standard
	SLEW         => "SLOW")     -- Specify the output slew rate
port map (
	O   => M_RXTX_CLK_PIN2DEV,        -- Buffer output
	IO  => M_RXTX_CLK_P,              -- Diff_p inout (connect directly to top-level port)
	IOB => M_RXTX_CLK_N,              -- Diff_n inout (connect directly to top-level port)
	I   => M_RXTX_CLK_DEV2PIN,        -- Buffer input
	T   => M_RXTX_CLK_DEV2PIN_TRI     -- 3-state enable input, high=input, low=output
);
--
--
-- *****************************************************************************
-- Instantiate IOBUFDS for FMC bidirectional ports M_RXTX_CTRL_P,N(7 downto 0).
-- Instantiate OBUFDS and for output port M_REF_CLK_P,N.
-- Create the M_REF_CLK signal using an OUT DDR register.
-- *****************************************************************************
gen_M_RXTX_CTRL: for i in 0 to 7 generate
begin
inst_IOBUFDS_M_RXTX_CTRL: IOBUFDS
generic map (
	DIFF_TERM    => "TRUE",     -- Differential Termination (TRUE/FALSE)
	IBUF_LOW_PWR => TRUE,       -- Low Power = TRUE, High Performance = FALSE
	IOSTANDARD   => "LVDS_25",  -- BLVDS_25 Specify the I/O standard
	SLEW         => "SLOW")     -- Specify the output slew rate
port map (
	O   => M_RXTX_CTRL_PIN2DEV(i),    -- Buffer output
	IO  => M_RXTX_CTRL_P(i),          -- Diff_p inout (connect directly to top-level port)
	IOB => M_RXTX_CTRL_N(i),          -- Diff_n inout (connect directly to top-level port)
	I   => M_RXTX_CTRL_DEV2PIN(i),    -- Buffer input
	T   => M_RXTX_CTRL_DEV2PIN_TRI(i) -- 3-state enable input, high=input, low=output
);
end generate;
--
inst_OBUFDS_M_REF_CLK: OBUFDS
	generic map (
	   IOSTANDARD => "LVDS_25", -- Specify the output I/O standard
	   SLEW       => "SLOW")    -- Specify the output slew rate
	port map (
	   O  => M_REF_CLK_P,       -- Diff_p output (connect directly to top-level port)
	   OB => M_REF_CLK_N,       -- Diff_n output (connect directly to top-level port)
	   I  => M_REF_CLK          -- Buffer input 
	);
	--
inst_ODDR_M_REF_CLK: ODDR
	generic map(
		DDR_CLK_EDGE => "SAME_EDGE",  -- "OPPOSITE_EDGE" or "SAME_EDGE" 
		INIT         => '0',          -- Initial value for Q port ('1' or '0')
		SRTYPE       => "SYNC")       -- Reset Type ("ASYNC" or "SYNC")
	port map (
		Q  => M_REF_CLK,              -- 1-bit DDR output
		C  => CLK_40,                 -- 1-bit clock input
		CE => '1',                    -- 1-bit clock enable input
		D1 => '1',                    -- 1-bit data input (positive edge)
		D2 => '0',                    -- 1-bit data input (negative edge)
		R  => '0',                    -- 1-bit reset input
		S  => '0'                     -- 1-bit set input
	);
--
--
-- *****************************************************************************
-- Instantiate all the other components here.
-- *****************************************************************************
menc_nibble_inst: menc_nibble
	port map( 
	clk                 => CLK_40,
	menc_data_in_type   => menc_data_in_type,
	menc_data_in        => menc_data_in,
	menc_data_out       => menc_data_out
	);
--
mdec_nibble_inst: mdec_nibble
	port map( 
	clk                 => CLK_40,
	mdec_data_in        => mdec_data_in,
	mdec_data_out_type  => mdec_data_out_type,
	mdec_data_out       => mdec_data_out
	);
--
ctrl_send_mem_inst: ctrl_send_mem
	port map( 
	clk                               => CLK_40,
	clear                             => clear,
	-- Port A interface signals
	sw_send_mema_rst_wrpointer        => sw_send_mema_rst_wrpointer,
	sw_send_mema_write_and_incr       => sw_send_mema_write_and_incr,
	sw_send_mema_wdata                => sw_send_mema_wdata,
	sw_send_mema_rdata                => sw_send_mema_rdata,
	-- Port B interface signals
	sw_send_memb_send_packet          => sw_send_memb_send_packet,
	send_memb_readnext                => send_memb_readnext,
	send_memb_rdata                   => send_memb_rdata,
	send_memb_rdata_stb               => send_memb_rdata_stb,
	-- Auxiliary signals
	send_mema_packet_length32         => send_mema_packet_length32,
	send_memb_packet_length_roverflow => send_memb_packet_length_roverflow,
	send_memb_not_empty               => send_memb_not_empty
	--
	);
--
ctrl_rcv_mem_inst: ctrl_rcv_mem
	port map( 
	clk                               => CLK_40,
	clear                             => clear,
	-- Port A interface signals
	sw_rcv_mema_rst_rpointer          => sw_rcv_mema_rst_rpointer,
	sw_rcv_mema_read_and_incr         => sw_rcv_mema_read_and_incr,
	sw_rcv_mema_rdata                 => sw_rcv_mema_rdata,
	-- Port B interface signals
	rcv_memb_rst_wpointer             => rcv_memb_rst_wpointer,
	rcv_memb_wdata_stb                => rcv_memb_wdata_stb,
	rcv_memb_wdata                    => rcv_memb_wdata,
	-- Auxiliary signals
	rcv_memb_packet_length32          => rcv_memb_packet_length32,
	rcv_memb_packet_length_woverflow  => rcv_memb_packet_length_woverflow,
	rcv_memb_full                     => rcv_memb_full
	--
	);
--
MasterFSM_inst: MasterFSM
	port map( 
	clk       => CLK_40,
	reset     => clear,
	ZYNQ_IN   => zynq_in,
	ZYNQ_OUT  => zynq_out
	);
--
align_deser_data_inst: align_deser_data
	port map( 
	clk                 => CLK_40,
	deser_data          => align_deser_data_in,
	deser_data_offset   => align_deser_data_offset,
	deser_data_aligned  => align_deser_data_out
	);
--

end rtl;
