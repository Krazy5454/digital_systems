library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity generic_register is
    generic (bits: integer := 8);
    port(
        clk, reset,enable: in std_logic;
        d: in std_logic_vector ( bits-1 downto 0 );
        q: out std_logic_vector ( bits-1 downto 0 )
        );
end generic_register; 

architecture Behavioral of generic_register is
    signal q_i, next_q_i : std_logic_vector ( bits-1 downto 0 );
    signal ctrl : std_logic_vector ( 1 downto 0 );
begin
    q_i <= next_q_i when rising_edge(clk);
    
    ctrl <= reset & enable;
    with ctrl select next_q_i <=
        d when "01",
        q_i when "00",
        (others => '0') when others;
end Behavioral;
