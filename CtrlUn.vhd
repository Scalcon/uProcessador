library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CtrlUn is
	port(
		instruction 			: in unsigned(15 downto 0);
		ula_carry, ula_equals 	: in std_logic;
        opUla 					: out unsigned(1 downto 0);
        immGen					: out unsigned(15 downto 0);
        regCode 				: out unsigned(2 downto 0);
		jumpAdrs    			: out unsigned(6 downto 0);
		acc_wr_en, rb_wr_en, pc_jump_abs, pc_jump_rel, ula_src, rb_ld_src, acc_ld_src, acc_mv_ld_src, ram_wr_en, acc_ram_ld_src : out std_logic 

	);
end entity;
	
	architecture a_CtrlUn of CtrlUn is
						
			-- opcode declarations
			constant NOP 	  : unsigned(3 downto 0) := "0000";
			constant ADD 	  : unsigned(3 downto 0) := "0001";
			constant SUB 	  : unsigned(3 downto 0) := "0101";
			constant SUBI 	  : unsigned(3 downto 0) := "0100";
			constant CMP      : unsigned(3 downto 0) := "0111";
			constant AND_OP   : unsigned(3 downto 0) := "1000";
			constant XOR_OP   : unsigned(3 downto 0) := "1100";
			constant MV 	  : unsigned(3 downto 0) := "1010";
			constant LD 	  : unsigned(3 downto 0) := "1110";
			constant BEQ      : unsigned(3 downto 0) := "1011";
			constant BNE      : unsigned(3 downto 0) := "0010";
			constant BGE      : unsigned(3 downto 0) := "1001";
			constant BLT      : unsigned(3 downto 0) := "1101";
 			constant JUMP 	  : unsigned(3 downto 0) := "1111";
			constant WRAM     : unsigned(3 downto 0) := "0110";

			-- signal declarations
			signal s_opcode       : unsigned(3 downto 0) := "0000";
			signal s_opUla 		: unsigned(1 downto 0) := "00";
			signal s_immGen		: unsigned(15 downto 0) := "0000000000000000";
			signal s_regCode   	: unsigned(2 downto 0) := "000";
			signal s_jumpAdrs, s_ramAdrs     : unsigned(6 downto 0) := "0000000";
			signal s_acc_wr_en, s_rb_wr_en, s_pc_jump_abs, s_pc_jump_rel, s_ula_src, s_rb_ld_src, s_acc_ld_src, s_acc_mv_ld_src, s_ula_carry, s_ula_equals, s_ram_wr_en, s_acc_ram_ld_src : std_logic := '0';
		
	begin

		-- extrai o opcode
		s_opcode <= instruction(3 downto 0);

		s_regcode <= instruction(6 downto 4) when s_opcode = ADD
												or s_opcode = SUB
												or s_opcode = CMP
												or s_opcode = AND_OP
												or s_opcode = XOR_OP
											else
					instruction(7 downto 5) when s_opcode = LD
												or s_opcode = MV
												or s_opcode = WRAM
											else "000";


		s_immGen <= ("0000000" & instruction(15 downto 7)) when s_opcode = SUBI
											else
					( "00000000" & instruction(15 downto 8)) when s_opcode = LD
											else
					( "000000000" & instruction(10 downto 4)) when s_opcode = JUMP
																or s_opcode = BNE
																or s_opcode = BEQ
																or s_opcode = BGE
																or s_opcode = BLT
											else "0000000000000000"; 

					

		-- ula ops
		s_opUla <= "00" when s_opcode = ADD
					else
				 "01" when s_opcode = SUB
						or s_opcode = SUBI
						or s_opcode = CMP
					else
				"10" when s_opcode = AND_OP
					else
				"11" when s_opcode = XOR_OP
					else "00";
				
		-- write enablers
		s_acc_wr_en <= '1' when s_opcode = ADD
							or s_opcode = SUB
							or s_opcode = SUBI
							or s_opcode = AND_OP
							or s_opcode = XOR_OP
							or (s_opcode = LD and instruction(4) = '0')
							or (s_opcode = MV and instruction(4) = '0')
							or (s_opcode = WRAM and instruction(4) = '1')
						else '0';
		
		s_rb_wr_en <= '1' when (s_opcode = LD and instruction(4) = '1')
							or (s_opcode = MV and instruction(4) = '1')
						else '0';

		s_pc_jump_abs <= '1' when s_opcode = JUMP
							else '0';

		s_pc_jump_rel <= '1' when (s_opcode = BNE and ula_equals = '0')
								or (s_opcode = BEQ and ula_equals = '1')
								or (s_opcode = BGE and ula_carry = '0')
								or (s_opcode = BLT and ula_carry = '1')
							else '0';

		s_ram_wr_en <= '1' when (s_opcode = WRAM and instruction(4) = '0')
							else '0';

							
		-- sources, 1 = constantes, 0 = registradores
		s_ula_src <= '0' when s_opcode = ADD
						or s_opcode = SUB
						or s_opcode = CMP
						or s_opcode = AND_OP
						or s_opcode = XOR_OP
					else '1';
		
		s_rb_ld_src <= '1' when (s_opcode = LD and instruction(4) = '1')
						else '0';
		
		s_acc_ld_src <= '1' when (s_opcode = LD and instruction(4) = '0')
							or (s_opcode = MV and instruction(4) = '0')
							or (s_opcode = WRAM and instruction(4) = '1')
						else '0';

		s_acc_ram_ld_src <= '1' when (s_opcode = WRAM and instruction(4) = '1')
						else '0';
		
		s_acc_mv_ld_src <= '1' when (s_opcode = MV and instruction(4) = '0')
						else '0';
		
		-- jump no pc
		s_jumpAdrs <= instruction(10 downto 4) when s_opcode = JUMP
												or (s_opcode = BNE and ula_equals = '0')
												or (s_opcode = BEQ and ula_equals = '1')
												or (s_opcode = BGE and ula_carry = '0' and ula_equals = '0')
												or (s_opcode = BLT and ula_carry = '1')
					else "0000000";

		opUla <= s_opUla;
		immGen <= s_immGen;
		regCode <= s_regCode;
		jumpAdrs <= s_jumpAdrs;
		ula_src <= s_ula_src;
		rb_ld_src <= s_rb_ld_src;
		acc_ld_src <= s_acc_ld_src;
		acc_mv_ld_src <= s_acc_mv_ld_src;
		acc_wr_en <= s_acc_wr_en;
		rb_wr_en <= s_rb_wr_en;
		pc_jump_abs <= s_pc_jump_abs;
		pc_jump_rel <= s_pc_jump_rel;
		ram_wr_en <= s_ram_wr_en;
		acc_ram_ld_src <= s_acc_ram_ld_src;

	end architecture a_CtrlUn;