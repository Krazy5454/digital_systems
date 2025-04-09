
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


entity generic_counter is
    generic ( bits : integer := 4 );
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           q : out STD_LOGIC_VECTOR ( bits-1 downto 0 ));
end generic_counter;

architecture Behavioral of generic_counter is
    signal current_count : std_logic_vector ( bits-1 downto 0 ) := ( others => '0' );
    signal next_count : std_logic_vector ( bits-1 downto 0 ) := ( others => '0' );
begin
    --declare memory
    current_count <= next_count when rising_edge( clk );
    --next state logic
    next_count <= (others => '0') when reset = '1' else
        std_logic_vector ( unsigned ( current_count ) + 1 );
    --output logic
    q <= current_count;

end Behavioral;
