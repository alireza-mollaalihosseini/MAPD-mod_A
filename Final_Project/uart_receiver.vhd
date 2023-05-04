library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_receiver is
port (
clk          : in std_logic;
uart_rx      : in std_logic;
data_valid   : out std_logic;
data_to_send : out std_logic_vector(7 downto 0));
end entity uart_receiver;

architecture str of uart_receiver is

type state_type is (idle_s, start_s, rx0_s, rx1_s, rx2_s, rx3_s, rx4_s, rx5_s, rx6_s, rx7_s, stop_s);
signal state        : state_type := idle_s ;
signal data_to_send : std_logic_vector(7 downto 0);
signal baudrate_out : std_logic;
signal data_valid   : std_logic;

component sampler_generator is
port(
clk          : in std_logic;
uart_rx      : in std_logic;
baudrate_out : out std_logic);
end component sampler_generator;

begin -- architecture str

sampler_generator_1 : sampler_generator
port map(
clk          => clk,
uart_rx      => uart_rx,
baudrate_out => baudrate_out);

main : process(clk)

begin -- state_machine

if rising_edge(clk) then
case state is
when idle_s =>
data_valid <= '0';
if (baudrate_out = '1') then state <= start_s;
end if;

when start_s =>
if (baudrate_out = '1') then state <= rx0_s;
end if;

when rx0_s =>
data_to_send(0) <= uart_rx;
if (baudrate_out = '1') then state <= rx1_s;
end if;

when rx1_s =>
data_to_send(1) <= uart_rx;
if (baudrate_out = '1') then state <= rx2_s;
end if;

when rx2_s =>
data_to_send(2) <= uart_rx;
if (baudrate_out = '1') then state <= rx3_s;
end if;

when rx3_s =>
data_to_send(3) <= uart_rx;
if (baudrate_out = '1') then state <= rx4_s;
end if;

when rx4_s =>
data_to_send(4) <= uart_rx;
if (baudrate_out = '1') then state <= rx5_s;
end if;

when rx5_s =>
data_to_send(5) <= uart_rx;
if (baudrate_out = '1') then state <= rx6_s;
end if;

when rx6_s =>
data_to_send(6) <= uart_rx;
if (baudrate_out = '1') then state <= rx7_s;
end if;

when rx7_s =>
data_to_send(7) <= uart_rx;
data_valid <= '1';
if (baudrate_out = '1') then state <= stop_s;
end if;

when stop_s =>
if (baudrate_out = '1') then state <= idle_s;
end if;

when others =>
null;

end case;
end if;
end process main;
end architecture str;

