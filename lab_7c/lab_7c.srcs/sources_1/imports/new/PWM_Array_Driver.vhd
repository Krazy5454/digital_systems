library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.mi_package.all; 

entity PWM_Array_Driver is
    Port ( 
    clk, wen, reset : in std_logic;
    adr : in std_logic_vector (0 downto 0 ); --( 2 downto 0 );
    d : in std_logic_vector (31 downto 0 ); --( 7 downto 0 );
    leds : out std_logic_vector (15 downto 0 )
    );
end PWM_Array_Driver;

architecture eight_by_8 of PWM_Array_Driver is
    type signal_array is array ( 7 downto 0 ) of std_logic_vector ( 7 downto 0 );
    signal array_reg: signal_array;
    signal decoded : std_logic_vector ( 7 downto 0 );
    signal div_clk_vector : std_logic_vector ( 10 downto 0 );
    signal div_clk, mod_reset : std_logic;
    signal compare : std_logic_vector (3 downto 0 );
begin
    --clock divider
    clock_div : entity work.generic_counter ( Behavioral ) 
        generic map ( bits => 11 )
        port map ( clk => clk, reset => reset, q => div_clk_vector );
     div_clk <= div_clk_vector(10);
     
    --modulo counter
    mod_counter : entity work.generic_counter ( Behavioral )
        generic map ( bits => 4 )
        port map ( clk => div_clk, reset => mod_reset, q => compare );
    mod_reset <= '1' when compare = "1110" else '0';
        
    --registers
    decoded <= decode ( adr, wen );

    reg_files: for i in 0 to 7 generate
        reg_filesi: entity work.generic_register ( Behavioral )
        generic map ( bits => 8 )
        port map ( clk => clk, reset => reset, enable => decoded(i),
                   d => d, q => array_reg(i) );
    end generate reg_files;
    
    --comparing
    leds_loop : for i in 0 to 15 generate
        leds(i) <= '1' when array_reg(i/2)(3 + 4 * (i mod 2) downto 4 * (i mod 2) ) > compare
            else '0';
    end generate leds_loop;

end eight_by_8;

architecture two_by_32 of PWM_Array_Driver is
    type signal_array is array ( 1 downto 0 ) of std_logic_vector ( 31 downto 0 );
    signal array_reg: signal_array;
    signal decoded : std_logic_vector ( 1 downto 0 );
    signal div_clk_vector : std_logic_vector ( 10 downto 0 );
    signal div_clk, mod_reset : std_logic;
    signal compare : std_logic_vector (3 downto 0 );
begin
    --clock divider
    clock_div : entity work.generic_counter ( Behavioral )
        generic map ( bits => 11 )
        port map ( clk => clk, reset => reset, q => div_clk_vector );
     div_clk <= div_clk_vector(10);
     
    --modulo counter
    mod_counter : entity work.generic_counter ( Behavioral )
        generic map ( bits => 4 )
        port map ( clk => div_clk, reset => mod_reset, q => compare );
    mod_reset <= '1' when compare = "1110" else '0';
        
    --registers
    decoded <= decode ( adr, wen );

    reg_files: for i in 0 to 1 generate
        reg_filesi: entity work.generic_register ( Behavioral )
        generic map ( bits => 32 )
        port map ( clk => clk, reset => reset, enable => decoded(i),
                   d => d, q => array_reg(i) );
    end generate reg_files;
    
    --comparing
    leds_loop : for i in 0 to 15 generate
        leds(i) <= '1' when array_reg(i/8)(3 + 4 * (i mod 8) downto 4 * (i mod 8) ) > compare
            else '0';
    end generate leds_loop;

end two_by_32;
