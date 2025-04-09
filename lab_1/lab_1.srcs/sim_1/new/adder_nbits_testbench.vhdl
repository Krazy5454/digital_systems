library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
--use IEEE.math_real.ALL;

entity adder_nbits_testbench is
end adder_nbits_testbench;

architecture Behavioral of adder_nbits_testbench is
    constant bits : integer := 8;
    signal a : std_logic_vector ( bits-1 downto 0 ) := ( others => '0' );
    signal b : std_logic_vector ( bits-1  downto 0 ) := ( others => '0' );
    signal add_sub : std_logic := '0'; --0 = add, 1 = sub
    signal r : std_logic_vector ( bits-1 downto 0 ) := ( others => '0' );
    signal carry_out : std_logic := '0';
    signal overflow : std_logic := '0';
    
begin

uut : entity work.adder_nbits ( Behavioral )
    generic map ( bits => bits )
    port map (
        a => a,
        b => b,
        add_sub => add_sub,
        r => r,
        carry_out => carry_out,
        overflow => overflow);
        
a <= std_logic_vector (unsigned ( a ) + 1 ) after 10 ns; 
b <= std_logic_vector (unsigned ( b ) + 1 ) after 2560 ns; -- 10 * ( 2**bits )
add_sub <= not add_sub after 655360 ns; -- 10 * ( 2**(2*bits) )


end Behavioral;
