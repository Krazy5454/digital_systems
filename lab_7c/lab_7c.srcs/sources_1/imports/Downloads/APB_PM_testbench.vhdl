library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.APB_test_package.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity APB_PM_testbench is
end APB_PM_testbench;

architecture Behavioral of APB_PM_testbench is
  signal axi_aclk, axi_arst_n :std_logic := '0';
  signal apb : apb_bus_t;
  signal PM_out,enabled : std_logic_vector(4 downto 0);
  signal interrupt, pready, pslverr : std_logic;
  signal prdata : std_logic_vector(31 downto 0);
    
begin
  apb.pready  <= pready;
  apb.prdata  <= prdata;
  apb.pslverr <= pslverr;
  
  axi_aclk <= not axi_aclk after 5 ns;
  axi_arst_n <= '1' after 20 ns;
  
  uut : entity work.LDP_001_PM(behavioral)
    port map(
      axi_aclk   => axi_aclk,
      axi_arst_n => axi_arst_n,
      s_apb_paddr   => apb.paddr,
      s_apb_psel    => apb.psel,
      s_apb_penable => apb.penable,
      s_apb_pwrite  => apb.pwrite,
      s_apb_pwdata  => apb.pwdata, 
      s_apb_pready  => pready,
      s_apb_prdata  => prdata,
      s_apb_pslverr => pslverr,
      -- Port to dr
      PM_out        => PM_out,
      enabled       => enabled,
      interrupt     => interrupt
      );
  
  test: process
  begin
    apb.pready <= 'Z';
    apb.prdata <= (others => 'Z');
    apb.pslverr <= 'Z';
    APB_reset_wait(axi_aclk,axi_arst_n,apb);
    wait for 10 ns;

    ----------------------------------------------------------------------
    -- set clk to divide by two
    APB_write(axi_aclk,x"00000004",x"00000001",apb,pready,pslverr,prdata);

    -- set base cycle time to 8 divisions
    APB_write(axi_aclk,x"00000008",x"00000007",apb,pready,pslverr,prdata);

    ----------------------------------------------------------------------
    -- enable output, PwM mode
    APB_write(axi_aclk,x"00000000",x"00000001",apb,pready,pslverr,prdata);

    wait for 1000 ns;
    -- go to 25% duty
    APB_write(axi_aclk,x"0000000C",x"00000002",apb,pready,pslverr,prdata);

    wait for 1000 ns;
    -- go to 50% duty
    APB_write(axi_aclk,x"0000000C",x"00000004",apb,pready,pslverr,prdata);

    wait for 1000 ns;
    -- go to 75% duty
    APB_write(axi_aclk,x"0000000C",x"00000006",apb,pready,pslverr,prdata);

