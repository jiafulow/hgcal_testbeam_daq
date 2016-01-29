library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

Library UNISIM;
use UNISIM.vcomponents.all;

Library UNIMACRO;
use UNIMACRO.vcomponents.all;

use work.hgc_pck.all;

entity hgc_zed_ip_v1_0 is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line
		
		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 4
	);
	port (
		-- Users to add ports here
		CLK_40          : in std_logic;
		RX_DATA         : in std_logic_vector(7 downto 0);
		TX_DATA         : out std_logic_vector(7 downto 0);
		-- User ports ends
		
		-- Do not modify the ports beyond this line
		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic;
		s00_axi_rready	: in std_logic
	);
end hgc_zed_ip_v1_0;

architecture arch_imp of hgc_zed_ip_v1_0 is

	-- component declaration
	component hgc_zed_ip_v1_0_S00_AXI is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 4
		);
		port (
		-- Users to add ports here
		-- CG my custom ports
		datain0       : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		datain1       : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		datain2       : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		datain3       : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		dataout0      : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		dataout1      : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		dataout2      : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		dataout3      : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		-- User ports ends
		-- Do not modify the ports beyond this line
		S_AXI_ACLK      : in std_logic;
		S_AXI_ARESETN   : in std_logic;
		S_AXI_AWADDR    : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT    : in std_logic_vector(2 downto 0);
		S_AXI_AWVALID   : in std_logic;
		S_AXI_AWREADY   : out std_logic;
		S_AXI_WDATA     : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB     : in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID    : in std_logic;
		S_AXI_WREADY    : out std_logic;
		S_AXI_BRESP     : out std_logic_vector(1 downto 0);
		S_AXI_BVALID    : out std_logic;
		S_AXI_BREADY    : in std_logic;
		S_AXI_ARADDR    : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT    : in std_logic_vector(2 downto 0);
		S_AXI_ARVALID   : in std_logic;
		S_AXI_ARREADY   : out std_logic;
		S_AXI_RDATA     : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP     : out std_logic_vector(1 downto 0);
		S_AXI_RVALID    : out std_logic;
		S_AXI_RREADY    : in std_logic
		);
	end component hgc_zed_ip_v1_0_S00_AXI;
	
	-- CG add component declaration here
	component hgc_zed_channel is
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
		reg0_out  : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		reg1_out  : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		reg2_out  : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		reg3_out  : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		reg0_in   : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		reg1_in   : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		reg2_in   : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		reg3_in   : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0)
		);
	end component hgc_zed_channel;
	-- CG end component declaration
	
	-- CG add signal declaration here
	signal datain0        : std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
	signal datain1        : std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
	signal datain2        : std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
	signal datain3        : std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
	signal dataout0       : std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
	signal dataout1       : std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
	signal dataout2       : std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
	signal dataout3       : std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
	-- CG end signal declaration
	
begin

-- Instantiation of Axi Bus Interface S00_AXI
hgc_zed_ip_v1_0_S00_AXI_inst: hgc_zed_ip_v1_0_S00_AXI
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
		-- Users to add ports here
		-- CG my custom ports
		datain0       => datain0,
		datain1       => datain1,
		datain2       => datain2,
		datain3       => datain3,
		dataout0      => dataout0,
		dataout1      => dataout1,
		dataout2      => dataout2,
		dataout3      => dataout3,
		-- CG my custom ports
		-- User ports ends
		-- Do not modify the ports beyond this line
		S_AXI_ACLK      => s00_axi_aclk,
		S_AXI_ARESETN   => s00_axi_aresetn,
		S_AXI_AWADDR    => s00_axi_awaddr,
		S_AXI_AWPROT    => s00_axi_awprot,
		S_AXI_AWVALID   => s00_axi_awvalid,
		S_AXI_AWREADY   => s00_axi_awready,
		S_AXI_WDATA     => s00_axi_wdata,
		S_AXI_WSTRB     => s00_axi_wstrb,
		S_AXI_WVALID    => s00_axi_wvalid,
		S_AXI_WREADY    => s00_axi_wready,
		S_AXI_BRESP     => s00_axi_bresp,
		S_AXI_BVALID    => s00_axi_bvalid,
		S_AXI_BREADY    => s00_axi_bready,
		S_AXI_ARADDR    => s00_axi_araddr,
		S_AXI_ARPROT    => s00_axi_arprot,
		S_AXI_ARVALID   => s00_axi_arvalid,
		S_AXI_ARREADY   => s00_axi_arready,
		S_AXI_RDATA     => s00_axi_rdata,
		S_AXI_RRESP     => s00_axi_rresp,
		S_AXI_RVALID    => s00_axi_rvalid,
		S_AXI_RREADY    => s00_axi_rready
	);
	--
