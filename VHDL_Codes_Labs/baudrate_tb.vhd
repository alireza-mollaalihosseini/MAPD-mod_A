library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity baudrate_tb is
end entity baudrate_tb;

architecture test of baudrate_tb is
signal clk          : std_logic := '1';
signal baudrate_out : std_logic ;

begin -- architecture test
DUT : entity work.baudrate
port map (
clk => clk, 
baudrate_out => baudrate_out);

-- clock generation
clk <= not clk after 5 ns;

main : process
begin -- process main

wait;    
end process main;
end architecture test;

