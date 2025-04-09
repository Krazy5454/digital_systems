library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.ALL;


entity generic_shifter_tb is
end generic_shifter_tb;

architecture Behavioral of generic_shifter_tb is
    constant shift_bits : natural := 2; 
    constant delay1 : natural := 2**((2**shift_bits)) * 10;
    constant delay2 : natural := 2**((2**shift_bits)+shift_bits) * 10;
    signal din : STD_LOGIC_VECTOR ((2**shift_bits)-1 downto 0) := (others => '0');
    signal dout : STD_LOGIC_VECTOR ((2**shift_bits)-1 downto 0) := (others => '0');
    signal shamt : STD_LOGIC_VECTOR (shift_bits-1 downto 0) := (others => '0');
    signal func : std_logic_vector (1 downto 0) := (others => '0');
    signal co : STD_LOGIC := '0';
        
begin

uut : entity work.generic_shifter ( Behavioral )
    generic map ( shift_bits => shift_bits)
    port map (
        din => din,
        dout => dout,
        shamt => shamt,
        func => func,
        co => co);
             
din <= std_logic_vector( unsigned ( din ) + 1 ) after 10 ns;
shamt <= std_logic_vector( unsigned ( shamt ) + 1 ) after delay1 * 1 ns; 
func <= std_logic_vector( unsigned ( func ) + 1 ) after delay2 * 1 ns; 

end Behavioral;
 