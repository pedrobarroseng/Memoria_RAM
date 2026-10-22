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

    FF0: ffd port map (d => d(0), clk => clk, enable => enable, clear => clear, q => q(0));
    FF1: ffd port map (d => d(1), clk => clk, enable => enable, clear => clear, q => q(1));
    FF2: ffd port map (d => d(2), clk => clk, enable => enable, clear => clear, q => q(2));
    FF3: ffd port map (d => d(3), clk => clk, enable => enable, clear => clear, q => q(3));
    FF4: ffd port map (d => d(4), clk => clk, enable => enable, clear => clear, q => q(4));
    FF5: ffd port map (d => d(5), clk => clk, enable => enable, clear => clear, q => q(5));
    FF6: ffd port map (d => d(6), clk => clk, enable => enable, clear => clear, q => q(6));
    FF7: ffd port map (d => d(7), clk => clk, enable => enable, clear => clear, q => q(7));

end architecture estrutura;