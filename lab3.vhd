library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lab3 is
port
(	bs: in std_logic_vector(4 downto 0);
	clk: in std_logic;
	dec: in std_logic;
	ld: in std_logic;
	n: out std_logic
);
end lab3;


architecture rtl of lab3 is

signal count: std_logic_vector(4 downto 0):= "00000";


begin


process(clk)
	begin 
		if rising_edge(clk) then
			if dec = '1' then 
				count <= count-1;	
				if count = "00000" then 
					n <= '1';
				end if;
			end if;
	end if;
end process;

process(ld)
	begin
		if ld = '1' then 
			count <= bs;
		end if;
end process;
end rtl;