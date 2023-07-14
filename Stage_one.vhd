library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Stage_one is

port 

(

	clk 			: in std_logic;
	branch 		: in std_logic;
	newPC			: in std_logic_vector(63 downto 0);
	PC_out 		: out std_logic_vector(63 downto 0);
	instruction : out std_logic_vector(31 downto 0)

);


end Stage_one;


architecture rtl of Stage_one is

	component instruction_memory
		port (
			address : in std_logic_vector(63 downto 0);
			instruction : out std_logic_vector(31 downto 0)
		);
	end component ;

	signal inst: std_logic_vector(31 downto 0) := (others=> '0');
	signal PC : std_logic_vector(63 downto 0):= (others =>'0');

begin
	
	my_inst_mem: instruction_memory port map( address => PC,
															instruction => inst);



	process(clk)

		begin

			if rising_edge(clk) then
				
				if branch = '1' then
					PC <= newPC;
				else 
					PC <= std_logic_vector(to_unsigned(to_integer(unsigned(PC))+4,64));
				end if;
				
				instruction <= inst;
				PC_out <= PC;
				
			end if;	

	end process;

end rtl;