-- ****************************************************************************
--	MODULE  	: mdec_nible.vhd
--	AUTHOR  	: Cristian Gingu
--	VERSION 	: v1.00
--	DATE		: 12.15.2015
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

library UNISIM;
use UNISIM.VComponents.all;

use work.hgc_pck.all;

entity mdec_nibble is
	port ( 
	clk                 : in std_logic;
	mdec_data_in        : in std_logic_vector(7 downto 0);
	mdec_data_out_type  : out SYM_TYPE;
	mdec_data_out       : out std_logic_vector(3 downto 0)
	);
end mdec_nibble;

architecture rtl of mdec_nibble is
--
signal mdec_data_out_type_ff  : SYM_TYPE:=TYPE_INVALID;
signal mdec_data_out_ff       : std_logic_vector(3 downto 0):="0000";
signal mdec_data_valid_comb   : std_logic;
signal mdec_data_bit0_comb    : std_logic;
signal mdec_data_bit1_comb    : std_logic;
signal mdec_data_bit2_comb    : std_logic;
signal mdec_data_bit3_comb    : std_logic;
--
begin
--
--
-- ****************************************************************************
-- Create logic for mdec_data_out and mdec_data_out_type registered output ports.
-- ****************************************************************************
mdec_data_out_type  <= mdec_data_out_type_ff;
mdec_data_out       <= mdec_data_out_ff;
--
process(clk) is
begin
	if rising_edge(clk) then
		--
		-- See package hgc_pck.vhd for SYM_TYPE:
		if mdec_data_in = SYM_IDLE then 
			mdec_data_out_type_ff <= TYPE_IDLE;
			mdec_data_out_ff      <= "0000";
		elsif mdec_data_in = SYM_START then 
			mdec_data_out_type_ff <= TYPE_START;
			mdec_data_out_ff      <= "0000";
		elsif mdec_data_in = SYM_TRIGG then 
			mdec_data_out_type_ff <= TYPE_TRIG;
			mdec_data_out_ff      <= "0000";
		elsif mdec_data_in = SYM_SYNC then 
			mdec_data_out_type_ff <= TYPE_SYNC;
			mdec_data_out_ff      <= "0000";
		elsif mdec_data_valid_comb = '1' then 
			mdec_data_out_type_ff <= TYPE_DATA;
			mdec_data_out_ff      <= mdec_data_bit3_comb & mdec_data_bit2_comb & mdec_data_bit1_comb & mdec_data_bit0_comb;
		else
			mdec_data_out_type_ff <= TYPE_INVALID;
			mdec_data_out_ff      <= "0000";
		end if;
		--
	end if;
end process;
--
--
-- ****************************************************************************
-- Create logic for mdec_data_valid_comb combinatorial signal.
-- See hgc_pck.vhd logical OR of SYM_0000 to SYM_1111
-- ****************************************************************************
inst_ROM256X1_data_valid: ROM256X1
generic map (
	INIT => X"0000000000000000000006600660000000000660066000000000000000000000")
--	         "3210987654321098765432109876543210987654321098765432109876543210")
--	         "   6         5         4         3         2         1          ")
port map (
	O => mdec_data_valid_comb,   -- ROM output
	A0 => mdec_data_in(0), -- ROM address[0]
	A1 => mdec_data_in(1), -- ROM address[1]
	A2 => mdec_data_in(2), -- ROM address[2]
	A3 => mdec_data_in(3), -- ROM address[3]
	A4 => mdec_data_in(4), -- ROM address[4]
	A5 => mdec_data_in(5), -- ROM address[5]
	A6 => mdec_data_in(6), -- ROM address[6]
	A7 => mdec_data_in(7)  -- ROM address[7]
);
--
-- ****************************************************************************
-- Create logic for bit0 of mdec_data registered output port.
-- bit0: See hgc_pck.vhd logical OR of SYM_0000 to SYM_1111 
-- (4*21 + 2, 4*22 + 2, 4*25 + 2, 4*26 + 2, 4*37 + 2...)
-- ****************************************************************************
inst_ROM256X1_data_bit0: ROM256X1
generic map (
	INIT => X"0000000000000000000004400440000000000440044000000000000000000000")
