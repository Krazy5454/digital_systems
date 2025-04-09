library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity adder_6bit_tb is
end adder_6bit_tb;

architecture Behavioral of adder_6bit_tb is
    signal a : std_logic_vector ( 5 downto 0 ) := "000000";
    signal b : std_logic_vector ( 5 downto 0 ) := "000000";
    signal add_sub : std_logic := '0'; --0 = add, 1 = sub
    signal r : std_logic_vector ( 5 downto 0 ) := "000000";
    signal carry_out : std_logic := '0';
    signal overflow : std_logic := '0';
    
begin

uut : entity work.adder_6bit ( Behavioral )
    port map (
        a => a,
        b => b,
        add_sub => add_sub,
        r => r,
        carry_out => carry_out,
        overflow => overflow);
        
a <= std_logic_vector (unsigned ( a ) + 1 ) after 10 ns;
b <= std_logic_vector (unsigned ( b ) + 1 ) after 640 ns;
add_sub <= not add_sub after 40960 ns;


end Behavioral;
