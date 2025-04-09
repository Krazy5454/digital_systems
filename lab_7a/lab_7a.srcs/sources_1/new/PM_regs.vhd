library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.mi_package.all;

--use UNISIM.VComponents.all;

entity PM_regs is
    Port ( 
           clk, reset ,wen : in STD_LOGIC;
           w_addr, r_addr : in STD_LOGIC_VECTOR (3 downto 0);
           d : in STD_LOGIC_VECTOR (31 downto 0);
           FF_in, FE_in, IA_in : in STD_LOGIC;
           
           q : out STD_LOGIC_VECTOR (31 downto 0);
           OE, IO, SLFM, PDMM, IE, RF, FF, FE, IA : out STD_LOGIC;
           FIL : out std_logic_vector (4 downto 0);
           CDR, BCR, DCR : out std_logic_vector (15 downto 0)
           );
end PM_regs;

architecture Behavioral of PM_regs is   
    type signal_array is array (3 downto 0 ) of std_logic_vector ( 31 downto 0 );
    signal array_reg: signal_array;
    signal decoded : std_logic_vector ( 3 downto 0 );
    signal i_oe, cdr_en, bcr_en, dcr_en : std_logic;
begin
    decoded <= decode( w_addr(3 downto 2), wen );
    
    CSR : entity work.PM_CSR ( Behavioral )
        port map ( clk => clk, reset => reset, wen => decoded(0), d => d,
                   FF_in => FF_in, FE_in => FE_in, IA_in => IA_in,
                   q => array_reg(0), OE => i_oe, IO =>IO, SLFM => SLFM, PDMM => PDMM, IE => IE,
                   RF => RF, FF => FF, FE => FE, IA => IA, FIL => FIL );
    OE <= i_oe;
    
    cdr_en <= decoded(1) and not i_oe;               
    CDR_reg: entity work.generic_register ( Behavioral )
    generic map ( bits => 16 )
    port map ( clk => clk, reset => reset, enable => cdr_en,
               d => d(15 downto 0), q => array_reg(1)(15 downto 0));
    
    bcr_en <= decoded(2) and not i_oe;          
    BCR_reg: entity work.generic_register ( Behavioral )
    generic map ( bits => 16 )
    port map ( clk => clk, reset => reset, enable => bcr_en,
               d => d(15 downto 0), q => array_reg(2)(15 downto 0));
    
    dcr_en <= decoded(3);            
    DCR_reg: entity work.generic_register ( Behavioral )
    generic map ( bits => 16 )
    port map ( clk => clk, reset => reset, enable => dcr_en,
               d => d(15 downto 0), q => array_reg(3)(15 downto 0));                    
                  

    array_reg(1)(31 downto 16) <= ( others => '0' );
    array_reg(2)(31 downto 16) <= ( others => '0' );
    array_reg(3)(31 downto 16) <= ( others => '0' );
    
    q <= array_reg ( to_integer( unsigned( r_addr (3 downto 2))));
    CDR <= array_reg(1)(15 downto 0);
    BCR <= array_reg(2)(15 downto 0);
    DCR <= array_reg(3)(15 downto 0);


end Behavioral;
