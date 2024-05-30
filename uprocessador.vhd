library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uprocessador is
	port(
		clk   : in std_logic;
		rst   : in std_logic;
		estado : out  unsigned (1 downto 0);
		pcAdrs	: out unsigned(6 downto 0);
		instrucao : out unsigned (15 downto 0);
		reg_out1, reg_acumulador : out unsigned(15 downto 0);
		ula_out : out unsigned(15 downto 0)
		);

	end entity uprocessador;


architecture a_uprocessador of uprocessador is

	component bank_ula is
		port( 
			rst, clk, load_src, ula_src, acc_wr_en, rb_wr_en, acc_ld_src : in std_logic;
			reg_code                                         : in unsigned(2 downto 0);
			ula_op                                           : in unsigned(1 downto 0);
			constgen                                         : in unsigned(15 downto 0);
			carry_out, equals_out                            : out std_logic;
			--debbug pins d_
			d_acc_out, d_rb_out , d_ula_out                  : out unsigned(15 downto 0) 
		);
	end component;

	component CtrlUn is
		port (
			instruction 		  : in unsigned(15 downto 0);
			ula_carry, ula_equals : in std_logic;
			opUla 				  : out unsigned(1 downto 0);
			immGen				  : out unsigned(15 downto 0);
			regCode 			  : out unsigned(2 downto 0);
			jumpAdrs    		  : out unsigned(6 downto 0);
			acc_wr_en, rb_wr_en, pc_jump_abs, pc_jump_rel, ula_src, rb_ld_src, acc_ld_src, acc_mv_ld_src : out std_logic 
		);
	end component;
	
		
	component PCcompleto is 
		port(
			clk, wrEn, rst, jumpAbs, jumpRel : in std_logic;
			dataIn                           : in unsigned(6 downto 0);
			dataOut                          : out unsigned(6 downto 0)
		);
	end component;
	
	component ROM is 
		port(	
			clk     : in std_logic;
			address : in unsigned(6 downto 0);
			instout  : out unsigned(15 downto 0)
		);
	end component;
	
	component MaquinaEstados is
		port(
			clk   : in std_logic;
			rst   : in std_logic;
			estado : out  unsigned (1 downto 0)
		);
	end component;

	component flipflop is
		port ( clk, rst, wr_en : in std_logic;
			data_in         : in std_logic;
			data_out        : out std_logic
 		);
	end component;
	
	signal s_acc_wr_en, s_rb_wr_en, s_pc_jump_abs, s_pc_jump_rel, s_ula_src, s_rb_ld_src, s_acc_ld_src, s_acc_mv_ld_src, s_carry, s_equals : std_logic := '0'; 
	signal s_wr_en, s_sm_rb_wr_en, s_sm_acc_wr_en, s_ff_carry, s_ff_uc_wr_en : std_logic := '0';
	signal s_ulaOp, s_state : unsigned(1 downto 0) := "00";
	signal s_regCode	: unsigned(2 downto 0) := "000";
	signal s_jumpAdrs, s_PCout : unsigned(6 downto 0) := "0000000";
	signal s_ROMOut, s_acc_out, s_rb_out, s_ula_out, s_imm_gen, s_ula_in, s_ula_imm_in : unsigned(15 downto 0) := "0000000000000000";
	
	begin
		
		MaqEst: MaquinaEstados port map (
			clk => clk,
			rst => rst,
			estado => s_state
		);

		PC0 : PCcompleto port map (
			clk => clk,
			rst => rst,
			jumpAbs => s_pc_jump_abs,
			jumpRel => s_pc_jump_rel,
			wrEn => s_wr_en,
			dataIn => s_jumpAdrs,
			dataOut => s_PCout
		);

		ROM0: ROM port map (
			clk => clk,
			address => s_PCout,
			instout => s_ROMOut
		);

		UC0 : CtrlUn port map (
			instruction => s_ROMOut,
			ula_carry => s_ff_carry,
			ula_equals => s_equals,
			opUla => s_ulaOp,
			immGen => s_imm_gen,
			regCode => s_regCode,
			jumpAdrs => s_jumpAdrs,
			acc_wr_en => s_acc_wr_en,
			rb_wr_en => s_rb_wr_en,
			pc_jump_abs => s_pc_jump_abs,
			pc_jump_rel => s_pc_jump_rel,
			ula_src => s_ula_src,
			rb_ld_src => s_rb_ld_src,
			acc_ld_src => s_acc_ld_src,
			acc_mv_ld_src => s_acc_mv_ld_src
		);
		
		BUla : bank_ula port map (
			rst => rst,
			clk => clk,
			load_src => s_rb_ld_src,
			ula_src => s_ula_src,
			acc_wr_en => s_sm_acc_wr_en,
			rb_wr_en => s_sm_rb_wr_en,
			acc_ld_src => s_acc_ld_src,
			reg_code => s_regCode,
			ula_op => s_ulaOp,
			constgen => s_ula_imm_in,
			carry_out => s_carry,
			equals_out => s_equals,
			d_acc_out => s_acc_out,
			d_rb_out => s_rb_out,
			d_ula_out => s_ula_out
		);

		UCff : flipflop port map (
			clk => clk,
			rst => rst,
			wr_en => s_ff_uc_wr_en,
			data_in => s_carry,
			data_out => s_ff_carry
		);

		--write enablers com maquina de estados
		s_wr_en <= '1' when s_state = "10" else '0';
		s_sm_rb_wr_en <= s_rb_wr_en when s_state = "01" else '0';
		s_sm_acc_wr_en <= s_acc_wr_en when s_state = "01" else '0';
		s_ff_uc_wr_en <= '1' when s_state = "01" else '0';

		
		s_ula_imm_in <= s_rb_out when s_acc_mv_ld_src = '1' else
			s_imm_gen; 

		estado <= s_state;
		pcAdrs <= s_PCOut;
		instrucao <= s_ROMOut;
		reg_out1 <= s_rb_out; 
		reg_acumulador <= s_acc_out;
		ula_out <= s_ula_out;
		
end a_uprocessador;