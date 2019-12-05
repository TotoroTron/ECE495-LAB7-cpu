-- die_decoder.vhd
library ieee;
use ieee.std_logic_1164.all;

entity display is
  port (
    clk : in std_logic;
    A_q : in std_logic_vector(7 downto 0);
    hex_1: out std_logic_vector(6 downto 0);
	 hex_0: out std_logic_vector(6 downto 0)
  );
end display;

architecture behavior of display is
	signal not_hex_0 : std_logic_vector(6 downto 0);
	signal not_hex_1 : std_logic_vector(6 downto 0);
Begin

	DISPLAY_PROC: process(clk, A_q)
	begin
	if rising_edge(clk) then
		
		case A_q(7 downto 4) is
		when "0000" => not_hex_1 <= "0111111";
		When "0001" => not_hex_1 <= "0000110";
		When "0010" => not_hex_1 <= "1011011";
		When "0011" => not_hex_1 <= "1001111";
		When "0100" => not_hex_1 <= "1100110";
		When "0101" => not_hex_1 <= "1101101";
		When "0110" => not_hex_1 <= "1111101";
		When "0111" => not_hex_1 <= "0000111";
		When "1000" => not_hex_1 <= "1111111"; --8
		When "1001" => not_hex_1 <= "1101111"; --9
		When "1010" => not_hex_1 <= "1110111"; --A
		When "1011" => not_hex_1 <= "1111100"; --B
		when "1100" => not_hex_1 <= "0111001"; --12
		when "1101" => not_hex_1 <= "1011110"; --13
		when "1110" => not_hex_1 <= "1111001"; --14
		when "1111" => not_hex_1 <= "1110001"; --15
		when others => not_hex_1 <= "0000000";
		end case;
		
		Case A_q(3 downto 0) is
		when "0000" => not_hex_0 <= "0111111";
		When "0001" => not_hex_0 <= "0000110";
		When "0010" => not_hex_0 <= "1011011";
		When "0011" => not_hex_0 <= "1001111";
		When "0100" => not_hex_0 <= "1100110";
		When "0101" => not_hex_0 <= "1101101";
		When "0110" => not_hex_0 <= "1111101";
		When "0111" => not_hex_0 <= "0000111";
		When "1000" => not_hex_0 <= "1111111"; --8
		When "1001" => not_hex_0 <= "1101111"; --9
		When "1010" => not_hex_0 <= "1110111"; --A
		When "1011" => not_hex_0 <= "1111100"; --B
		when "1100" => not_hex_0 <= "0111001"; --12
		when "1101" => not_hex_0 <= "1011110"; --13
		when "1110" => not_hex_0 <= "1111001"; --14
		when "1111" => not_hex_0 <= "1110001"; --15
		when others => not_hex_0 <= "0000000";
		end case;
	end if;
		hex_0 <= not not_hex_0;
		hex_1 <= not not_hex_1;
	end process;
	

end behavior;


