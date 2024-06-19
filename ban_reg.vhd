library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ban_reg is
    port ( read1, wrt         : in unsigned(2 downto 0);
           data_in            : in unsigned(15 downto 0);
           clk, rst, wr_en    : in std_logic;
           reg_out            : out unsigned(15 downto 0)
    );
end ban_reg;

architecture a_ban_reg of ban_reg is
    component reg16bits is
      port ( clk, rst, wr_en : in std_logic;
             data_in         : in unsigned(15 downto 0);
             data_out        : out unsigned(15 downto 0)
           );
    end component;  

    signal zero, reg1, reg2, reg3, reg4, reg5, reg6, reg7 : unsigned(15 downto 0);
    signal wr_en0, wr_en1, wr_en2, wr_en3, wr_en4, wr_en5, wr_en6, wr_en7 : std_logic;

begin   
           wr_en0 <= '1' when wrt = "000" and wr_en = '1' else '0'; 
           wr_en1 <= '1' when wrt = "001" and wr_en = '1' else '0';
           wr_en2 <= '1' when wrt = "010" and wr_en = '1' else '0';
           wr_en3 <= '1' when wrt = "011" and wr_en = '1' else '0';
           wr_en4 <= '1' when wrt = "100" and wr_en = '1' else '0';
           wr_en5 <= '1' when wrt = "101" and wr_en = '1' else '0';
           wr_en6 <= '1' when wrt = "110" and wr_en = '1' else '0';
           wr_en7 <= '1' when wrt = "111" and wr_en = '1' else '0';

    register0: reg16bits port map(clk => clk, rst => rst, wr_en => wr_en0, data_in => data_in, data_out => zero);      
    register1: reg16bits port map(clk => clk, rst => rst, wr_en => wr_en1, data_in => data_in, data_out => reg1);
    register2: reg16bits port map(clk => clk, rst => rst, wr_en => wr_en2, data_in => data_in, data_out => reg2);
    register3: reg16bits port map(clk => clk, rst => rst, wr_en => wr_en3, data_in => data_in, data_out => reg3);
    register4: reg16bits port map(clk => clk, rst => rst, wr_en => wr_en4, data_in => data_in, data_out => reg4);
    register5: reg16bits port map(clk => clk, rst => rst, wr_en => wr_en5, data_in => data_in, data_out => reg5);
    register6: reg16bits port map(clk => clk, rst => rst, wr_en => wr_en6, data_in => data_in, data_out => reg6);
    register7: reg16bits port map(clk => clk, rst => rst, wr_en => wr_en7, data_in => data_in, data_out => reg7);

    reg_out <=  zero when read1 = "000" else
                reg1 when read1 = "001" else
                reg2 when read1 = "010" else
                reg3 when read1 = "011" else
                reg4 when read1 = "100" else
                reg5 when read1 = "101" else
                reg6 when read1 = "110" else
                reg7 when read1 = "111" else
                "0000000000000000";
        
end a_ban_reg;