Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity counter is

	Port ( inbus : in std_logic_vector(4 downto 0);
			 clk: in std_logic;
			 ld : in std_logic;
			 decr : in std_logic;
			 n : out std_logic );
	
end counter; 
architecture behavioral of counter is
	signal count :  std_logic_vector(4 downto 0) := "00000";
begin 

	
	process(decr,clk,count, ld)
	begin
		
		if rising_edge(clk) then
			if ld = '1' then
				count <= inbus;
			end if;
		
			if decr = '1' then
				count <= count-1;	
			end if;
			
			if count = "0" then
				n<='1';
			else
				n<='0';
			end if;
			
		end if;
	end process;
end behavioral;