library IEEE;  
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity PWM_Array_Driver_tb is
end PWM_Array_Driver_tb;
    
architecture Behavioral of PWM_Array_Driver_tb is
    signal clk, wen, reset : std_logic := '1';
    signal adr : std_logic_vector ( 0 downto 0 );
    signal d : std_logic_vector ( 31 downto 0 );
    signal leds : std_logic_vector (15 downto 0 );
begin

uut: entity work.PWM_Array_Driver ( two_by_32 )
    port map ( 
        clk => clk,
        wen => wen,
        reset => reset,
        adr => adr,
        d => d,
        leds => leds);
             
clk <= not clk after 5 ns;   
reset <= '0' after 20 ns, '1' after 500000 ns, '0' after 500030 ns;
wen <= '0' after 60 ns;

process
begin
    wait for 20 ns;
    d <= "01110110010101000011001000010000";
    adr <= "0";
    wait for 10 ns;
    d <= "11111110110111001011101010011000";
    adr <= "1";
    wait;
end process; 
                
end Behavioral;
