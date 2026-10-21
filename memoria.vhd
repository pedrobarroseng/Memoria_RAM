library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity memoria is
    Port (
        clk    : in  STD_LOGIC;
        clear  : in  STD_LOGIC;
        enable : in  STD_LOGIC;
        addr   : in  STD_LOGIC_VECTOR (3 downto 0);
        D_in   : in  STD_LOGIC_VECTOR (7 downto 0);
        D_out  : out STD_LOGIC_VECTOR (7 downto 0)
    );
end memoria;

architecture comportamento of memoria is


begin


end comportamento;