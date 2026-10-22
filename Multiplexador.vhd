-- Multiplexador 16:1
library ieee;
use ieee.std_logic_1164.all;

entity mux16x1 is
    port(
        e0, e1, e2, e3, e4, e5, e6, e7,
        e8, e9, e10, e11, e12, e13, e14, e15 : in std_logic_vector(7 downto 0);
        addr  : in  std_logic_vector(3 downto 0);
        saida : out std_logic_vector(7 downto 0)
    );
end entity mux16x1;

architecture comportamento of mux16x1 is
begin
    with addr select
        saida <= e0  when "0000",
                 e1  when "0001",
                 e2  when "0010",
                 e3  when "0011",
                 e4  when "0100",
                 e5  when "0101",
                 e6  when "0110",
                 e7  when "0111",
                 e8  when "1000",
                 e9  when "1001",
                 e10 when "1010",
                 e11 when "1011",
                 e12 when "1100",
                 e13 when "1101",
                 e14 when "1110",
                 e15 when "1111",
                 "00000000" when others;
end architecture comportamento;