library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity generic_register_file_tb is
end generic_register_file_tb;
    
architecture Behavioral of generic_register_file_tb is
    constant word_len : natural := 8;
    constant addr_bits : natural := 2;
    signal reset, write_en: std_logic := '0';
    signal clk : std_logic := '1';
    signal d_addr: std_logic_vector ( addr_bits-1 downto 0 ) := "00";
    signal d_in: std_logic_vector ( word_len-1 downto 0 ) := "00000001";
    signal a_addr: std_logic_vector ( addr_bits-1 downto 0 ) := "00";
    signal a_out : std_logic_vector ( word_len-1 downto 0 ) := "00000000";
    signal b_addr: std_logic_vector ( addr_bits-1 downto 0 ):= "00";
    signal b_out : std_logic_vector ( word_len-1 downto 0 ) := "00000000";
    
begin
    
uut : entity work.generic_register_file ( Behavioral )
    generic map ( 
        word_len => word_len,
        addr_bits => addr_bits )
    port map (
        clk => clk,
        reset => reset,
        write_en => write_en,
        d_addr => d_addr,
        d_in => d_in,
        a_addr => a_addr,
        a_out => a_out,
        b_addr => b_addr,
        b_out => b_out
        );

clk <= not clk after 5 ns;
d_in <= "00000010" after 25 ns, "00000011" after 55 ns, "00000100" after 65 ns;
d_addr <= "01" after 35 ns, "10" after 65 ns, "01" after 115 ns;
a_addr <= "01" after 35 ns, "10" after 85 ns, "01" after 105 ns;
write_en <= '1' after 45 ns, '0' after 65 ns, '1' after 75 ns, '0' after 125 ns;
b_addr <= "10" after 75 ns, "01" after 105 ns;
reset <= '1' after 95 ns, '0' after 105 ns, '1' after 135 ns, '0' after 145 ns;

end Behavioral;
