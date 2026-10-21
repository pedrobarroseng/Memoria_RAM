library ieee;
use ieee.std_logic_1164.all;

entity ffd is
    port(
        d, clk, enable, clear : in std_logic;
        q : out std_logic
    );
end entity ffd;

architecture comportamento of ffd is

begin    

process(clk, clear)
begin
    if(clear = '1') then
        q <= '0';
    elsif(rising_edge(clk)) then
        if(enable = '1') then
            q <= d;
        end if;
    end if;
end process;

end architecture comportamento;