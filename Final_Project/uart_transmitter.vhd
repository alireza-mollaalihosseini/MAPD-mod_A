library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- entity
entity uart_transmitter is
port (
clk          : in std_logic;
data_to_send : in std_logic_vector(7 downto 0):= (others => '0');
data_valid   : in std_logic;
busy         : out std_logic;
uart_tx      : out std_logic);
end entity uart_transmitter;

architecture str of uart_transmitter is

type state_type is (idle_s, data_is_valid_s, start_s, tx0_s, tx1_s, tx2_s, tx3_s, tx4_s, tx5_s, tx6_s, tx7_s, stop_s);
signal state        : state_type := idle_s ;
signal data_to_send : std_logic_vector(7 downto 0);
signal baudrate_out : std_logic;

component baudrate is
port(
clk          : in std_logic;
baudrate_out : out std_logic);
end component baudrate;

begin -- architecture str

baudrate_gen : baudrate
port map(
clk          => clk,
baudrate_out => baudrate_out);

main : process(clk)
begin -- state_machine
if rising_edge(clk) then
case state is
when idle_s =>
busy <= '0';
tx <= '1';
if (valid = '1') then state <= data_is_valid_s;
end if;
when data_is_valid_s =>
busy <= '1';
data_to_send <= data_to_send;
if (baudrate_out = '1') then state <= start_s;
end if;
when start_s =>
tx <= '0';
if (baudrate_out = '1') then state <= tx0_s;
end if;
when tx0_s =>
tx <= data_to_send(0);
if (baudrate_out = '1') then state <= tx1_s;
end if;
when tx1_s =>
tx <= data_to_send(1);
if (baudrate_out = '1') then state <= tx2_s;
end if;
when tx2_s =>
tx <= data_to_send(2);
if (baudrate_out = '1') then state <= tx3_s;
end if;
when tx3_s =>
tx <= data_to_send(3);
if (baudrate_out = '1') then state <= tx4_s;
end if;
when tx4_s =>
tx <= data_to_send(4);
if (baudrate_out = '1') then state <= tx5_s;
end if;
when tx5_s =>
tx <= data_to_send(5);
if (baudrate_out = '1') then state <= tx6_s;
end if;
when tx6_s =>
tx <= data_to_send(6);
if (baudrate_out = '1') then state <= tx7_s;
end if;
when tx7_s =>
tx <= data_to_send(7);
if (baudrate_out = '1') then state <= stop_s;
end if;
when stop_s =>
tx <= '1';
if (baudrate_out = '1') then state <= idle_s;
end if;
when others =>
null;
end case;
end if;
end process main;
end architecture str;

