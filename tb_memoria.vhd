library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Testbench da memoria RAM 16 x 8
-- Cobre: escrita, leitura, leitura assincrona, enable=0, clear, retencao

entity tb_memoria is
end entity tb_memoria;

architecture sim of tb_memoria is

    signal clk    : std_logic := '0';
    signal clear  : std_logic := '0';
    signal enable : std_logic := '0';
    signal addr   : std_logic_vector(3 downto 0) := (others => '0');
    signal D_in   : std_logic_vector(7 downto 0) := (others => '0');
    signal D_out  : std_logic_vector(7 downto 0);

    constant T_CLK : time := 10 ns;
    signal fim : boolean := false;

begin

    dut : entity work.memoria
        port map(
            clk    => clk,
            clear  => clear,
            enable => enable,
            addr   => addr,
            D_in   => D_in,
            D_out  => D_out
        );

    clk_proc : process
    begin
        while not fim loop
            clk <= '0';
            wait for T_CLK / 2;
            clk <= '1';
            wait for T_CLK / 2;
        end loop;
        wait;
    end process clk_proc;

    estimulo : process

        variable erros : integer := 0;

        function valor(a : integer) return integer is
        begin
            return 13 * a + 7;
        end function;

        procedure escrever(a : in integer; v : in integer; en : in std_logic) is
        begin
            wait until falling_edge(clk);
            addr   <= std_logic_vector(to_unsigned(a, 4));
            D_in   <= std_logic_vector(to_unsigned(v, 8));
            enable <= en;
            wait until rising_edge(clk);
            wait for 2 ns;
            enable <= '0';
        end procedure;

        procedure ler(a : in integer; esperado : in integer; msg : in string) is
        begin
            addr <= std_logic_vector(to_unsigned(a, 4));
            wait for 1 ns;
            if D_out /= std_logic_vector(to_unsigned(esperado, 8)) then
                erros := erros + 1;
                report "ERRO (" & msg & "): addr=" & integer'image(a) &
                       " esperado=" & integer'image(esperado) &
                       " obtido=" & integer'image(to_integer(unsigned(D_out)))
                       severity error;
            end if;
        end procedure;

    begin

        wait for 2 ns;

        report "Teste inicial: clear zera a memoria";
        clear <= '1';
        wait for 2 ns;
        for a in 0 to 15 loop
            ler(a, 0, "clear inicial");
        end loop;
        clear <= '0';
        wait for 2 ns;

        report "Teste 1: escrita em todos os enderecos";
        for a in 0 to 15 loop
            escrever(a, valor(a), '1');
        end loop;

        report "Teste 2/3: leitura e leitura assincrona";
        for a in 0 to 15 loop
            ler(a, valor(a), "leitura");
        end loop;
        for a in 15 downto 0 loop
            ler(a, valor(a), "leitura assincrona (ordem inversa)");
        end loop;

        report "Teste 4: escrita com enable = 0 nao altera";
        escrever(3, 200, '0');
        escrever(9, 201, '0');
        ler(3, valor(3), "enable=0 em 3");
        ler(9, valor(9), "enable=0 em 9");

        report "Teste 6: retencao sem escrita";
        D_in <= "11111111";
        wait for 10 * T_CLK;
        D_in <= "10101010";
        wait for 10 * T_CLK;
        for a in 0 to 15 loop
            ler(a, valor(a), "retencao");
        end loop;

        report "Escrita seletiva: so o endereco 5 muda";
        escrever(5, 99, '1');
        for a in 0 to 15 loop
            if a = 5 then
                ler(a, 99, "sobrescrita");
            else
                ler(a, valor(a), "vizinhos intactos");
            end if;
        end loop;

        report "Teste 5: clear limpa a memoria";
        clear <= '1';
        wait for 2 ns;
        for a in 0 to 15 loop
            ler(a, 0, "clear");
        end loop;
        clear <= '0';
        wait for 2 ns;

        escrever(7, 55, '1');
        ler(7, 55, "escrita apos clear");
        ler(6, 0, "posicao vizinha continua zerada");

        if erros = 0 then
            report "TODOS OS TESTES PASSARAM" severity note;
        else
            report "FALHAS: " & integer'image(erros) & " erro(s)" severity error;
        end if;

        fim <= true;
        wait;

    end process estimulo;

end architecture sim;
