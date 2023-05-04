library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity my_fir is
port(   
	Clk      : in std_logic; --clock signal
	valid_in : in std_logic;
	Xin      : in signed(7 downto 0); --input signal
	valid_o  : out std_logic :='0';
	Yout     : out signed(7 downto 0)  --filter output
);
end my_fir;

architecture Behavioral of my_fir is

component DFF is
   port(
      Q   : out signed(15 downto 0);    --output connected to the adder
      Clk :in std_logic;              -- Clock input
      D   :in  signed(15 downto 0)      -- Data input from the MCM block.
   );
end component; 
   
signal H0,H1,H2,H3 : signed(7 downto 0) := (others => '0');
signal MCM0,MCM1,MCM2,MCM3,add_out1,add_out2,add_out3 : signed(15 downto 0) := (others => '0');
signal Q1,Q2,Q3 : signed(15 downto 0) := (others => '0');

begin

--filter coefficient initializations.
--H = [-2 -1 3 4].
H0 <= to_signed(-2,8);
H1 <= to_signed(-1,8);
H2 <= to_signed(3,8);
H3 <= to_signed(4,8);

--Multiple constant multiplications.
MCM3 <= H3*Xin;
MCM2 <= H2*Xin;
MCM1 <= H1*Xin;
MCM0 <= H0*Xin;

--adders
add_out1 <= Q1 + MCM2;
add_out2 <= Q2 + MCM1;
add_out3 <= Q3 + MCM0;

--flipflops(for introducing a delay).
-- dff : DFF port map(out,in,in);
dff1 : DFF port map(Q1,Clk,MCM3);
dff2 : DFF port map(Q2,Clk,add_out1);
dff3 : DFF port map(Q3,Clk,add_out2);

--an output produced at every positive edge of clock cycle.
process(Clk)
begin
    
    if(rising_edge(Clk)) then
    	if(valid_in='1') then
        Yout <= resize(signed(add_out3),8);
        --Yout <= shift_right(add_out3 , 1)
        valid_o <= valid_in
        end if;
    end if;
end process;
