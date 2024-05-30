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
		0 =>   B"00000000_011_1_1110",
		1 =>   B"00000000_100_1_1110",
		2 =>   B"00000000_011_0_1010",
		3 =>  B"000000000_100_0001",
		4  =>  B"00000000_100_1_1010",
		5  =>  B"00000001_000_0_1110",
		6  => B"000000000_011_0001",
		7  =>  B"00000000_011_1_1010",
		8  => B"000011110_011_0100",
		9  => B"00000_1111001_1101",
		10  => B"00000000_100_0_1010",
		11  => B"00000000_101_1_1010",

		others => (others => '0')
	);
	begin
		
	process(clk) begin
			
		if(rising_edge(clk)) then
			instout <= conteudo_rom(to_integer(address));
		end if;
	end process;
end architecture;	