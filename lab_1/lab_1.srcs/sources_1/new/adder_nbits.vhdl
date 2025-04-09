library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity adder_nbits is
    generic ( bits : integer := 4 );
    Port ( a : in STD_LOGIC_VECTOR (bits-1 downto 0);
           b : in STD_LOGIC_VECTOR (bits-1 downto 0);
           add_sub : in STD_LOGIC;
           r : out STD_LOGIC_VECTOR (bits-1 downto 0);
           carry_out : out STD_LOGIC;
           overflow : out STD_LOGIC);
end adder_nbits;

architecture Behavioral of adder_nbits is
    signal bxor : std_logic_vector ( bits-1 downto 0 );
    signal add_sub_vector : std_logic_vector ( bits - 1 downto 0 );
    
    signal r4_0 : std_logic_vector ( bits downto 0 );
    
    signal b5 : std_logic_vector ( 2 downto 0 );
    signal a5 : std_logic_vector ( 2 downto 0 );
    signal r5 : std_logic_vector (2 downto 0);
    
begin

add_sub_vector <= ( others => add_sub );
bxor <= b xor add_sub_vector;

r4_0 <= std_logic_vector ( unsigned( '0' & bxor(bits-2 downto 0) & add_sub ) +  unsigned ( '0' & a(bits-2 downto 0) & add_sub ) );

b5 <= '0' & bxor(bits-1) & r4_0(bits);
a5 <= '0' & a(bits-1) & r4_0(bits);
r5 <= std_logic_vector ( unsigned( b5 ) +  unsigned ( a5 ) );

r <= r5(1) & r4_0(bits-1 downto 1);
carry_out <= r5(2);
overflow <= r5(2) xor r4_0(bits);

end Behavioral;
