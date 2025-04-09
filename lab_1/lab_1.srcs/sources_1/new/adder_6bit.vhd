library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity adder_6bit is
    Port ( a : in STD_LOGIC_VECTOR (5 downto 0);
           b : in STD_LOGIC_VECTOR (5 downto 0);
           add_sub : in STD_LOGIC;
           r : out STD_LOGIC_VECTOR (5 downto 0);
           carry_out : out STD_LOGIC;
           overflow : out STD_LOGIC);
end adder_6bit;

architecture Behavioral of adder_6bit is
    signal bxor : std_logic_vector ( 5 downto 0 );
    
    signal r4_0 : std_logic_vector ( 6 downto 0 );
    
    signal b5 : std_logic_vector ( 2 downto 0 );
    signal a5 : std_logic_vector ( 2 downto 0 );
    signal r5 : std_logic_vector (2 downto 0);
    
begin

bxor <= b xor ( add_sub & add_sub & add_sub & add_sub & add_sub & add_sub );

r4_0 <= std_logic_vector ( unsigned( '0' & bxor(4 downto 0) & add_sub ) +  unsigned ( '0' & a(4 downto 0) & add_sub ) );

b5 <= '0' & bxor(5) & r4_0(6);
a5 <= '0' & a(5) & r4_0(6);
r5 <= std_logic_vector ( unsigned( b5 ) +  unsigned ( a5 ) );

r <= r5(1) & r4_0(5 downto 1);
carry_out <= r5(2);
overflow <= r5(2) xor r4_0(6);

end Behavioral;
