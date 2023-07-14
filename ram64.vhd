LIBRARY ieee; 
USE ieee.std_logic_1164.ALL; 
use ieee.numeric_std.all;

 
ENTITY ram64 IS 	 
	PORT 
	( 	clock1	:	IN STD_LOGIC; 
		data		: 	IN STD_LOGIC_VECTOR (63 DOWNTO 0);
		func3		:  IN std_logic_vector(2 downto 0);
		write_address	: IN STD_LOGIC_VECTOR (63 DOWNTO 0); 
		read_address	: IN	STD_LOGIC_VECTOR (63 DOWNTO 0); 
		we	: 	IN std_logic; 
		re	: 	IN std_logic; 		
		q	: 	OUT STD_LOGIC_VECTOR (63 DOWNTO 0)
		); 
	END ENTITY; 
 
ARCHITECTURE rtl OF ram64 IS  

type ram is array(0 to 63) of std_logic_vector(7 downto 0);
signal my_ram: ram:=(
         x"FE", 
			x"05", x"05", x"05", x"05", x"05", x"05", x"05", x"05",
			x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF",
          others => (others => '0'));

signal Write_add : integer RANGE 0 to 63 := 0;
signal Read_add  : integer RANGE 0 to 63 := 0;
signal temp16 : std_logic_vector(15 downto 0) :=(others=> '0');
signal temp32 : std_logic_vector(31 downto 0) :=(others=> '0');
signal temp64 : std_logic_vector(63 downto 0) :=(others=> '0');


	
BEGIN 

Write_add <= to_integer(unsigned(write_address(5 downto 0)));
Read_add <= to_integer(unsigned(read_address(5 downto 0)));


	write:PROCESS(clock1,we,write_address) 
	BEGIN 
		if rising_edge(clock1) then
			if we='1' then
				if func3 = "000" then									--store byte
					my_ram(write_add)<= data(7 downto 0);
					
				elsif func3 = "001" then 								-- store half word 
					my_ram(write_add)<= data(7 downto 0); 
					my_ram(write_add+1)<= data(15 downto 8);
				
				elsif func3 = "010" then  								-- store word
					my_ram(write_add)<= data(7 downto 0); 
					my_ram(write_add+1)<= data(15 downto 8);
					my_ram(write_add+2)<= data(23 downto 16);
					my_ram(write_add+3)<= data(31 downto 24);
				
				elsif func3 = "011" then 								-- store double word
					my_ram(write_add)<= data(7 downto 0); 
					my_ram(write_add+1)<= data(15 downto 8);
					my_ram(write_add+2)<= data(23 downto 16);
					my_ram(write_add+3)<= data(31 downto 24);
					my_ram(write_add+4)<= data(39 downto 32);
					my_ram(write_add+5)<= data(47 downto 40);
					my_ram(write_add+6)<= data(55 downto 48);
					my_ram(write_add+7)<= data(63 downto 56);
				end if;
					
					
			end if;
		end if;
			
	END PROCESS; 
	
	read:process(clock1, read_address,re,func3,temp16,temp32)
	begin
		
		if re='1' then
			
			if func3 = "000" then  			-- read signed byte 
				q <= std_logic_vector(resize(signed(my_ram(Read_add)), q'length));
				
			elsif func3 = "001" then  		-- read signed half word  
					temp16 <= my_ram(Read_add+1)&my_ram(Read_add);
					q <= std_logic_vector(resize(signed(temp16), q'length));
				
				--q <= std_logic_vector(resize(signed(my_ram(Read_add+1)&my_ram(Read_add)), q'length));
				
			elsif func3 = "010" then		-- read signed word 
					temp32 <=my_ram(Read_add+3)&my_ram(Read_add+2)&my_ram(Read_add+1)&my_ram(Read_add);
					q <= std_logic_vector(resize(signed(temp32), q'length));
					
		--q <= std_logic_vector(resize(signed(my_ram(Read_add+3)&my_ram(Read_add+2)&my_ram(Read_add+1)&my_ram(Read_add)), q'length));
				
			elsif func3 = "011" then		-- read double word 

				q <= my_ram(Read_add+7)&my_ram(Read_add+6)&my_ram(Read_add+5)&my_ram(Read_add+4)&my_ram(Read_add+3)&my_ram(Read_add+2)&my_ram(Read_add+1)&my_ram(Read_add);
				
			elsif func3 = "100" then 		-- read unsigned byte
				q <= std_logic_vector(resize(unsigned(my_ram(Read_add)), q'length));
				
			elsif func3 = "101" then 		-- read unsigned half word 
				temp16 <= my_ram(Read_add+1)&my_ram(Read_add);
					q <= std_logic_vector(resize(unsigned(temp16), q'length));
				--q <= std_logic_vector(resize(unsigned(my_ram(Read_add+1)&my_ram(Read_add)), q'length));
				
			elsif func3 = "110" then 		-- read unsigned word 
			temp32 <=my_ram(Read_add+3)&my_ram(Read_add+2)&my_ram(Read_add+1)&my_ram(Read_add);
					q <= std_logic_vector(resize(unsigned(temp32), q'length));
					
				--q <= std_logic_vector(resize(unsigned(my_ram(Read_add+3)&my_ram(Read_add+2)&my_ram(Read_add+1)&my_ram(Read_add)), q'length));
				
			end if;
		
		end if;
		

	end process;
	
	
END rtl; 