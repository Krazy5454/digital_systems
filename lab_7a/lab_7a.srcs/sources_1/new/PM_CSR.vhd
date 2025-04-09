
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity PM_CSR is
    Port ( clk ,reset, wen : in std_logic;
           d : in STD_LOGIC_VECTOR (31 downto 0);
           FF_in, FE_in, IA_in : in STD_LOGIC;
           q: out std_logic_vector (31 downto 0); 
           OE, IO, SLFM, PDMM, IE, RF, FF, FE, IA : out STD_LOGIC;
           FIL : out std_logic_vector (4 downto 0)
           );
end PM_CSR;

architecture Behavioral of PM_CSR is
    signal master_enable : std_logic;
    signal q_oe : std_logic_vector (0 downto 0);
    signal q_rw : std_logic_vector (3 downto 0);
    signal q_fil : std_logic_vector (4 downto 0);
    
begin
    master_enable <= wen and not q_oe(0);
    --output enable register
    oe_reg: entity work.generic_register ( Behavioral )
    generic map ( bits => 1 )
    port map ( clk => clk, reset => reset, enable => wen,
               d => d(0 downto 0), q => q_oe );
    
    --regular read/write data register      
    rw_reg: entity work.generic_register ( Behavioral )
    generic map ( bits => 4 )
    port map ( clk => clk, reset => reset, enable => master_enable,
               d => d(4 downto 1), q => q_rw );
    
    --fifo interupt level
    fil_reg: entity work.generic_register ( Behavioral )
    generic map ( bits => 5 )
    port map ( clk => clk, reset => reset, enable => master_enable,
               d => d(31 downto 27), q => q_fil );

    --map outputs
    q <= q_fil & "0000000000000000" & IA_in & FE_in & FF_in & "000" & q_rw & q_oe;
    OE <= q_oe(0);
    IO <= q_rw(0);
    SLFM <= q_rw(1);
    PDMM <= q_rw(2);
    IE <= q_rw(3);
    RF <= master_enable and d(5);
    FIL <= q_fil;
    FF <= FF_in;
    FE <= FE_in;
    IA <= IA_in;
    
end Behavioral;
