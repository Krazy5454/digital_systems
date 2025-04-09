-- Package to support APB device testbenches.
-- Author: Larry D. Pyeatt
-- Date: January 25, 2023
-- 
-- This package provides a data type and procedures to help with
-- testing of APB devices under a testbench.  This code is not
-- synthesizable.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package APB_test_package is

type apb_bus_t is record
   paddr      : std_logic_vector(31 downto 0);
   pprot      : std_logic_vector(2 downto 0);  -- Protection
   psel       : std_logic;
   pwrite     : std_logic;
   penable    : std_logic;
   pwdata     : std_logic_vector(31 downto 0);
   pstrb      : std_logic_vector(3 downto 0);  -- lanes to write
   pready     : std_logic;
   prdata     : std_logic_vector(31 downto 0);
   pslverr    : std_logic;
end record;

-- Procedure to intitialize the simulated APB bus.  It waits until reset goes
-- high then initializes the bus.  This should be called once at the beginning
-- of a simulation.
procedure APB_reset_wait(signal clk    : in std_logic;
                         signal resetn : in std_logic;
                         signal apb    : inout apb_bus_t
                         );

-- Procedure to write to an APB device.  Give the address as an offset from
-- the device base address.
procedure APB_write(signal clk    : in std_logic;
                    address: in std_logic_vector(31 downto 0);
                    data   : in std_logic_vector(31 downto 0);
                    signal apb    : inout apb_bus_t;
                    signal ready, slverr : in std_logic;
                    signal rdata  : in std_logic_vector(31 downto 0)
                    );

-- Procedure to read from an APB devi./Lab_6.srcs/sources_1/imports/new/APB_package.vhdlce.  Give the address as an offset from
-- the device base address.
procedure APB_read(signal clk    : in std_logic;
                   address: in std_logic_vector(31 downto 0);
                    signal apb    : inout apb_bus_t;
                    signal ready, slverr : in std_logic;
                    signal rdata  : in std_logic_vector(31 downto 0)
                   );

end package;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package body APB_test_package is

  -- Procedure to intitialize the simulated APB bus.  It waits until reset goes
  -- high then initializes the bus..
  procedure APB_reset_wait(signal clk    : in std_logic;
                         signal resetn : in std_logic;
                         signal apb    : inout apb_bus_t
                         ) is
  begin
    if not resetn = '1' then
      wait until resetn = '1';
    end if;
    apb.pstrb <= "1111";
    apb.pprot <= "000";
    apb.paddr <= (others => '0');
    apb.psel <= '0';
    apb.pwrite <= '0';
    apb.pwdata <= (others => '0');
    apb.penable <= '0';
  end procedure;


  procedure APB_write(signal clk: in std_logic;
                      address: in std_logic_vector(31 downto 0);
                      data:    in std_logic_vector(31 downto 0);
                      signal apb    : inout apb_bus_t;
                      signal ready, slverr : in std_logic;
                      signal rdata  : in std_logic_vector(31 downto 0)) is
    begin
      -- apb.pready <= ready;
      -- apb.pslverr <= slverr;
      -- apb.prdata <= rdata;
      if not rising_edge(clk) then
        wait until rising_edge(clk);
      end if;
      apb.paddr <= address;
      apb.psel <= '1';
      apb.pwrite <= '1';
      apb.pwdata <= data;
      wait until rising_edge(clk);
      apb.penable <= '1';
      if ready /= '1' then
        wait until ready = '1';
      end if;
      wait until rising_edge(clk);
      apb.psel <= '0';
      apb.pwrite <= '0';
      apb.penable <= '0';
    end procedure;
    
    -- Procedure to read from an APB device.  Give the address as an offset from
    -- the device base address.
    procedure APB_read(signal clk:     in std_logic;
                       address: in std_logic_vector(31 downto 0);
                       signal apb    : inout apb_bus_t;
                       signal ready, slverr : in std_logic;
                       signal rdata  : in std_logic_vector(31 downto 0)) is
    begin
      -- apb.pready <= ready;
      -- apb.pslverr <= slverr;
      -- apb.prdata <= rdata;
      if not rising_edge(clk) then
        wait until rising_edge(clk);
      end if;
      apb.paddr <= address;
      apb.psel <= '1';
      apb.pwrite <= '0';
      wait until rising_edge(clk);
      apb.penable <= '1';
      if ready /= '1' then
        wait until ready = '1';
      end if;
      wait until rising_edge(clk);
      apb.psel <= '0';
      apb.pwrite <= '0';
      apb.penable <= '0';
    end procedure;
end package body;