-- *****************************************************************************
-- Instantiation of user logic top component.
-- *****************************************************************************
	-- CG add component declaration here
hgc_zed_channel_inst: hgc_zed_channel
	generic map (
	C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH
	)
	port map (
	-- Ports to/from UPPER in hierarchy WRAPPER file
	-- custom AXI IP module hgc_zed_ip_v1_0.vhd
	CLK_40    => CLK_40,
	RX_DATA   => RX_DATA,
	TX_DATA   => TX_DATA,
	--
	-- Ports to/from SAME LEVEL of hierarchy 
	-- custom AXI IP module hgc_zed_ip_v1_0_S00_AXI.vhd
	reg0_out  => datain0,
	reg1_out  => datain1,
	reg2_out  => datain2,
	reg3_out  => datain3,
	reg0_in   => dataout0,
	reg1_in   => dataout1,
	reg2_in   => dataout2,
	reg3_in   => dataout3
	);
-- CG end component declaration


-- Add user logic here
-- 
-- User logic ends

end arch_imp;
--
--
---- *****************************************************************************
---- 1. Timer Peripheral:
---- WRITE: dataout0 register; bit#0=Enable, bit#1=Reset.
---- READ:  datain0 register.
---- *****************************************************************************
--	datain0 <= timer_cnt;
--	process(s00_axi_aclk) is
--	begin
--	  if (rising_edge(s00_axi_aclk)) then
--	    if (s00_axi_aresetn='0' or dataout0(1)='1') then
--	      timer_cnt  <= (others => '0');
--	    else
--	      if (dataout0(0)='1') then
--	          timer_cnt <= timer_cnt + 1;
--	      end if;   
--	    end if;
--	  end if;
--	end process;
--	--
--	--


