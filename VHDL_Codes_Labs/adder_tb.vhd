library ieee;
use ieee.std_logic_1164.all;
entity adder_tb is
end entity adder_tb;
architecture test of adder_tb is
constant width : integer := 8;
signal a
: std_logic_vector(width - 1 downto 0);
signal b
: std_logic_vector(width -1 downto 0);
signal sum : std_logic_vector(width - 1 downto 0);
signal Clk : std_logic := '1';
begin -- architecture test
DUT : entity work.adder
generic map (
width => width)
port map (
a
=> a,
b
=> b,
sum => sum);
main : process is
begin -- process main
a <= X"AA";
B <= X"BB";
wait for 1 ns;
a <= X"A0";
B <= X"B0";
wait for 1 ns;
wait;
end process main;
end architecture test;
