library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity channels is
    Port ( 
        clk, reset, wen : in std_logic;
        w_addr, r_addr : in std_logic_vector ( 3 downto 0 );
        d : in std_logic_vector ( 31 downto 0 );
        q : out std_logic_vector ( 31 downto 0 );
        output, output_enabled : out std_logic
        );
end channels;

architecture Behavioral of channels is
    signal div_clk_vector : std_logic_vector ( 15 downto 0 );
    signal div_clk, base_reset, base_clk, compared : std_logic;
    signal compare_val : std_logic_vector (15 downto 0 );
    signal OE, IO, SLFM, PDMM, IE, RF, FF, FE, IA : std_logic;
    signal FIL : std_logic_vector ( 4 downto 0 );
    signal CDR, BCR, DCR : std_logic_vector (15 downto 0 );
    
begin

PM_registers : entity work.PM_regs ( Behavioral )
    port map ( clk => clk, reset => reset, wen => wen, w_addr => w_addr, r_addr => r_addr, d => d, 
               FF_in => '0', FE_in => '0', IA_in => '0',
               q => q, OE => OE, IO => IO, SLFM => SLFM, PDMM => PDMM, IE => IE, RF => RF, 
               FF => FF, FE => FE, IA => IA, FIL => FIL,
               CDR => CDR, BCR => BCR, DCR => DCR );

modulo_clock_div : entity work.generic_counter ( Behavioral )
    generic map ( bits => 16 )
    port map ( clk => clk, reset => div_clk or reset, q => div_clk_vector );

div_clk <= '1' when div_clk_vector = CDR else '0';
     
--base counter
base_clk <= clk and div_clk;
base_counter : entity work.generic_counter ( Behavioral )
    generic map ( bits => 16 )
    port map ( clk => base_clk, reset => base_reset or reset, q => compare_val ); 

base_reset <= '1' when compare_val = BCR else '0';

compared <= '1' when DCR > compare_val else '0';
output <= not IO when (compared and OE) = '1' else IO;
output_enabled <= OE;

end Behavioral;
