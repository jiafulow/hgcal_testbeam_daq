-- ****************************************************************************
--	MODULE  	: ctrl_send_mem.vhd
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

entity ctrl_send_mem is
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
end ctrl_send_mem;

architecture rtl of ctrl_send_mem is
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
signal send_mem_wea         : std_logic_vector(0 downto 0);
signal send_mem_addra       : std_logic_vector(7 downto 0);
signal send_mem_dina        : std_logic_vector(31 downto 0);
signal send_mem_douta       : std_logic_vector(31 downto 0);
signal send_mem_web         : std_logic_vector(0 downto 0);
signal send_mem_addrb       : std_logic_vector(7 downto 0);
signal send_mem_dinb        : std_logic_vector(31 downto 0);
signal send_mem_doutb       : std_logic_vector(31 downto 0);
--
signal sw_send_mema_incr_del1           : std_logic:='0';
signal sw_send_mema_incr_re             : std_logic;
signal sw_send_mema_write_del1          : std_logic:='0';
signal sw_send_mema_write_re            : std_logic;
signal sw_send_memb_send_packet_del1    : std_logic:='0';
signal sw_send_memb_send_packet_re      : std_logic;
signal send_memb_readnext_del1          : std_logic:='0';
signal send_memb_readnext_re            : std_logic;
signal send_memb_readnext_re_del1       : std_logic:='0';
signal send_memb_readnext_re_del2       : std_logic:='0';
signal send_mema_addr_cnt               : std_logic_vector(7 downto 0):=(others=>'0');
signal send_mema_packet_length32_FF     : std_logic_vector(7 downto 0):=(others=>'0');
signal send_memb_addr_cnt               : std_logic_vector(7 downto 0):=(others=>'0');
signal send_memb_addr_cnt_overflow_FF   : std_logic:='0';
signal send_memb_not_empty_FF           : std_logic:='0';
--
begin
--
send_mem_inst: tdpram_32x256
	port map(
	clka  => clk,
	wea   => send_mem_wea,
	addra => send_mem_addra,
	dina  => send_mem_dina,
	douta => send_mem_douta,
	clkb  => clk,
	web   => send_mem_web,
	addrb => send_mem_addrb,
	dinb  => send_mem_dinb,
	doutb => send_mem_doutb
	);
--
send_mem_wea(0)     <= sw_send_mema_write_re;
send_mem_addra      <= send_mema_addr_cnt;
send_mem_dina       <= sw_send_mema_wdata;
sw_send_mema_rdata  <= send_mem_douta;                  -- registerd output port
--
send_mem_web(0)     <= '0';
send_mem_addrb      <= send_memb_addr_cnt;
send_mem_dinb       <= (others=>'0');
send_memb_rdata     <= send_mem_doutb;                  -- registerd output port
--
--
-- ****************************************************************************
-- Create logic for auxiliary signals.
-- ****************************************************************************
sw_send_mema_incr_re          <= sw_send_mema_incr        and not(sw_send_mema_incr_del1);
sw_send_mema_write_re         <= sw_send_mema_write       and not(sw_send_mema_write_del1);
sw_send_memb_send_packet_re   <= sw_send_memb_send_packet and not(sw_send_memb_send_packet_del1);
send_memb_readnext_re         <= send_memb_readnext       and not(send_memb_readnext_del1);
--
process(clk) is
begin
	if rising_edge(clk) then
		sw_send_mema_incr_del1          <= sw_send_mema_incr;
		sw_send_mema_write_del1         <= sw_send_mema_write;
		sw_send_memb_send_packet_del1   <= sw_send_memb_send_packet;
		send_memb_readnext_del1         <= send_memb_readnext;
	end if;
end process;
--
--
-- ****************************************************************************
-- Create logic to control Port A of send memory instance:
-- (write, read by the software application; contains the packet to be sent out)
-- NOTE: The optional output register stage used adds an additional clock cycle 
-- of latency to the Read operation.
-- ****************************************************************************
process(clk) is
begin
	if rising_edge(clk) then
		--
		if reset = '1' or sw_send_mema_rst_wrpointer = '1' then
			send_mema_addr_cnt      <= (others=>'0');
		elsif sw_send_mema_incr_re = '1' then
			send_mema_addr_cnt      <= send_mema_addr_cnt + 1;
		end if;
		--
		if reset = '1' or sw_send_mema_rst_wrpointer = '1' then
			send_mema_packet_length32_FF <= (others=>'0');
		elsif sw_send_memb_send_packet_re = '1' then
			send_mema_packet_length32_FF <= send_mema_addr_cnt;
		end if;
		--
	end if;
end process;
--
--
-- ****************************************************************************
-- Create logic to control Port B of send memory instance:
-- (no write, read by module MasterFSM when "send packet" command is received)
-- NOTE: The optional output register stage used adds an additional clock cycle 
-- of latency to the Read operation.
-- ****************************************************************************	
process(clk) is
begin
	if rising_edge(clk) then
		--
		if reset = '1' or sw_send_memb_send_packet_re = '1' then
			send_memb_addr_cnt              <= (others=>'0');
		elsif send_memb_readnext_re = '1' then
			if not(send_memb_addr_cnt = send_mema_packet_length32_FF) then
				send_memb_addr_cnt          <= send_memb_addr_cnt + 1;
			end if;
		end if;
		--
		if reset = '1' or clear = '1' then
			send_memb_addr_cnt_overflow_FF  <= '0';
		elsif send_memb_addr_cnt = send_mema_packet_length32_FF and not(send_mema_packet_length32_FF=X"00") then
			send_memb_addr_cnt_overflow_FF  <= '1';
		end if;
		--
		if not(send_memb_addr_cnt = send_mema_packet_length32_FF) then
			send_memb_not_empty_FF      <= '1';
		else
			send_memb_not_empty_FF      <= '0';
		end if;
		--
	end if;
end process;
--
--
-- ****************************************************************************
-- Registered output ports signal assignments. 
-- ****************************************************************************
send_memb_rdata_stb                 <= send_memb_readnext_re_del2;
send_mema_packet_length32           <= send_mema_packet_length32_FF;
send_memb_packet_length_roverflow   <= send_memb_addr_cnt_overflow_FF;
send_memb_not_empty                 <= send_memb_not_empty_FF;
--
process(clk) is
begin
	if rising_edge(clk) then
		--
		-- signal in sync with send_memb_addr_cnt changes
		send_memb_readnext_re_del1          <= send_memb_readnext_re;
		-- additional clock cycle of latency for registered data output from BRAM
		send_memb_readnext_re_del2          <= send_memb_readnext_re_del1; 
		--
	end if;
end process;
--
end rtl;
