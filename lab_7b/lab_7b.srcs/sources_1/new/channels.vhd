library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity channels is
    Port ( 
        clk, reset, wen : in std_logic;
        w_addr, r_addr : in std_logic_vector ( 3 downto 0 );
        d : in std_logic_vector ( 31 downto 0 );
        q : out std_logic_vector ( 31 downto 0 );
        output, output_enabled, interrupt : out std_logic
        );
end channels;

architecture Behavioral of channels is
    signal div_clk_vector : std_logic_vector ( 15 downto 0 );
    signal div_reset, base_reset, reset_div, reset_base, compared : std_logic;
    signal base_clk : std_logic := '1';
    signal compare_val : std_logic_vector (15 downto 0 );
    signal OE, IO, SLFM, PDMM, IE, RF, FF, FE, IA : std_logic;
    signal FIL : std_logic_vector ( 4 downto 0 );
    signal CDR, BCR, DCR : std_logic_vector (15 downto 0 );
    
begin

PM_registers : entity work.PM_regs ( Behavioral )
    port map ( clk => clk, reset => reset, wen => wen, w_addr => w_addr, r_addr => r_addr, d => d, base_reset => base_reset, div_reset => div_reset,
               q => q, OE => OE, IO => IO, SLFM => SLFM, PDMM => PDMM, IE => IE, RF => RF, 
               FF => FF, FE => FE, IA => IA, FIL => FIL,
               CDR => CDR, BCR => BCR, DCR => DCR );

div_reset <= '1' when div_clk_vector = CDR else '0';
reset_div <= div_reset or reset;
modulo_clock_div : entity work.generic_counter ( Behavioral )
    generic map ( bits => 16 )
    port map ( clk => clk, reset => reset_div, q => div_clk_vector );
     
--base counter
base_reset <= '1' when compare_val = BCR else '0';
reset_base <= base_reset or reset;
base_clk <= clk when CDR = x"0000" else div_reset when rising_edge(clk); 
base_counter : entity work.generic_counter ( Behavioral )
    generic map ( bits => 16 )
    port map ( clk => base_clk, reset => reset_base, q => compare_val ); 


 
--outputs
compared <= '1' when DCR > compare_val else '0';
output <= not IO when (compared and OE) = '1' else IO;
output_enabled <= OE;
interrupt <= IE and IA;

end Behavioral;
