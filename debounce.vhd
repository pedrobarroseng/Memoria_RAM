library ieee;
use ieee.std_logic_1164.all;

-- Antirruido (debounce) para botoes: sincroniza a entrada no clock da placa
-- e so muda a saida depois que a entrada ficou estavel por CICLOS ciclos.
-- Padrao: 500000 ciclos a 50 MHz = 10 ms.

entity debounce is
    generic (
        CICLOS : positive := 500000
    );
    port(
        clk     : in  std_logic;
        entrada : in  std_logic;
        saida   : out std_logic
    );
end entity debounce;

architecture comportamento of debounce is

    signal s1, s2  : std_logic := '0';   -- sincronizador de 2 FFs
    signal estavel : std_logic := '0';
    signal cont    : natural range 0 to CICLOS := 0;

begin

    process(clk)
    begin
        if rising_edge(clk) then
            s1 <= entrada;
            s2 <= s1;

            if s2 = estavel then
                cont <= 0;
            elsif cont = CICLOS - 1 then
                estavel <= s2;
                cont    <= 0;
            else
                cont <= cont + 1;
            end if;
        end if;
    end process;

    saida <= estavel;

end architecture comportamento;
