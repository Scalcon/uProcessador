library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PCcompleto is
    port(
        clk, wrEn, rst, jumpInst : in std_logic;
        dataIn                   : in unsigned(6 downto 0);
        dataOut                  : out unsigned(6 downto 0)
    );
end entity PCcompleto;

architecture a_PCcompleto of PCcompleto is
    
    component PC is
        port(
            clk  	 : in std_logic;
            wrEn 	 : in std_logic;
            rst      : in std_logic;
            dataIn   : in  unsigned(6 downto 0);
            dataOut  : out unsigned(6 downto 0)
        );
    end component;
    
    -- Declaração de sinais
    signal endAtual, endProx : unsigned(6 downto 0) := "0000000";    -- Endereços por padrão começam em 0

begin
    
    CP0 : PC port map (clk, wrEn, rst, endProx, endAtual);
    
    -- MUX de entrada, para o próximo endereço caso tenha instrução de pulo
    endProx <= endAtual + "0000001" when jumpInst = '0' else dataIn;
    dataOut <= endAtual;
    
end a_PCcompleto;
