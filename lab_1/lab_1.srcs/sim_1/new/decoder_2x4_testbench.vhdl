library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity decoder_2x4_testbench is
end decoder_2x4_testbench;

architecture Behavioral of decoder_2x4_testbench is
  signal Y : std_logic_vector ( 3 downto 0 ) := "0000";
  signal A : std_logic_vector ( 1 downto 0 ) := "00";
  signal EN : std_logic := '0';
  
begin

uut: entity work.decoder_2x4 (decoder)
    port map(
        y => Y,
        a => A,
        en => EN
        );

a(0) <= not a(0) after 10ns;
a(1) <= not a(1) after 20ns;
en <= not en after 40ns;


end Behavioral;
