-- ****************************************************************************
--	MODULE  	: hgc_zed_common.vhd
--	AUTHOR  	: Cristian Gingu
--	VERSION 	: v1.00
--	DATE		: 01.15.2016
-- ****************************************************************************
--	REVISION HISTORY:
--	-----------------
-- This module contains any "common" custom logic NOT related with Channels. 
-- ****************************************************************************
--	FUNCTION DESCRIPTION:
-------------------------------------------------------------------------------
-- Ports description:
-------------------------------------------------------------------------------
-- ****************************************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity hgc_zed_common is
	port ( 
	clk_in    : in std_logic;
	locked    : in std_logic;
	clk_out_p : out std_logic;
	clk_out_n : out std_logic
	);
end hgc_zed_common;

architecture rtl of hgc_zed_common is
--
component ref_clk is
	port ( 
	clk_in    : in std_logic;
	clk_out_p : out std_logic;
	clk_out_n : out std_logic
	);
end component;
--
begin
--
-- May want to add a GSR instance? did not finnd it, found only STARTUP... 
--
ref_clk_inst: ref_clk
	port map ( 
	clk_in    => clk_in,
	clk_out_p => clk_out_p,
	clk_out_n => clk_out_n
	);
--
end rtl;
