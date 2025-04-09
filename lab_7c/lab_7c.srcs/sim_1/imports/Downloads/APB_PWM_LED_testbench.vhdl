
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.APB_test_package.all;

entity APB_PWM_LED_testbench is
end entity;

architecture behavioral of APB_PWM_LED_testbench is
  signal clk,resetn : std_logic := '0';
  signal APBbus : APB_bus_t;
  signal LED : std_logic_vector(15 downto 0);
begin
  

  clk <= not clk after 5 ns;
  resetn <= '1' after 20 ns;
  
  uut: entity work.APB_PWM_LED (behavioral) 
    port map(
      -- Clock and reset
      axi_aclk        => clk,
      axi_arst_n      => resetn,
      -- APB bus
      s_apb_paddr     => APBbus.paddr,
      s_apb_psel      => APBbus.psel,
      s_apb_penable   => APBbus.penable,
      s_apb_pwrite    => APBbus.pwrite,
      s_apb_pwdata    => APBbus.pwdata,
      s_apb_pready    => APBbus.pready, 
      s_apb_prdata    => APBbus.prdata,
      s_apb_pslverr   => APBbus.pslverr,
      -- Port to drive the LEDs
      LED             => LED
      );

  test: process
  begin
    APBbus.pready <= 'Z';
    APBbus.prdata <= (others => 'Z');
    APBbus.pslverr <= 'Z';
    APB_reset_wait(clk,resetn,APBbus);
    wait for 20 ns;

    loop
    
      APB_write(clk, x"00000000", x"76543210", APBbus);
      APB_write(clk, x"00000004", x"FEDCBA98", APBbus);
      
      wait for 1 ms;

      APB_write(clk, x"00000000", x"89ABCDEF", APBbus);
      APB_write(clk, x"00000004", x"01234567", APBbus);
      
      wait for 100 ms;
    end loop;
    
  end process;
  
end architecture;

