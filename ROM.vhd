library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is
	port(	clk     : in std_logic;
			address : in unsigned(6 downto 0);
			instout  : out unsigned(15 downto 0)
		);
end entity;

architecture a_ROM of ROM is
	type mem is array (0 to 127) of unsigned (15 downto 0);
	constant conteudo_rom : mem :=( 
	0 =>	B"00000111_000_1_1110",
	1 => 	B"00000110_001_1_1110",
	2 =>	B"00000101_010_1_1110",
	3 =>	B"00000100_011_1_1110",
	4 =>	B"00000011_100_1_1110",
	5 =>	B"00000010_101_1_1110",
	6 =>	B"00000001_110_1_1110",
	7 =>	B"00000000_111_1_1110",
	8 =>	B"00000000000_0_1110",
	9 =>	B"00000000000_0_0110",
	10 =>	B"00000001001_0_1110",
	11 =>	B"00000000001_0_0110",
	12 =>	B"00000001010_0_1110",
	13 =>	B"00000000010_0_0110",
	14 =>	B"00000011011_0_1110",
	15 =>	B"00000000011_0_0110",
	16 =>	B"00000100100_0_1110",
	17 =>	B"00000000100_0_0110",
	18 =>	B"00000101101_0_1110",
	19 =>	B"00000000101_0_0110",
	20 =>	B"00000110110_0_1110",
	21 =>	B"00000000110_0_0110",
	22 =>	B"00000111111_0_1110",
	23 =>	B"00000000111_0_0110",
	24 =>	B"00000000101_1_0110",
	25 =>	B"00000000100_1_0110",
	26 =>	B"00000000011_1_0110",

		others => (others => '0')
	);
	begin
		
	process(clk) begin
			
		if(rising_edge(clk)) then
			instout <= conteudo_rom(to_integer(address));
		end if;
	end process;
end architecture;	