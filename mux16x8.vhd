library ieee;
use ieee.std_logic_1164.all;

-- Multiplexador 16 para 1, com dados de 8 bits
entity mux16x8 is
    port(
        d0, d1, d2, d3, d4, d5, d6, d7     : in  std_logic_vector(7 downto 0);
        d8, d9, d10, d11, d12, d13, d14, d15 : in  std_logic_vector(7 downto 0);
        addr : in  std_logic_vector(3 downto 0);
        y    : out std_logic_vector(7 downto 0)
    );
end entity mux16x8;

architecture comportamento of mux16x8 is
begin
    with addr select
        y <= d0  when "0000",
             d1  when "0001",
             d2  when "0010",
             d3  when "0011",
             d4  when "0100",
             d5  when "0101",
             d6  when "0110",
             d7  when "0111",
             d8  when "1000",
             d9  when "1001",
             d10 when "1010",
             d11 when "1011",
             d12 when "1100",
             d13 when "1101",
             d14 when "1110",
             d15 when "1111",
             "00000000" when others;
end architecture comportamento;
