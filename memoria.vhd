library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Memoria RAM 16 x 8 bits
--   Escrita : sincrona (borda de subida de clk), quando enable = '1'
--   Leitura : assincrona (D_out segue addr, sem depender do clock)
--   Clear   : limpa todas as 16 posicoes (ativo em '1')

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

    component decodificador_4x16
        port(
            addr : in  std_logic_vector(3 downto 0);
            sel  : out std_logic_vector(15 downto 0)
        );
    end component;

    component Registrador_8bits
        port(
            clk, enable, clear : in std_logic;
            d : in  std_logic_vector(7 downto 0);
            q : out std_logic_vector(7 downto 0)
        );
    end component;

    component mux16x8
        port(
            d0, d1, d2, d3, d4, d5, d6, d7     : in  std_logic_vector(7 downto 0);
            d8, d9, d10, d11, d12, d13, d14, d15 : in  std_logic_vector(7 downto 0);
            addr : in  std_logic_vector(3 downto 0);
            y    : out std_logic_vector(7 downto 0)
        );
    end component;

    type t_dados is array (0 to 15) of std_logic_vector(7 downto 0);

    signal sel       : std_logic_vector(15 downto 0);  -- saida do decodificador
    signal en_reg    : std_logic_vector(15 downto 0);  -- enable de escrita de cada registrador
    signal dados_reg : t_dados;                        -- conteudo de cada registrador

begin

    dec : decodificador_4x16
        port map(
            addr => addr,
            sel  => sel
        );

    gera_regs : for i in 0 to 15 generate
        en_reg(i) <= sel(i) and enable;

        reg_inst : Registrador_8bits
            port map(
                clk    => clk,
                enable => en_reg(i),
                clear  => clear,
                d      => D_in,
                q      => dados_reg(i)
            );
    end generate gera_regs;

    mux : mux16x8
        port map(
            d0  => dados_reg(0),  d1  => dados_reg(1),
            d2  => dados_reg(2),  d3  => dados_reg(3),
            d4  => dados_reg(4),  d5  => dados_reg(5),
            d6  => dados_reg(6),  d7  => dados_reg(7),
            d8  => dados_reg(8),  d9  => dados_reg(9),
            d10 => dados_reg(10), d11 => dados_reg(11),
            d12 => dados_reg(12), d13 => dados_reg(13),
            d14 => dados_reg(14), d15 => dados_reg(15),
            addr => addr,
            y    => D_out
        );

end comportamento;
