library ieee;
use ieee.std_logic_1164.all;

-- Top-level da memoria RAM 16 x 8 para a placa DE0-Nano
--
--   KEY0      : clock manual (borda de subida ao apertar, com antirruido)
--   KEY1      : clear (enquanto apertado)
--   SW[3:0]   : endereco (addr)
--   DADO_N    : dado de entrada (8 bits), pinos GPIO_1; ligado ao GND = '1'
--   EN_N      : enable de escrita, pino GPIO_1; ligado ao GND = enable ligado
--   LED[7:0]  : D_out (dado lido do endereco selecionado)
--
-- Os pinos GPIO usam pull-up fraco: sem fio ligado = '0' (dado 0, enable desligado).

entity top_memoria is
    generic (
        DEB_CICLOS     : positive := 500000;  -- 10 ms com clock de 50 MHz
        LED_ATIVO_ALTO : boolean  := true
    );
    port(
        CLOCK_50 : in  std_logic;
        KEY      : in  std_logic_vector(1 downto 0);
        SW       : in  std_logic_vector(3 downto 0);
        DADO_N   : in  std_logic_vector(7 downto 0);
        EN_N     : in  std_logic;
        LED      : out std_logic_vector(7 downto 0)
    );
end entity top_memoria;

architecture estrutura of top_memoria is

    signal btn_clk, btn_clear : std_logic;   -- botoes, ativos em '1'
    signal clk_manual         : std_logic;   -- clock manual limpo
    signal clear_s            : std_logic;
    signal enable_s           : std_logic;
    signal dado_s, d_out      : std_logic_vector(7 downto 0);

begin

    -- Os botoes da placa sao ativos em baixo
    btn_clk   <= not KEY(0);
    btn_clear <= not KEY(1);

    -- Entradas externas: ligado ao GND = '1'
    dado_s   <= not DADO_N;
    enable_s <= not EN_N;

    db_clk : entity work.debounce
        generic map(CICLOS => DEB_CICLOS)
        port map(clk => CLOCK_50, entrada => btn_clk, saida => clk_manual);

    db_clear : entity work.debounce
        generic map(CICLOS => DEB_CICLOS)
        port map(clk => CLOCK_50, entrada => btn_clear, saida => clear_s);

    mem : entity work.memoria
        port map(
            clk    => clk_manual,
            clear  => clear_s,
            enable => enable_s,
            addr   => SW,
            D_in   => dado_s,
            D_out  => d_out
        );

    LED <= d_out when LED_ATIVO_ALTO else not d_out;

end architecture estrutura;
