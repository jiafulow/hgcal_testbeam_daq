-- ****************************************************************************
--	MODULE  	: menc_nible.vhd
--	AUTHOR  	: Cristian Gingu
--	VERSION 	: v1.00
--	DATE		: 12.16.2015
-- ****************************************************************************
--	REVISION HISTORY:
--	-----------------
-- ****************************************************************************
--	FUNCTION DESCRIPTION:
-- Manchester Encoding: 
-- when nrz_data=0 => menc=tranzition 0->1 
-- when nrz_data=1 => menc=tranzition 1->0 
-- Example: sending 16-bit data=0x3814
-------------------------------------------------------------------------------
-- |           16-bit data                         |
-- | 0  0  1  1  1  0  0  0  0  0  0  1  0  1  0  0|
-- |01.01.10.10.10.01.01.01.01.01.01.10.01.10.01.01|
-------------------------------------------------------------------------------
-- Ports description:
-- ****************************************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--library UNISIM;
--use UNISIM.VComponents.all;

use work.hgc_pck.all;

entity menc_nibble is
	port ( 
	clk               : in std_logic;
	menc_data_in_type : in SYM_TYPE;
	menc_data_in      : in std_logic_vector(3 downto 0);
	menc_data_out     : out std_logic_vector(7 downto 0)
	);
end menc_nibble;

architecture rtl of menc_nibble is
--
signal menc_data        : std_logic_vector(7 downto 0);
signal menc_data_out_ff : std_logic_vector(7 downto 0):=(others=>'0');
--
begin
--
-- ****************************************************************************
-- Create miscellaneous combinatorial signals used by this module logic.
-- ****************************************************************************
gen_data_in_menc: for i in 0 to 3 generate
begin
	menc_data(2*i)   <= not(menc_data_in(i));
	menc_data(2*i+1) <= menc_data_in(i);
end generate;
--
--
-- ****************************************************************************
-- Create logic for menc_data_out registered output port.
-- ****************************************************************************
menc_data_out <= menc_data_out_ff;
--
process(clk) is
begin
	if rising_edge(clk) then
		case (menc_data_in_type) is
			when TYPE_SYNC  => menc_data_out_ff  <= SYM_SYNC;
			when TYPE_IDLE  => menc_data_out_ff  <= SYM_IDLE;
			when TYPE_TRIG  => menc_data_out_ff  <= SYM_TRIGG;
			when TYPE_START => menc_data_out_ff  <= SYM_START;
			when TYPE_DATA  => menc_data_out_ff  <= menc_data;
			when others     => menc_data_out_ff  <= SYM_IDLE;
		end case;
	end if;
end process;
--
--
end rtl;
