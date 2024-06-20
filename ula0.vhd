-- alunos: Pedro Augusto Scalcon e Rodrigo Moliani Braga
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula0 is
    port(   in1 : in unsigned(15 downto 0);
            in2 : in unsigned(15 downto 0);
            selec_op : in unsigned(1 downto 0);
            out_res : out unsigned (15 downto 0);
            carry : out std_logic;
            equals : out std_logic
        );
end entity;

architecture aUla of ula0 is
    --sinal para verificação de carry, que ocorre somente nas operações de soma e subtração:
    signal sum_sub_ops : unsigned(16 downto 0);

    begin

        sum_sub_ops <= "0" & in1 + in2 when selec_op = "00" else
                   "0" & in1 - in2 when selec_op = "01" else
        "00000000000000000";
 
        out_res <= sum_sub_ops(15 downto 0) when selec_op = "00" or selec_op = "01" else
                   in1 and in2 when selec_op = "10" else
                   in1 or in2 when selec_op = "11" else
                   "0000000000000000";
        
        equals <= '1' when sum_sub_ops = "00000000000000000" AND selec_op = "01"
                    else '0';
        
        carry <= sum_sub_ops(16);
end architecture;
            
    