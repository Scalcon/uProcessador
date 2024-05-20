library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uprocessador is
	port(
		clk   : in std_logic;
		rst   : in std_logic;
		estado : out  std_logic;
		PC	: out unsigned(6 downto 0);
		instrucao : out unsigned (15 downto 0);
		reg_out1, reg_out2, reg_acumulador : out unsigned(15 downto 0);
		ula_out out :  unsigned(15 downto 0)
		);

	end entity uprocessador;


architecture a_uprocessador of uprocessador is

	component bank_ula is
		port( 
		rst, clk, load_src, ula_src, acc_wr_en, rb_wr_en : in std_logic;
		reg_code                                         : in unsigned(2 downto 0);
		ula_op                                           : in unsigned(1 downto 0);
		constgen                                         : in unsigned(15 downto 0);
		carry_out                                        : out std_logic;
		--debbug pins d_
		d_acc_out, d_rb_out , d_ula_out                  : out unsigned(15 downto 0) 
		);
	end component;

	component CtrlUn is
		port (
		clk, rst : in std_logic;
		PcOut : out unsigned()

		);
	end component;
	
	signal 
	
	signal load_source, ula_source: in std_logic := "0";
	signal acc_write_en, rb_wr_en: in std_logic := "1";

	begin 

	Controle: CtrlUn port map(rst, clk, PcOut);
	Banco_Ula: bank_ula port map(rst, clk, load_source, ula_source, )

	PC <= PcOut;

	end a_uprocessador;