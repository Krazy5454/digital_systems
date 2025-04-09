library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity eq2 is
    Port ( A : in STD_LOGIC_VECTOR (1 downto 0);
           B : in STD_LOGIC_VECTOR (1 downto 0);
           eq : out STD_LOGIC);
end eq2;

architecture Behavioral of eq2 is
    signal p1, p2, p3, p4 : std_logic;
begin
    eq <= p1 or p2 or p3 or p4;
    
    p1 <= (not A(0)) and  (not A(1)) and (not B(0)) and (not B(1));
    p2 <= A(0) and  (not A(1)) and B(0) and (not B(1));
    p3 <= (not A(0)) and  A(1) and (not B(0)) and B(1);
    p4 <= A(0) and  A(1) and B(0) and B(1);

end Behavioral;


architecture structural of eq2 is
    signal p1, p2, p3, p4 : std_logic;
begin
    

end structural;
