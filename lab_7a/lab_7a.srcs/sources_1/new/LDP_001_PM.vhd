library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.mi_package.all;

entity LDP_001_PM is
  generic ( channels : integer := 5 );
  port (
    -- Clock and reset
    axi_aclk        :in  std_logic; 
    axi_arst_n      :in  std_logic;    
    -- The APB port
    s_apb_paddr     :in  std_logic_vector(31 downto 0);   
    s_apb_psel      :in  std_logic;                       
    s_apb_penable   :in  std_logic;                       
    s_apb_pwrite    :in  std_logic;                       
    s_apb_pwdata    :in  std_logic_vector(31 downto 0);   
    s_apb_pready    :out std_logic := '0';                       
    s_apb_prdata    :out std_logic_vector(31 downto 0) := (others => '0');   
    s_apb_pslverr   :out std_logic := '0';    
    -- Port to drive the LEDs
    PM_out          :out std_logic_vector(channels-1 downto 0);
    enabled         :out std_logic_vector(channels-1 downto 0)
    );
  ATTRIBUTE X_INTERFACE_INFO : STRING;
end LDP_001_PM;

architecture Behavioral of LDP_001_PM is
  ATTRIBUTE X_INTERFACE_INFO of s_apb_paddr :SIGNAL is
    "xilinx.com:interface:apb:1.0 S_APB PADDR";
  ATTRIBUTE X_INTERFACE_INFO of s_apb_psel     :SIGNAL is
    "xilinx.com:interface:apb:1.0 S_APB PSEL";
  ATTRIBUTE X_INTERFACE_INFO of s_apb_penable  :SIGNAL is
    "xilinx.com:interface:apb:1.0 S_APB PENABLE";
  ATTRIBUTE X_INTERFACE_INFO of s_apb_pwrite   :SIGNAL is
    "xilinx.com:interface:apb:1.0 S_APB PWRITE";
  ATTRIBUTE X_INTERFACE_INFO of s_apb_pwdata   :SIGNAL is
    "xilinx.com:interface:apb:1.0 S_APB PWDATA";
  ATTRIBUTE X_INTERFACE_INFO of s_apb_pready   :SIGNAL is
    "xilinx.com:interface:apb:1.0 S_APB PREADY";
  ATTRIBUTE X_INTERFACE_INFO of s_apb_prdata   :SIGNAL is
    "xilinx.com:interface:apb:1.0 S_APB PRDATA";
  ATTRIBUTE X_INTERFACE_INFO of s_apb_pslverr  :SIGNAL is
    "xilinx.com:interface:apb:1.0 S_APB PSLVERR";

  -- Define any signals that your architecture needs.
    signal axi_arst, enable: std_logic;
    signal enable_port: std_logic_vector ( 7 downto 0 );
    type signal_array is array ( 4 downto 0 ) of std_logic_vector ( 31 downto 0 );
    signal output_array: signal_array;
begin

enable <= s_apb_psel and s_apb_penable and s_apb_pwrite;
axi_arst <= not(axi_arst_n);
enable_port <= decode ( s_apb_paddr( 6 downto 4 ), enable );


channel : for i in 0 to channels-1 generate
    PM_channel: entity work.channels ( Behavioral )
        Port map ( clk => axi_aclk,
                   reset => axi_arst,   
                   wen => enable_port(i),
                   w_addr => s_apb_paddr(3 downto 0),
                   r_addr => s_apb_paddr(3 downto 0),
                   d => s_apb_pwdata,
                   q => output_array(i),
                   output => PM_out(i),
                   output_enabled => enabled(i)
                   );
end generate;

--APB Outputs     
s_apb_pready <= '1';            
s_apb_pslverr <= '0';
s_apb_prdata <= output_array( to_integer ( unsigned ( s_apb_paddr (31 downto 4 ) ) ) );
               
end Behavioral;