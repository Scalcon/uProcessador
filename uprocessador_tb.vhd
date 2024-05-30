library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity uprocessador_tb is
end;

architecture a_uprocessador of uprocessador_tb is
    component uprocessador is
        port(
            clk   : in std_logic;
            rst   : in std_logic;
            estado : out  unsigned (1 downto 0);
            pcAdrs	: out unsigned(6 downto 0);
            instrucao : out unsigned (15 downto 0);
            reg_out1, reg_acumulador : out unsigned(15 downto 0);
            ula_out : out unsigned(15 downto 0)
        );
    end component;

    signal CLK, RST: std_logic := '0';
    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';
    signal estado : unsigned (1 downto 0) := "00"; 
    signal pcAdrs : unsigned (6 downto 0) := "0000000";
    signal instrucao, ula_out, reg_acumulador, reg_out1 : unsigned (15 downto 0) := "0000000000000000";
            

    begin
        uut: uprocessador port map(
            clk => CLK,
            rst => RST,
            estado => estado,
            pcAdrs => pcAdrs,
            instrucao => instrucao,
            ula_out => ula_out,
            reg_acumulador => reg_acumulador,
            reg_out1 => reg_out1
        );

        reset_global: process
        begin   
            RST <= '1';
            wait for period_time*2;
            RST <= '0';
            wait;
    end process;

    sim_time_process: process
    begin
        wait for 100 us;
        finished <= '1';
        wait;
    end process sim_time_process;

    clk_proc: process
    begin
        while finished /= '1' loop
            CLK <= '0';
            wait for period_time/2;
            CLK <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;

    process
    begin
        wait for 200 ns;
            
        wait for 100 ns;
        wait for 100 ns;
        wait for 100 ns;
        wait for 100 ns;
        wait for 100 ns;
        wait for 100 ns;
        wait for 100 ns;
        wait for 100 ns;
        wait for 100 ns;
        wait for 100 ns;
        wait for 100 ns;
        wait for 100 ns;
        wait for 100 ns;
        wait for 100 ns;
        wait for 100 ns;
        wait for 100 ns;
        wait for 100 ns;
        wait for 100 ns;
        wait for 100 ns;

        wait for 100 ns;
        wait;
    end process;
end a_uprocessador;
