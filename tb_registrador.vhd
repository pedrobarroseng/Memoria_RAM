library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Testbench do Registrador_8bits (que usa 8 FFs D "ffd")
-- Confere: clear, escrita com enable, retencao sem enable,
-- escrita somente na borda de subida e clear assincrono.

entity tb_registrador is
end entity tb_registrador;

architecture sim of tb_registrador is

    signal clk, enable, clear : std_logic := '0';
    signal d, q : std_logic_vector(7 downto 0) := (others => '0');

    constant T_CLK : time := 10 ns;
    signal fim : boolean := false;

begin

    dut : entity work.Registrador_8bits
        port map(clk => clk, enable => enable, clear => clear, d => d, q => q);

    clk_proc : process
    begin
        while not fim loop
            clk <= '0'; wait for T_CLK / 2;
            clk <= '1'; wait for T_CLK / 2;
        end loop;
        wait;
    end process clk_proc;

    estimulo : process

        variable erros : integer := 0;

        procedure confere(esperado : in integer; msg : in string) is
        begin
            if q /= std_logic_vector(to_unsigned(esperado, 8)) then
                erros := erros + 1;
                report "ERRO (" & msg & "): esperado=" & integer'image(esperado) &
                       " obtido=" & integer'image(to_integer(unsigned(q)))
                       severity error;
            end if;
        end procedure;

    begin

        wait for 2 ns;

        report "1) clear zera o registrador";
        clear <= '1'; wait for 2 ns;
        confere(0, "clear inicial");
        clear <= '0'; wait for 2 ns;

        report "2) escrita com enable = 1 na borda de subida";
        wait until falling_edge(clk);
        d <= x"A5"; enable <= '1';
        wait until rising_edge(clk); wait for 2 ns;
        confere(16#A5#, "escrita A5");

        report "3) enable = 0 nao altera";
        wait until falling_edge(clk);
        d <= x"5A"; enable <= '0';
        wait until rising_edge(clk); wait for 2 ns;
        confere(16#A5#, "enable=0 retem A5");

        report "4) escrita so na borda: mudar d com enable=1 sem clock";
        wait until falling_edge(clk);
        enable <= '1'; d <= x"3C";
        wait for 1 ns;
        confere(16#A5#, "antes da borda ainda A5");
        wait until rising_edge(clk); wait for 2 ns;
        confere(16#3C#, "apos a borda vale 3C");
        enable <= '0';

        report "5) retencao por varios ciclos";
        d <= x"FF";
        wait for 5 * T_CLK;
        confere(16#3C#, "retencao 3C");

        report "6) clear assincrono (sem borda de clock)";
        wait until falling_edge(clk);
        clear <= '1'; wait for 1 ns;
        confere(0, "clear assincrono");
        clear <= '0';

        report "7) volta a escrever apos o clear";
        wait until falling_edge(clk);
        d <= x"81"; enable <= '1';
        wait until rising_edge(clk); wait for 2 ns;
        confere(16#81#, "escrita apos clear");
        enable <= '0';

        if erros = 0 then
            report "REGISTRADOR: TODOS OS TESTES PASSARAM" severity note;
        else
            report "REGISTRADOR: " & integer'image(erros) & " erro(s)" severity error;
        end if;

        fim <= true;
        wait;

    end process estimulo;

end architecture sim;
