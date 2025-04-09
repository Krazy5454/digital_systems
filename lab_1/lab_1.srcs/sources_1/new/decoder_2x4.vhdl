library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder_2x4 is
    Port ( en : in STD_LOGIC;
           a : in STD_LOGIC_VECTOR (1 downto 0);
           y : out STD_LOGIC_VECTOR (3 downto 0));
end decoder_2x4;

architecture decoder of decoder_2x4 is
   
begin
    y(0) <= ( en and ( not a(1) and not a(0)));
    y(1) <= ( en and ( not a(1) and a(0)));
    y(2) <= ( en and ( a(1) and not a(0)));
    y(3) <= ( en and ( a(1) and a(0)));

end decoder;
