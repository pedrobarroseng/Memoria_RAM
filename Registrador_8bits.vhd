library ieee;
use ieee.std_logic_1164.all;

entity Registrador_8bits is
    port(
        clk, enable, clear : in std_logic;
        d : in std_logic_vector(7 downto 0);
        q : out std_logic_vector(7 downto 0)
    );
end entity Registrador_8bits;

architecture estrutura of Registrador_8bits is

    component ffd
        port(
            d, clk, enable, clear : in std_logic;
            q : out std_logic
        );
    end component ffd;

begin

    gera_FF: for i in 0 to 7 generate
        ff_inst : ffd
            port map(
                d => d(i),
                clk => clk,
                enable => enable,
                clear => clear,
                q => q(i)
            );
    end generate gera_FF;   

end architecture estrutura;