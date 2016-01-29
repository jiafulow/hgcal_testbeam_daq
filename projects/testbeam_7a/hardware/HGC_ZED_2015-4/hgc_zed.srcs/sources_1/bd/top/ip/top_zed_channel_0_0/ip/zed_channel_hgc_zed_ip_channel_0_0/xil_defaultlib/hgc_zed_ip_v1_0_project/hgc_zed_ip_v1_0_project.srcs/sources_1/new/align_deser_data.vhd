-- ****************************************************************************
--	MODULE  	: align_deser_data.vhd
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
-- ****************************************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity align_deser_data is
	port ( 
	clk                 : in std_logic;
	deser_data          : in std_logic_vector(7 downto 0);
	deser_data_offset   : in std_logic_vector(2 downto 0);
	deser_data_aligned  : out std_logic_vector(7 downto 0)
	);
end align_deser_data;

architecture rtl of align_deser_data is
--
signal deser_data_aligned_ff  : std_logic_vector(7 downto 0):=X"00";
signal deser_data_15to0_ff    : std_logic_vector(15 downto 0):=X"0000";

--
begin
--
--
-- ****************************************************************************
-- Create logic for deser_data_aligned registered output port.
-- ****************************************************************************
deser_data_aligned  <= deser_data_aligned_ff;
--
process(clk) is
begin
	if rising_edge(clk) then
		--
		deser_data_15to0_ff(7 downto 0)   <= deser_data;
		deser_data_15to0_ff(15 downto 8)  <= deser_data_15to0_ff(7 downto 0);
		--
		case deser_data_offset is
--			when "000" => deser_data_aligned_ff <= deser_data_15to0_ff(15 downto 8);
--			when "001" => deser_data_aligned_ff <= deser_data_15to0_ff(14 downto 7);
--			when "010" => deser_data_aligned_ff <= deser_data_15to0_ff(13 downto 6);
--			when "011" => deser_data_aligned_ff <= deser_data_15to0_ff(12 downto 5);
--			when "100" => deser_data_aligned_ff <= deser_data_15to0_ff(11 downto 4);
--			when "101" => deser_data_aligned_ff <= deser_data_15to0_ff(10 downto 3);
--			when "110" => deser_data_aligned_ff <= deser_data_15to0_ff(9 downto 2);
--			when "111" => deser_data_aligned_ff <= deser_data_15to0_ff(8 downto 1);
--			when others => deser_data_aligned_ff <= deser_data_15to0_ff(15 downto 8);
			when "000" => deser_data_aligned_ff <= deser_data_15to0_ff(7 downto 0);
			when "001" => deser_data_aligned_ff <= deser_data_15to0_ff(8 downto 1);
			when "010" => deser_data_aligned_ff <= deser_data_15to0_ff(9 downto 2);
			when "011" => deser_data_aligned_ff <= deser_data_15to0_ff(10 downto 3);
			when "100" => deser_data_aligned_ff <= deser_data_15to0_ff(11 downto 4);
			when "101" => deser_data_aligned_ff <= deser_data_15to0_ff(12 downto 5);
			when "110" => deser_data_aligned_ff <= deser_data_15to0_ff(13 downto 6);
			when "111" => deser_data_aligned_ff <= deser_data_15to0_ff(14 downto 7);
			when others => deser_data_aligned_ff <= deser_data_15to0_ff(7 downto 0);
		end case;
		--
	end if;
end process;
--
--

--
end rtl;
