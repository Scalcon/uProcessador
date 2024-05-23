library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bank_ula is 
    port (  rst, clk, load_src, ula_src, acc_wr_en, rb_wr_en, acc_ld_src : in std_logic;
            reg_code                                         : in unsigned(2 downto 0);
            ula_op                                           : in unsigned(1 downto 0);
            constgen                                         : in unsigned(15 downto 0);
            carry_out, equals_out                                : out std_logic;
            --debbug pins d_
            d_acc_out, d_rb_out , d_ula_out                  : out unsigned(15 downto 0)
    );
end entity bank_ula;

architecture a_bank_ula of bank_ula is
        
    component ula0 is
        port(
            in1, in2 :      in unsigned(15 downto 0);
            selec_op :      in unsigned(1 downto 0);
            out_res  :      out unsigned(15 downto 0);
            carry    :      out std_logic;
            equals   :      out std_logic
        );
    end component;

    component ban_reg is
        port (read1, wrt         : in unsigned(2 downto 0);
              data_in            : in unsigned(15 downto 0);
              clk, rst, wr_en    : in std_logic;
              reg_out            : out unsigned(15 downto 0)
        );
    end component;

    component reg16bits is
        port (clk, rst, wr_en : in std_logic;
              data_in         : in unsigned(15 downto 0);
              data_out        : out unsigned(15 downto 0)
        );
    end component;

    signal ula_in, ula_out, rb_in, acc_in : unsigned(15 downto 0);
    signal rb_out, acc_out        : unsigned(15 downto 0);
    signal carry, equals                 : std_logic;

    begin
        --mux para constante no banco de registradores
        rb_in <= constgen when load_src = '1' else acc_out;
        --mux para constante na ula
        ula_in <= constgen when ula_src = '1' else rb_out;
        --mux para ld src do acc
        acc_in <= constgen when acc_ld_src = '1' else ula_out;

        ula: ula0 port map(ula_in, acc_out, ula_op, ula_out, carry, equals);
        rb: ban_reg port map(reg_code, reg_code, rb_in, clk, rst, rb_wr_en, rb_out);
        acc: reg16bits port map(clk, rst, acc_wr_en, acc_in, acc_out);

        --outputs
        d_ula_out <= ula_out;
        d_rb_out <= rb_out;
        d_acc_out <= acc_out;
        carry_out <= carry;
        equals_out <= equals;
        
    end a_bank_ula;
        



