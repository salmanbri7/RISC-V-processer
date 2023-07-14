LIBRARY ieee; 
USE ieee.std_logic_1164.ALL; 
 
ENTITY ram_dual IS 	 
	PORT 
	( 	clock1, clock2: 	IN STD_LOGIC; 
		data: 	IN STD_LOGIC_VECTOR (3 DOWNTO 0); 
		write_address: 	IN integer RANGE 0 to 31; 
		read_address: 	IN integer RANGE 0 to 31; 
		we: 	IN std_logic; 
		q: 	OUT STD_LOGIC_VECTOR (3 DOWNTO 0)); 
	END ram_dual; 
 
ARCHITECTURE rtl OF ram_dual IS 
--Place here the array for the RAM and any signals needed 

type ram is array(31 downto 0) of std_logic_vector(3 downto 0);
signal my_ram: ram:=(others => (others=> '0'));
	
BEGIN 
	write:PROCESS(clock1,we,write_address) 
	BEGIN 
		if rising_edge(clock1) then
			if we='1' then
				my_ram(write_address)<= data;
			end if;
		end if;
			
	END PROCESS; 
	read:process(clock2, read_address)
	begin
		if rising_edge(clock2) then
			q<=my_ram(read_address);
		end if;

	end process;
	
	
END rtl; 
