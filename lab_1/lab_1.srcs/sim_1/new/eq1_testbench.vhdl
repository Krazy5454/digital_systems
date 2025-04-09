library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity eq1_testbench is
end eq1_testbench;

architecture Behavioral of eq1_testbench is
  signal input1, input2 : std_logic := '0';
  signal output : std_logic;
begin

uut: entity work.eq1 (Behavioral)
    port map(
    eq => output,
    i0 => input1,
    i1 => input2);
   
input1 <= not input1 after 10ns;
input2 <= not input2 after 20ns;

end Behavioral;
