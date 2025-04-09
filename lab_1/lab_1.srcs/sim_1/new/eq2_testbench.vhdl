library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity eq2_testbench is
end eq2_testbench;

architecture Behavioral of eq2_testbench is
    signal a,b : std_logic_vector ( 1 downto 0 ) := "00";
    signal eq : std_logic;
begin

uut: entity  work.eq2 (structural)
    port map(
        a => A,
        b => B,
        eq => eq);

a(0) <= not a(0) after 10ns;
a(1) <= not a(1) after 20ns;
b(0) <= not b(0) after 40ns;
b(1) <= not b(1) after 80ns;

end Behavioral;
