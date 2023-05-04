library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sampler_generator is
port (
clk          : in std_logic;
uart_rx      : in std_logic;
baudrate_out : out std_logic);
end entity sample_generator;

architecture str of sampler_generator is

type state_type is (idle_s, start_s, rx0_s, rx1_s, rx2_s, rx3_s, rx4_s, rx5_s, rx6_s, rx7_s, stop_s);
signal state : state_type := idle_s ;
signal counter        : unsigned(10 downto 0) := (others => '0');
signal delay_counter  : unsigned(10 downto 0) := (others => '0');
constant divisor      : unsigned(10 downto 0) := to_unsigned(867, 11);
constant half_divisor : unsigned(10 downto 0) := to_unsigned(433, 11);
signal busy           : std_logic             := '0';
signal pulse_out      : std_logic;
signal enable_counter : std_logic             := '0';
signal enable_delay   : std_logic             := '0';

begin -- architecture str

pulse_generator : process(clk) is

begin -- process

if rising_edge(clk) then
if enable_counter = '1' then
counter <= counter + 1;
if counter = divisor then
pulse_out <= '1';
counter <= (others => '0');
else
pulse_out <= '0';
end if;
else
counter <= (others => '0');
end if;
end if;
end process pulse_generator;

state_machine : process(clk) is
begin -- process

if rising_edge(clk) then
case state is
when idle_s =>
enable_counter <= '0';
if uart_rx = '0' then state <= start_s;
end if;

when start_s =>
enable_counter <= '1';
if pulse_out = '1' then state <= rx0_s;
end if;

when rx0_s =>
if pulse_out = '1' then state <= rx1_s;
end if;

when rx1_s =>
if pulse_out = '1' then state <= rx2_s;
end if;


when rx2_s =>
if pulse_out = '1' then state <= rx3_s;
end if;


when rx3_s =>
if pulse_out = '1' then state <= rx4_s;
end if;

when rx4_s =>
if pulse_out = '1' then state <= rx5_s;
end if;

when rx5_s =>
if pulse_out = '1' then state <= rx6_s;
end if;

when rx6_s =>
if pulse_out = '1' then state <= rx7_s;
end if;

when rx7_s =>
if pulse_out = '1' then state <= idle_s;
end if;

when others => null;
end case;
end if;
end process state_machine;

delay_line : process(clk) is

begin -- process

if rising_edge(clk) then
if pulse_out = '1' then
enable_delay <= '1';
end if;
if enable_delay = '1' then
delay_counter <= delay_counter + 1;
else
delay_counter <= (others => '0');
end if;
if delay_counter = half_divisor then
enable_delay <= '0';
baudrate_out <= '1';
else
baudrate_out <= '0';
end if;
end if;
end process delay_line;
end architecture str;
