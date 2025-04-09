
-- Example entity with an APB slave interface 
-- Author: Larry D. Pyeatt
-- Date: September 25, 2020
-- 
-- Xilinx Vivado can infer the existence of an "interface" if we name
-- the ports correctly and give them each an X_INTERFACE_INFO
-- attribute.
-- 
-- Creating an interface allows us to use the block design schematic
-- editor to just draw a line connecting the APB device with the AXI
-- to APB bridge.


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity APB_PWM_LED is
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
    LED             :out std_logic_vector(15 downto 0)
    );
  ATTRIBUTE X_INTERFACE_INFO : STRING;
end APB_PWM_LED;


-- Fill in your architecture here.  This one just sends the data
-- register to the LED's.  It is a GPO device (GPIO without the I).
-- It gives attributes to the APB ports so that Vivado can create an
-- interface for the block design and let you easily connect it with
-- the GUI.
architecture Behavioral of APB_PWM_LED is
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
begin

enable <= s_apb_psel and s_apb_penable and s_apb_pwrite;
axi_arst <= not(axi_arst_n);

PWM_Array_Driver: entity work.PWM_Array_Driver ( two_by_32 )
    Port map ( clk => axi_aclk, 
               wen => enable,
               reset => axi_arst,
               adr => s_apb_paddr(2 downto 2),
               d => s_apb_pwdata,
               leds => LED);

--APB Outputs     
s_apb_pready <= '1';            
s_apb_pslverr <= '0';
s_apb_prdata <= (others => '0');
               
end Behavioral;
