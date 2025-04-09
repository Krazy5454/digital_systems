

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity APB_PWM_testbench is
end APB_PWM_testbench;

architecture Behavioral of APB_PWM_testbench is
  
  signal reset_n    : std_logic := '0';
  signal clk        : std_logic := '1';
  signal paddr      : std_logic_vector(31 downto 0) := (others => '0');
  signal psel       : std_logic := '0';
  signal pwrite     : std_logic := '0';
  signal penable    : std_logic := '0';
  signal pwdata     : std_logic_vector(31 downto 0) := (others => '0');
  signal pready     : std_logic;
  signal prdata     : std_logic_vector(31 downto 0);
  signal pslverr    : std_logic;
  -- If the unit under test (uut) has other ports, you can add signals here.
  signal LED    : std_logic_vector(15 downto 0);

begin
  -- Instantiate your APB device to test.
  uut: entity work.APB_PWM_LED(Behavioral)
    port map(
      axi_arst_n      => reset_n,
      axi_aclk        => clk,
      s_apb_paddr     => paddr,
      s_apb_psel      => psel,
      s_apb_pwrite    => pwrite,
      s_apb_penable   => penable,
      s_apb_pwdata    => pwdata,
      s_apb_pready    => pready,
      s_apb_prdata    => prdata,
      s_apb_pslverr   => pslverr,
      -- Map any ports specific to the uut
      LED => LED
      );

  -- run the clock
  clk <= not clk after 5ns;

  -- A process to test your device.
  test: process
    -- Procedure to write to an APB device.  Give the address as an offset from
    -- the device base address.
    procedure APB_write(address: in std_logic_vector(31 downto 0);
                        data:    in std_logic_vector(31 downto 0)) is
    begin
      if not rising_edge(clk) then
        wait until rising_edge(clk);
      end if;
      paddr <= address;
      psel <= '1';
      pwrite <= '1';
      pwdata <= data;
      wait until rising_edge(clk);
      penable <= '1';
      if pready = '0' then
        wait until pready = '1';
      end if;
      wait until rising_edge(clk);
      psel <= '0';
      pwrite <= '0';
      penable <= '0';
    end procedure;
    -- Procedure to read from an APB device.  Give the address as an offset from
    -- the device base address.
    procedure APB_read(address: in std_logic_vector(31 downto 0);
                       rval: out std_logic_vector(31 downto 0)) is
    begin
      if not rising_edge(clk) then
        wait until rising_edge(clk);
      end if;
      paddr <= address;
      psel <= '1';
      pwrite <= '0';
      wait until rising_edge(clk);
      penable <= '1';
      if pready = '0' then
        wait until pready = '1';
      end if;
      rval := prdata;
      wait until rising_edge(clk);
      psel <= '0';
      pwrite <= '0';
      penable <= '0';
    end procedure;

    variable cur_duty : integer := 0;
    variable rdata : std_logic_vector(31 downto 0);
  begin
    -- Make sure we have a full clock cycle before coming out of
    -- reset.
    wait until falling_edge(clk);
    wait until rising_edge(clk);
    reset_n <= '1';  -- come out of reset
    -- Make sure we have a full clock cycle where nothing happens
    -- after coming out of reset.
    wait until falling_edge(clk);
    wait until rising_edge(clk);
    -- Start testing!  You can use the APB_write and APB read
    -- procedures, and put wait statements between them.
    APB_write(X"00000000",X"76543210");
    APB_write(X"00000001",X"FEDCBA98");
       
    -- End testing;
    wait;
  end process;

end Behavioral;
