
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use ieee.math_real.log2;
use ieee.math_real.ceil;

package project_types is

  -- Function to create a vector from a bit
  function to_boolean(x: std_logic) return boolean;
                              
  -- Function to convert boolean to std_logic
  function to_std_logic(L: BOOLEAN) return std_ulogic;
    
  -- Function to convert std_logic to boolean
  function to_vector(x: std_logic) return std_logic_vector;
                              
  -- function to return the ceiling of log base 2 of x
  function clog2(X: integer) return integer;
  
end project_types;


package body project_types is

  -- Function to convert std_logic to boolean
  function to_boolean(x: std_logic) return boolean is
    begin
      return x = '1';
    end function;
                              
  -- Function to convert boolean to std_logic
  function to_std_logic(L: BOOLEAN) return std_ulogic is
    begin
      if L then
        return('1');
      else
        return('0');
      end if;
    end function To_Std_Logic;

  -- Function to create a vector from a bit
  function to_vector(x:std_logic) return std_logic_vector is
    variable r : std_logic_vector (0 downto 0);
  begin
    r(0) := x;
    return r;
  end function;  

  -- function to return the ceiling of log base 2 of x
  function clog2(X: integer) return integer is
  begin
    return integer(ceil(log2(real(X))));
  end function clog2;

end project_types;

