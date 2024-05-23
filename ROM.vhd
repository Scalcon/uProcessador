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
		0 => B"00000101_011_1_1110",
		1 => B"00001000_100_1_1110",
		2 => B"00000000_011_0_1010",
		3 => B"000000000_100_0001",
		4  => B"00000000_101_1_1010",
		5  => B"000000001_101_0100",
		6  => B"00000000_101_1_1010",
		7  => B"00000_0010100_1111",
		8  => B"00000000_101_1_1110",
		9  => B"000000000000_0000",
		10  => B"000000000000_0000",
		11  => B"000000000000_0000",
		12  => B"000000000000_0000",
		13  => B"000000000000_0000",
		14  => B"000000000000_0000",
		15  => B"000000000000_0000",
		16  => B"000000000000_0000",
		17  => B"000000000000_0000",
		18  => B"000000000000_0000",
		19  => B"000000000000_0000",
		20  => B"00000000_101_0_1010",
		21  => B"00000000_011_1_1010",
		22  => B"00000_0000010_1111",
		23  => B"00000000_011_1_1110",
		
		others => (others => '0')
	);
	begin
		
	process(clk) begin
			
		if(rising_edge(clk)) then
			instout <= conteudo_rom(to_integer(address));
		end if;
	end process;
end architecture;	