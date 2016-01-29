-- ****************************************************************************
--	MODULE  	: ctrl_rcv_mem.vhd
--	AUTHOR  	: Cristian Gingu
--	VERSION 	: v1.00
--	DATE		: 01.04.2016
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

--library UNISIM;
--use UNISIM.VComponents.all;

use work.hgc_pck.all;

entity ctrl_rcv_mem is
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
end ctrl_rcv_mem;

architecture rtl of ctrl_rcv_mem is
--
component tdpram_32x256 is
	port (
	clka  : in std_logic;
	wea   : in std_logic_vector(0 downto 0);
	addra : in std_logic_vector(7 downto 0);
	dina  : in std_logic_vector(31 downto 0);
	douta : out std_logic_vector(31 downto 0);
	clkb  : in std_logic;
	web   : in std_logic_vector(0 downto 0);
	addrb : in std_logic_vector(7 downto 0);
	dinb  : in std_logic_vector(31 downto 0);
	doutb : out std_logic_vector(31 downto 0)
	);
end component;
--
signal rcv_mem_wea         : std_logic_vector(0 downto 0);
signal rcv_mem_addra       : std_logic_vector(7 downto 0);
signal rcv_mem_dina        : std_logic_vector(31 downto 0);
signal rcv_mem_douta       : std_logic_vector(31 downto 0);
signal rcv_mem_web         : std_logic_vector(0 downto 0);
signal rcv_mem_addrb       : std_logic_vector(7 downto 0);
signal rcv_mem_dinb        : std_logic_vector(31 downto 0);
signal rcv_mem_doutb       : std_logic_vector(31 downto 0);
--
signal rcv_mema_addr_cnt                : std_logic_vector(7 downto 0):=(others=>'0');
signal sw_rcv_mema_incr_del1            : std_logic:='0';
signal sw_rcv_mema_incr_re              : std_logic;
signal rcv_memb_addr_cnt                : std_logic_vector(7 downto 0):=(others=>'0');
signal rcv_memb_wdata_stb_del           : std_logic:='0';
signal rcv_memb_wdata_stb_re            : std_logic;
signal rcv_memb_addr_cnt_overflow_FF    : std_logic:='0';
signal rcv_memb_full_FF                 : std_logic:='0';
--
begin
--
rcv_mem_inst: tdpram_32x256
	port map(
	clka  => clk,
	wea   => rcv_mem_wea,
	addra => rcv_mem_addra,
	dina  => rcv_mem_dina,
	douta => rcv_mem_douta,
	clkb  => clk,
	web   => rcv_mem_web,
	addrb => rcv_mem_addrb,
	dinb  => rcv_mem_dinb,
	doutb => rcv_mem_doutb
	);
--
rcv_mem_wea(0)      <= '0';
rcv_mem_addra       <= rcv_mema_addr_cnt;
rcv_mem_dina        <= (others=>'0');
sw_rcv_mema_rdata   <= rcv_mem_douta;
--
rcv_mem_web(0)      <= rcv_memb_wdata_stb_re;
rcv_mem_addrb       <= rcv_memb_addr_cnt;
rcv_mem_dinb        <= rcv_memb_wdata;
--
--
-- ****************************************************************************
-- Create logic for auxiliary signals.
-- ****************************************************************************
sw_rcv_mema_incr_re   <= sw_rcv_mema_incr   and not(sw_rcv_mema_incr_del1);
rcv_memb_wdata_stb_re <= rcv_memb_wdata_stb and not(rcv_memb_wdata_stb_del);
process(clk) is
begin
	if rising_edge(clk) then
		sw_rcv_mema_incr_del1   <= sw_rcv_mema_incr;
		rcv_memb_wdata_stb_del  <= rcv_memb_wdata_stb;
	end if;
end process;
--
--
-- ****************************************************************************
-- Create logic to control Port A of receive memory instance:
-- (no write, read by the software application; contains the packet received)
-- NOTE: The optional output register stage used adds an additional clock cycle 
-- of latency to the Read operation.
-- ****************************************************************************
process(clk) is
begin
	if rising_edge(clk) then
		--
		if reset = '1' or sw_rcv_mema_rst_rpointer = '1' then
			rcv_mema_addr_cnt       <= (others=>'0');
		elsif sw_rcv_mema_incr_re = '1' then
			rcv_mema_addr_cnt       <= rcv_mema_addr_cnt + 1;
		end if;
		--
	end if;
end process;
--
--
-- ****************************************************************************
-- Create logic to control Port B of send memory instance:
-- (write by module MasterFSM, no read; contains the packet received)
-- NOTE: The optional output register stage used adds an additional clock cycle 
-- of latency to the Read operation.
-- ****************************************************************************	
process(clk) is
begin
	if rising_edge(clk) then
		--
		if reset = '1' or rcv_memb_rst_wpointer = '1' then
			rcv_memb_addr_cnt       <= (others=>'0');
		elsif rcv_memb_wdata_stb_re = '1' then
			if not(rcv_memb_addr_cnt = PACKET_LENGTH32_MAX) then
				rcv_memb_addr_cnt   <= rcv_memb_addr_cnt + 1;
			end if;
		end if;
		--
		if reset = '1' or clear = '1' then
			rcv_memb_addr_cnt_overflow_FF <= '0';
		elsif rcv_memb_addr_cnt = PACKET_LENGTH32_MAX then
			rcv_memb_addr_cnt_overflow_FF <= '1';
		end if;
		--
		if rcv_memb_addr_cnt = PACKET_LENGTH32_MAX then
			rcv_memb_full_FF  <= '1';
		else
			rcv_memb_full_FF  <= '0';
		end if;
		--
	end if;
end process;
--
--
-- ****************************************************************************
-- Registered output ports signal assignments. 
-- ****************************************************************************
rcv_memb_packet_length32          <= rcv_memb_addr_cnt;
rcv_memb_packet_length_woverflow  <= rcv_memb_addr_cnt_overflow_FF;
rcv_memb_full                     <= rcv_memb_full_FF;
--
--
end rtl;
