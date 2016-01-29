-- ****************************************************************************
--	MODULE  	: ref_clk.vhd
--	AUTHOR  	: Cristian Gingu
--	VERSION 	: v1.00
--	DATE		: 01.13.2016
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

library UNISIM;
use UNISIM.VComponents.all;

entity ref_clk is
	port ( 
	clk_in    : in std_logic;
	clk_out_p : out std_logic;
	clk_out_n : out std_logic
	);
end ref_clk;

architecture rtl of ref_clk is
--
signal clk_out : std_logic;
--
begin
--
inst_OBUFDS_clk_out: OBUFDS
	generic map (
	   IOSTANDARD => "LVDS_25", -- Specify the output I/O standard
	   SLEW       => "SLOW")    -- Specify the output slew rate
	port map (
	   O  => clk_out_p,         -- Diff_p output (connect directly to top-level port)
	   OB => clk_out_n,         -- Diff_n output (connect directly to top-level port)
	   I  => clk_out            -- Buffer input 
	);
	--
inst_ODDR_clk_out: ODDR
	generic map(
		DDR_CLK_EDGE => "SAME_EDGE",  -- "OPPOSITE_EDGE" or "SAME_EDGE" 
		INIT         => '0',          -- Initial value for Q port ('1' or '0')
		SRTYPE       => "SYNC")       -- Reset Type ("ASYNC" or "SYNC")
	port map (
		Q  => clk_out,                -- 1-bit DDR output
		C  => clk_in,                 -- 1-bit clock input
		CE => '1',                    -- 1-bit clock enable input
		D1 => '1',                    -- 1-bit data input (positive edge)
		D2 => '0',                    -- 1-bit data input (negative edge)
		R  => '0',                    -- 1-bit reset input
		S  => '0'                     -- 1-bit set input
	);
--

end rtl;
