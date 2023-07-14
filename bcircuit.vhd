Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;




entity bcircuit is

	Port ( conin : in std_logic;
			 IR: in std_logic_vector(2 downto 0);
			 inbus : in std_logic_vector(7 downto 0);
			 condition : out std_logic;
			 ld : in std_logic;
			 decr : in std_logic;
			 n : out std_logic );
	
end bcircuit; 
architecture behavioral of bcircuit is
	component counter is

		Port ( inbus : in std_logic_vector(4 downto 0);
				 clk: in std_logic;
				 ld : in std_logic;
				 decr : in std_logic;
				 n : out std_logic );
		
	end component; 
begin
 
	counter1 : counter port map(
					inbus=>inbus(4 downto 0),
					clk=>conin,
					ld=>ld,
					decr=>decr,
					n=>n
	);
	
	
	process(ir,inbus,conin)
	begin 
		if ir = 0 then 
			condition <= '0';
			
		elsif ir = 1 then
			condition <= '1';
			
		elsif ir = 2 then
--			condition <= not(inbus or inbus);
			if inbus = "0" then
				condition <= '1';
			else 
				condition <= '0';
			end if;
		elsif ir = 3 then
--			condition <= not(inbus nor inbus);
			if inbus /= "0" then
				condition <= '1';
			else 
				condition <= '0';
			end if;
		elsif ir = 4 then
			condition <= not(inbus(7));
			
		elsif ir = 5 then
			condition <= inbus(7);
		end if;
	end process;
		
 
end behavioral;