--    wait for 1000 ns;
--    -- go to 100% duty
--    APB_write(axi_aclk,x"0000000C",x"00000008",apb,pready,pslverr,prdata);

    wait for 1000 ns;
    --disable output
    APB_write(axi_aclk,x"00000000",x"00000000",apb,pready,pslverr,prdata);
    
    --invert output and enable
    APB_write(axi_aclk,x"00000000",x"00000003",apb,pready,pslverr,prdata);
    wait for 1000 ns;
    APB_write(axi_aclk,x"0000000C",x"00000001",apb,pready,pslverr,prdata);
    --next output port
    -- set clk to same clk
    APB_write(axi_aclk,x"00000014",x"00000000",apb,pready,pslverr,prdata);

    -- set base cycle time to 8 divisions
    APB_write(axi_aclk,x"00000018",x"00000009",apb,pready,pslverr,prdata);
    -- enable output, PwM mode
    APB_write(axi_aclk,x"00000010",x"00000001",apb,pready,pslverr,prdata);

    wait for 1000 ns;
    -- go to 10% duty
    APB_write(axi_aclk,x"0000001C",x"00000001",apb,pready,pslverr,prdata);

    wait for 1000 ns;
    -- go to 40% duty
    APB_write(axi_aclk,x"0000001C",x"00000004",apb,pready,pslverr,prdata);
    
    --try to write to CSR while enabled
    wait for 1000 ns;
    APB_write(axi_aclk,x"00000010",x"00000003",apb,pready,pslverr,prdata);
    
    --try to write to CDR and BCR while enabled
    wait for 1000 ns;
    APB_write(axi_aclk,x"00000014",x"00000045",apb,pready,pslverr,prdata);
    APB_write(axi_aclk,x"00000018",x"00000023",apb,pready,pslverr,prdata);
    
    --disable
    wait for 1000 ns;
    APB_write(axi_aclk,x"00000010",x"00000000",apb,pready,pslverr,prdata);
    
    --invert while disabled
    wait for 1000 ns;
    APB_write(axi_aclk,x"00000010",x"00000002",apb,pready,pslverr,prdata);
    
    
    


    ----------------------------------------------------------------------
    -- turn on fifo mode and enable interrupts at level 8
    APB_write(axi_aclk,x"00000000",x"00000000",apb,pready,pslverr,prdata);
    APB_write(axi_aclk,x"00000000",x"00000004",apb,pready,pslverr,prdata);


    wait for 40 ns;
    -- go to 0% duty
    APB_write(axi_aclk,x"0000000C",x"00000000",apb,pready,pslverr,prdata);
    -- go to 12.5% duty
    APB_write(axi_aclk,x"0000000C",x"00000001",apb,pready,pslverr,prdata);
    -- go to 25% duty
    APB_write(axi_aclk,x"0000000C",x"00000002",apb,pready,pslverr,prdata);
    -- go to 37.5% duty
    APB_write(axi_aclk,x"0000000C",x"00000003",apb,pready,pslverr,prdata);
    -- go to 50.5% duty
    APB_write(axi_aclk,x"0000000C",x"00000004",apb,pready,pslverr,prdata);
    -- go to 62.5% duty
    APB_write(axi_aclk,x"0000000C",x"00000005",apb,pready,pslverr,prdata);
    -- go to 755% duty
    APB_write(axi_aclk,x"0000000C",x"00000006",apb,pready,pslverr,prdata);
    -- go to 87.5% duty
    APB_write(axi_aclk,x"0000000C",x"00000007",apb,pready,pslverr,prdata);
    -- go to 100% duty
    APB_write(axi_aclk,x"0000000C",x"00000008",apb,pready,pslverr,prdata);

    -- ramp back down
    APB_write(axi_aclk,x"0000000C",x"00000007",apb,pready,pslverr,prdata);
    -- go to 87.5% duty
    APB_write(axi_aclk,x"0000000C",x"00000006",apb,pready,pslverr,prdata);
    -- go to 75% duty
    APB_write(axi_aclk,x"0000000C",x"00000005",apb,pready,pslverr,prdata);
    -- go to 62.5% duty
    APB_write(axi_aclk,x"0000000C",x"00000004",apb,pready,pslverr,prdata);
    -- go to 50% duty
    APB_write(axi_aclk,x"0000000C",x"00000003",apb,pready,pslverr,prdata);
    -- go to 37.5% duty
    APB_write(axi_aclk,x"0000000C",x"00000002",apb,pready,pslverr,prdata);
    -- go to 25% duty
    APB_write(axi_aclk,x"0000000C",x"00000001",apb,pready,pslverr,prdata);
    -- go to 12.5% duty
    APB_write(axi_aclk,x"0000000C",x"00000000",apb,pready,pslverr,prdata);
    wait for 100 ns;
    APB_write(axi_aclk,x"00000000",x"40000015",apb,pready,pslverr,prdata);
    
    --read from DCR 
    APB_read(axi_aclk,x"0000000C",apb,pready,pslverr,prdata);

    ----------------------------------------------------------------------
     wait for 6000 ns;
     --disable fifo, run
     APB_write(axi_aclk,x"00000000",x"00000000",apb,pready,pslverr,prdata);
     APB_write(axi_aclk,x"00000000",x"00000001",apb,pready,pslverr,prdata);
     wait for 3000 ns;
     
   -- disable output
    APB_write(axi_aclk,x"00000000",x"00000000",apb,pready,pslverr,prdata);
    wait for 200 ns;
    -- enable output, PDM mode
    APB_write(axi_aclk,x"00000000",x"00000009",apb,pready,pslverr,prdata);

    wait for 1000 ns;
    -- go to 25% duty
    APB_write(axi_aclk,x"0000000C",x"00000002",apb,pready,pslverr,prdata);

    wait for 1000 ns;
    -- go to 50% duty
    APB_write(axi_aclk,x"0000000C",x"00000004",apb,pready,pslverr,prdata);

    wait for 1000 ns;
    -- go to 75% duty
    APB_write(axi_aclk,x"0000000C",x"00000006",apb,pready,pslverr,prdata);

    wait for 1000 ns;
    -- go to 100% duty
    APB_write(axi_aclk,x"0000000C",x"00000008",apb,pready,pslverr,prdata);

    wait for 1000 ns;


    ----------------------------------------------------------------------
    -- turn on PDM fifo mode and enable interrupts at level 4
    APB_write(axi_aclk,x"00000000",x"00000000",apb,pready,pslverr,prdata);
    wait for 200 ns;
    APB_write(axi_aclk,x"00000000",x"4000001C",apb,pready,pslverr,prdata);

    -- go to 0% duty
    APB_write(axi_aclk,x"0000000C",x"00000000",apb,pready,pslverr,prdata);
    -- go to 12.5% duty
    APB_write(axi_aclk,x"0000000C",x"00000001",apb,pready,pslverr,prdata);
    -- go to 25% duty
    APB_write(axi_aclk,x"0000000C",x"00000002",apb,pready,pslverr,prdata);
    -- go to 37.5% duty
    APB_write(axi_aclk,x"0000000C",x"00000003",apb,pready,pslverr,prdata);
    -- go to 50.5% duty
    APB_write(axi_aclk,x"0000000C",x"00000004",apb,pready,pslverr,prdata);
    -- go to 62.5% duty
    APB_write(axi_aclk,x"0000000C",x"00000005",apb,pready,pslverr,prdata);
    -- go to 755% duty
    APB_write(axi_aclk,x"0000000C",x"00000006",apb,pready,pslverr,prdata);
    -- go to 87.5% duty
    APB_write(axi_aclk,x"0000000C",x"00000007",apb,pready,pslverr,prdata);
    -- go to 100% duty
    APB_write(axi_aclk,x"0000000C",x"00000008",apb,pready,pslverr,prdata);

    -- ramp back down
    APB_write(axi_aclk,x"0000000C",x"00000007",apb,pready,pslverr,prdata);
    -- go to 12.5% duty
    APB_write(axi_aclk,x"0000000C",x"00000006",apb,pready,pslverr,prdata);
    -- go to 25% duty
    APB_write(axi_aclk,x"0000000C",x"00000005",apb,pready,pslverr,prdata);
    -- go to 37.5% duty
    APB_write(axi_aclk,x"0000000C",x"00000004",apb,pready,pslverr,prdata);
    -- go to 50.5% duty
    APB_write(axi_aclk,x"0000000C",x"00000003",apb,pready,pslverr,prdata);
    -- go to 62.5% duty
    APB_write(axi_aclk,x"0000000C",x"00000002",apb,pready,pslverr,prdata);
    -- go to 755% duty
    APB_write(axi_aclk,x"0000000C",x"00000001",apb,pready,pslverr,prdata);
    -- go to 87.5% duty
    APB_write(axi_aclk,x"0000000C",x"00000000",apb,pready,pslverr,prdata);
    --enable cahnnel
    APB_write(axi_aclk,x"00000000",x"4000001D",apb,pready,pslverr,prdata);
    
    --read from DCR
    APB_read(axi_aclk,x"0000000C",apb,pready,pslverr,prdata);

    wait;
  end process;
  
end Behavioral;

