library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

package mi_package is
function decode (signal sel: std_logic_vector; signal enable: std_logic ) return std_logic_vector;
function vector_and ( signal to_and : std_logic_vector ) return std_logic;
end mi_package;

package body mi_package is

function decode (signal sel: std_logic_vector; signal enable: std_logic ) return std_logic_vector is
    variable decoded : std_logic_vector ((2**sel'length)-1 downto 0);
begin
        decoded := (others => '0');
        decoded( to_integer( unsigned( sel ))) := enable;
        return decoded;
end function;
    
function vector_and ( signal to_and : std_logic_vector ) return std_logic is
    variable result : std_logic := '1';
begin
    for i in to_and'range loop
        result := to_and(i) and result;
    end loop;
end function;
end mi_package;