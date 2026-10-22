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

    component decodificador
        port(
            addr : in  std_logic_vector(3 downto 0);
            sel  : out std_logic_vector(15 downto 0)
        );
    end component;

    component mux16x1
        port(
            e0, e1, e2, e3, e4, e5, e6, e7,
            e8, e9, e10, e11, e12, e13, e14, e15 : in std_logic_vector(7 downto 0);
            addr  : in  std_logic_vector(3 downto 0);
            saida : out std_logic_vector(7 downto 0)
        );
    end component;

    component Registrador_8bits
        port(
            clk, enable, clear : in std_logic;
            d : in std_logic_vector(7 downto 0);
            q : out std_logic_vector(7 downto 0)
        );
    end component;
    
    type t_gavetas is array (0 to 15) of std_logic_vector(7 downto 0);
    signal gavetas : t_gavetas;
    signal sel     : std_logic_vector(15 downto 0);
    signal we      : std_logic_vector(15 downto 0);

begin

        -- Decodificador: addr entra, sel sai
    DEC: decodificador port map (addr => addr, sel => sel);

    -- as 16 gavetas
    GERA_GAVETAS: for i in 0 to 15 generate
        we(i) <= sel(i) and enable;          

        GAV: Registrador_8bits port map (
            clk    => clk,
            clear  => clear,
            enable => we(i),                  
            d      => D_in,                  
            q      => gavetas(i)                   
        );
    end generate;

    -- mux: as 16 gavetas entram, a escolhida sai em D_out
    MUX: mux16x1 port map (
        e0 => gavetas(0), e1 => gavetas(1), e2 => gavetas(2), e3 => gavetas(3),
        e4 => gavetas(4), e5 => gavetas(5), e6 => gavetas(6), e7 => gavetas(7),
        e8 => gavetas(8), e9 => gavetas(9), e10 => gavetas(10), e11 => gavetas(11),
        e12 => gavetas(12), e13 => gavetas(13), e14 => gavetas(14), e15 => gavetas(15),
        addr  => addr,
        saida => D_out
    );

end comportamento;