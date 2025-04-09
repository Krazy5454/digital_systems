library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.mi_package.all;

--use UNISIM.VComponents.all;

entity PM_regs is
    Port ( 
           clk, reset, wen : in STD_LOGIC;
           w_addr, r_addr : in STD_LOGIC_VECTOR (3 downto 0);
           d : in STD_LOGIC_VECTOR (31 downto 0);
           base_reset, div_reset : in std_logic;
           
           q : out STD_LOGIC_VECTOR (31 downto 0);
           OE, IO, SLFM, PDMM, IE, RF, FF, FE, IA : out STD_LOGIC;
           FIL : out std_logic_vector (4 downto 0);
           CDR, BCR, DCR : out std_logic_vector (15 downto 0)
           );
end PM_regs;

architecture Behavioral of PM_regs is   
    type signal_array is array (3 downto 0 ) of std_logic_vector ( 31 downto 0 );
    signal array_reg: signal_array := ( others => ( others => '0' ) );
    signal decoded : std_logic_vector ( 3 downto 0 );
    signal cdr_en, bcr_en, dcr_en : std_logic;
    signal OE_i, SLFM_i, IE_i, RF_i, FF_i, FE_i, IA_i  : std_logic;
    signal FIL_i : std_logic_vector (4 downto 0);
begin
    decoded <= decode( w_addr(3 downto 2), wen );
    
    CSR : entity work.PM_CSR ( Behavioral ) 
        port map ( clk => clk, reset => reset, wen => decoded(0), d => d,
                   FF_in => FF_i, FE_in => FE_i, IA_in => IA_i,
                   q => array_reg(0), OE => OE_i, IO =>IO, SLFM => SLFM_i, PDMM => PDMM, IE => IE,
                   RF => RF_i, FF => FF, FE => FE, IA => IA, FIL => FIL_i );
    
    cdr_en <= decoded(1) and not OE_i;               
    CDR_reg: entity work.generic_register ( Behavioral )
    generic map ( bits => 16 )
    port map ( clk => clk, reset => reset, enable => cdr_en,
               d => d(15 downto 0), q => array_reg(1)(15 downto 0));
    
    bcr_en <= decoded(2) and not OE_i;          
    BCR_reg: entity work.generic_register ( Behavioral )
    generic map ( bits => 16 )
    port map ( clk => clk, reset => reset, enable => bcr_en,
               d => d(15 downto 0), q => array_reg(2)(15 downto 0));
            
--    DCR_reg: entity work.generic_register ( Behavioral )
--    generic map ( bits => 16 )
--    port map ( clk => clk, reset => reset, enable => dcr_en,
--               d => d(15 downto 0), q => array_reg(3)(15 downto 0));                    
                  

    --DCR fifo
    dcr_en <= decoded(3); 
    DCR_fifo: entity work. generic_FIFO ( behavioral )
    generic map ( bits => 16, depth => 32 )
    port map ( clk => clk, rst => RF_i, wdata => d(15 downto 0), wen => dcr_en, ren => base_reset and div_reset and OE_i, enable_fifo => SLFM_i, threshold => FIL_i,
               rdata => array_reg(3)(15 downto 0), empty => FE_i, full => FF_i, below_threshold => IA_i);
    
    
    array_reg(1)(31 downto 16) <= ( others => '0' );
    array_reg(2)(31 downto 16) <= ( others => '0' );
    array_reg(3)(31 downto 16) <= ( others => '0' );
    
    --outputs
    q <= array_reg ( to_integer( unsigned( r_addr (3 downto 2))));
    CDR <= array_reg(1)(15 downto 0);
    BCR <= array_reg(2)(15 downto 0);
    DCR <= array_reg(3)(15 downto 0);
    
    OE <= OE_i;
    SLFM <= SLFM_i;
    FIL <= FIL_i;

end Behavioral;