---- *****************************************************************************
---- 3. GPIO Peripheral:
---- WRITE: dataout2 register; LEDs.
---- READ:  datain2  register; Switches.
---- *****************************************************************************
----	LED_OUT             <= dataout2(7 downto 0);
----	datain2(7 downto 0) <= SW_IN;
----	datain2(31 downto 8)<= X"000000";
--	--
--	--
---- *****************************************************************************
---- 4. BRAM Peripheral:
---- BRAM_SDP_MACRO: True Dual Port RAM Artix-7
---- Xilinx HDL Language Template, version 2014.2
---- Note -  This Unimacro model assumes the port directions to be "downto". 
----         Simulation of this model with "to" in the port directions could lead to erroneous results.
-------------------------------------------------------------------------
----  READ_WIDTH | BRAM_SIZE | READ Depth  | RDADDR Width |            --
---- WRITE_WIDTH |           | WRITE Depth | WRADDR Width |  WE Width  --
---- ============|===========|=============|==============|============--
----    37-72    |  "36Kb"   |      512    |     9-bit    |    8-bit   --
----    19-36    |  "36Kb"   |     1024    |    10-bit    |    4-bit   --
----    19-36    |  "18Kb"   |      512    |     9-bit    |    4-bit   --
----    10-18    |  "36Kb"   |     2048    |    11-bit    |    2-bit   --
----    10-18    |  "18Kb"   |     1024    |    10-bit    |    2-bit   --
----     5-9     |  "36Kb"   |     4096    |    12-bit    |    1-bit   --
----     5-9     |  "18Kb"   |     2048    |    11-bit    |    1-bit   --
----     3-4     |  "36Kb"   |     8192    |    13-bit    |    1-bit   --
----     3-4     |  "18Kb"   |     4096    |    12-bit    |    1-bit   --
----       2     |  "36Kb"   |    16384    |    14-bit    |    1-bit   --
----       2     |  "18Kb"   |     8192    |    13-bit    |    1-bit   --
----       1     |  "36Kb"   |    32768    |    15-bit    |    1-bit   --
----       1     |  "18Kb"   |    16384    |    14-bit    |    1-bit   --
-------------------------------------------------------------------------
---- *****************************************************************************
--	inst_BRAM_SDP_MACRO: BRAM_SDP_MACRO
--	generic map (
--		BRAM_SIZE   => "18Kb",    -- Target BRAM, "18Kb" or "36Kb" 
--		DEVICE      => "7SERIES", -- Target device: "VIRTEX5", "VIRTEX6", "7SERIES", "SPARTAN6" 
--		WRITE_WIDTH => 16,        -- Valid values are 1-72 (37-72 only valid when BRAM_SIZE="36Kb")
--		READ_WIDTH  => 16,        -- Valid values are 1-72 (37-72 only valid when BRAM_SIZE="36Kb")
--		DO_REG      => 0,         -- Optional output register (0 or 1)
--		INIT_FILE   => "NONE",
--		SIM_COLLISION_CHECK => "ALL",   -- Collision check enable "ALL", "WARNING_ONLY", 
--									    -- "GENERATE_X_ONLY" or "NONE"       
--		SRVAL       => X"000000000000000000", --  Set/Reset value for port output
--		WRITE_MODE  => "WRITE_FIRST",   -- Specify "READ_FIRST" for same clock or synchronous clocks
--								        --  Specify "WRITE_FIRST for asynchrononous clocks on ports
--		INIT => X"000000000000000000",  --  Initial values on output port
--		-- The following INIT_xx declarations specify the initial contents of the RAM
--		INIT_00 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_02 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_04 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_07 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_08 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_09 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_0A => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_0B => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_0C => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_0D => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_0E => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_0F => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_10 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_11 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_12 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_13 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_14 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_15 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_16 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_17 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_18 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_19 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_1A => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_1B => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_1C => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_1D => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_1E => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_1F => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_20 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_21 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_22 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_23 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_24 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_25 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_26 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_27 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_28 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_29 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_2A => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_2B => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_2C => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_2D => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_2E => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_2F => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_30 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_31 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_32 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_33 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_34 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_35 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_36 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_37 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_38 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_39 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_3A => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_3B => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_3C => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_3D => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_3E => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INIT_3F => X"0000000000000000000000000000000000000000000000000000000000000000",		
----		-- The next set of INIT_xx are valid when configured as 36Kb
----		INIT_40 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_41 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_42 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_43 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_44 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_45 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_46 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_47 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_48 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_49 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_4A => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_4B => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_4C => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_4D => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_4E => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_4F => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_50 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_51 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_52 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_53 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_54 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_55 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_56 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_57 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_58 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_59 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_5A => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_5B => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_5C => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_5D => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_5E => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_5F => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_60 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_61 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_62 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_63 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_64 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_65 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_66 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_67 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_68 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_69 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_6A => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_6B => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_6C => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_6D => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_6E => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_6F => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_70 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_71 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_72 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_73 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_74 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_75 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_76 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_77 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_78 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_79 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_7A => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_7B => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_7C => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_7D => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_7E => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INIT_7F => X"0000000000000000000000000000000000000000000000000000000000000000",
--		-- The next set of INITP_xx are for the parity bits
--		INITP_00 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INITP_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INITP_02 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INITP_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INITP_04 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INITP_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INITP_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
--		INITP_07 => X"0000000000000000000000000000000000000000000000000000000000000000"
----		-- The next set of INIT_xx are valid when configured as 36Kb
----		INITP_08 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INITP_09 => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INITP_0A => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INITP_0B => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INITP_0C => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INITP_0D => X"0000000000000000000000000000000000000000000000000000000000000000",
----		INITP_0E => X"0000000000000000000000000000000000000000000000000000000000000000"
--	)
--	port map (
--		DO     => bram_do,      -- Output read data port, width defined by READ_WIDTH parameter
--		DI     => bram_di,      -- Input write data port, width defined by WRITE_WIDTH parameter
--		RDADDR => bram_addr,    -- Input read address, width defined by read port depth
--		RDCLK  => s00_axi_aclk, -- 1-bit input read clock
--		RDEN   => '1',          -- 1-bit input read port enable
--		REGCE  => '1',          -- 1-bit input read output register enable
--		RST    => '0',          -- 1-bit input reset 
--		WE     => bram_we,      -- Input write enable, width defined by write port depth
--		WRADDR => bram_addr,    -- Input write address, width defined by write port depth
--		WRCLK  => s00_axi_aclk, -- 1-bit input write clock
--		WREN   => bram_wren     -- 1-bit input write port enable
--	);
--	-- End of BRAM_SDP_MACRO_inst instantiation
--	--
--	-- WRITE: dataout3 register; bit#31==0=select_address_to_read_write, 
--	--                           bit#31==1=select_data_to_write
--	--                           bit#15-bit#0=value (address or data type)
--	-- READ:  datain3 register;  bit#15-bit#0=readout data at active address
--	datain3(15 downto 0)  <= bram_do;
--	datain3(31 downto 16) <= X"0000";
--	process(s00_axi_aclk) is
--	begin
--		if (rising_edge(s00_axi_aclk)) then
--			if (dataout3(31)='0') then
--				-- bit#31==0=select_address_to_read_write, 
--				bram_addr <= dataout3(9 downto 0);
--				bram_we   <= "00";
--				bram_wren <= '0';
--			else
--				-- bit#31==1=select_data_to_write
--				bram_di   <= dataout3(15 downto 0);
--				bram_we   <= "11";
--				bram_wren <= '1';
--			end if;
--		end if;
--	end process;