--	         "3210987654321098765432109876543210987654321098765432109876543210")
--	         "   6         5         4         3         2         1          ")
port map (
	O => mdec_data_bit0_comb,   -- ROM output
	A0 => mdec_data_in(0), -- ROM address[0]
	A1 => mdec_data_in(1), -- ROM address[1]
	A2 => mdec_data_in(2), -- ROM address[2]
	A3 => mdec_data_in(3), -- ROM address[3]
	A4 => mdec_data_in(4), -- ROM address[4]
	A5 => mdec_data_in(5), -- ROM address[5]
	A6 => mdec_data_in(6), -- ROM address[6]
	A7 => mdec_data_in(7)  -- ROM address[7]
);
--
-- ****************************************************************************
-- Create logic for bit1 of mdec_data registered output port.
-- bit1: See hgc_pck.vhd logical OR of SYM_0000 to SYM_1111 
-- (4*22 + 1, 4*22 + 2, 4*26 + 1, 4*26 + 2, 4*38 + 1, 4*38 + 2...)
-- ****************************************************************************
inst_ROM256X1_data_bit1: ROM256X1
generic map (
	INIT => X"0000000000000000000006000600000000000600060000000000000000000000")
--	         "3210987654321098765432109876543210987654321098765432109876543210")
--	         "   6         5         4         3         2         1          ")
port map (
	O => mdec_data_bit1_comb,   -- ROM output
	A0 => mdec_data_in(0), -- ROM address[0]
	A1 => mdec_data_in(1), -- ROM address[1]
	A2 => mdec_data_in(2), -- ROM address[2]
	A3 => mdec_data_in(3), -- ROM address[3]
	A4 => mdec_data_in(4), -- ROM address[4]
	A5 => mdec_data_in(5), -- ROM address[5]
	A6 => mdec_data_in(6), -- ROM address[6]
	A7 => mdec_data_in(7)  -- ROM address[7]
);
--
-- ****************************************************************************
-- Create logic for bit2 of mdec_data registered output port.
-- bit2: See hgc_pck.vhd logical OR of SYM_0000 to SYM_1111 
-- (4*25 + 1, 4*25 + 2, 4*26 + 1, 4*26 + 2, 4*41 + 1, 4*41 + 2...)
-- ****************************************************************************
inst_ROM256X1_data_bit2: ROM256X1
generic map (
	INIT => X"0000000000000000000006600000000000000660000000000000000000000000")
--	         "3210987654321098765432109876543210987654321098765432109876543210")
--	         "   6         5         4         3         2         1          ")
port map (
	O => mdec_data_bit2_comb,   -- ROM output
	A0 => mdec_data_in(0), -- ROM address[0]
	A1 => mdec_data_in(1), -- ROM address[1]
	A2 => mdec_data_in(2), -- ROM address[2]
	A3 => mdec_data_in(3), -- ROM address[3]
	A4 => mdec_data_in(4), -- ROM address[4]
	A5 => mdec_data_in(5), -- ROM address[5]
	A6 => mdec_data_in(6), -- ROM address[6]
	A7 => mdec_data_in(7)  -- ROM address[7]
);
--
-- ****************************************************************************
-- Create logic for bit3 of mdec_data registered output port.
-- bit3: See hgc_pck.vhd logical OR of SYM_0000 to SYM_1111 
-- (4*37 + 1, 4*37 + 2, 4*38 + 1, 4*38 + 2, 4*41 + 1, 4*41 + 2...)
-- ****************************************************************************
inst_ROM256X1_data_bit3: ROM256X1
generic map (
	INIT => X"0000000000000000000006600660000000000000000000000000000000000000")
--	         "3210987654321098765432109876543210987654321098765432109876543210")
--	         "   6         5         4         3         2         1          ")
port map (
	O => mdec_data_bit3_comb,   -- ROM output
	A0 => mdec_data_in(0), -- ROM address[0]
	A1 => mdec_data_in(1), -- ROM address[1]
	A2 => mdec_data_in(2), -- ROM address[2]
	A3 => mdec_data_in(3), -- ROM address[3]
	A4 => mdec_data_in(4), -- ROM address[4]
	A5 => mdec_data_in(5), -- ROM address[5]
	A6 => mdec_data_in(6), -- ROM address[6]
	A7 => mdec_data_in(7)  -- ROM address[7]
);
--
end rtl;
