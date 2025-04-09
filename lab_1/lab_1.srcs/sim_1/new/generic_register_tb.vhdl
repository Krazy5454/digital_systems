
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity generic_register_tb is
end generic_register_tb;
    
architecture Behavioral of generic_register_tb is
    constant bits : natural := 8;
    signal clk, enable : std_logic := '1';
    signal reset : std_logic := '0';
    signal d, q : std_logic_vector ( bits-1 downto 0 ) := "10000000";
    
begin
    
uut : entity work.generic_register ( Behavioral )
    generic map ( bits => bits )
    port map (
        clk => clk,
        reset => reset,
        enable => enable,
        d => d,
        q => q);

clk <= not clk after 5 ns;
reset <= '1' after 20 ns, '0' after 30 ns, '1' after 60 ns, '0' after 70 ns;
enable <= '1' after 50ns, '0' after 60ns, '1' after 90 ns, '0' after 100 ns, '1' after 130 ns, '0' after 140 ns;
d <= "10110010" after 40 ns, "11111111" after 80 ns, "00000001" after 120 ns;


end Behavioral;
