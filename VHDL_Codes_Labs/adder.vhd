library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity adder is
generic (
width : integer := 8);
port (
a   : in  std_logic_vector(width - 1 downto 0);
b   : in  std_logic_vector(width - 1 downto 0);
sum : out std_logic_vector(width - 1 downto 0));
end entity adder;
architecture rtl of adder is
begin
-- architecture rtl
sum <= std_logic_vector(unsigned(a) + unsigned(b));
end architecture rtl;
