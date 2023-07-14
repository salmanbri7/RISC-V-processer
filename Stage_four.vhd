library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Stage_four is

port 

(

	clk 			: in std_logic;
	PC				: in std_logic_vector(63 downto 0); --
	store_data	: in std_logic_vector(63 downto 0); --
	regWrite		: in std_logic; --
	branch		: in std_logic; --
	MemtoReg		: in std_logic; --
	MemRead		: in std_logic; --
	MemWrite		: in std_logic; --
	zero	 		: in std_logic; --
	ALU_result 	: in std_logic_vector(63 downto 0); --
	rd_add	 	: in std_logic_vector(4 downto 0); --
	func3			: in std_logic_vector(2 downto 0); --
	
	rd_add_o	 	: out std_logic_vector(4 downto 0);  --
	PC_out 		: out std_logic_vector(63 downto 0);--
	Result 		: out std_logic_vector(63 downto 0);--
	MemReadData	: out std_logic_vector(63 downto 0);--
	PCsrc			: out std_logic;---
	MemtoReg_o	: out std_logic;--
	regWrite_o	: out std_logic--
	

);


end Stage_four;


architecture rtl of Stage_four is

	component ram64	 
	
	port	
	( 	clock1			:	IN STD_LOGIC; 
		data				: 	IN STD_LOGIC_VECTOR (63 DOWNTO 0);
		func3				:  IN std_logic_vector(2 downto 0);
		write_address	: IN STD_LOGIC_VECTOR (63 DOWNTO 0); 
		read_address	: IN	STD_LOGIC_VECTOR (63 DOWNTO 0); 
		we					: 	IN std_logic; 
		re					: 	IN std_logic; 	
		q					: 	OUT STD_LOGIC_VECTOR (63 DOWNTO 0) 
		); 
		
	end component; 


	signal mrd: std_logic_vector(63 downto 0) := (others=> '0');





begin

	my_RAM: ram64 port map( clock1 => clk,
									data => store_data,
									func3 => func3,
									write_address => ALU_result,
									read_address => ALU_result,
									we => MemWrite,
									re => MemRead,
									q => mrd
									);
	
	PCsrc <= branch and zero;
	PC_out <= PC;
	
	
	process(clk)

		begin

			if rising_edge(clk) then
				rd_add_o <= rd_add;
				MemtoReg_o <= MemtoReg;
				regWrite_o <= regWrite;
				Result <= ALU_result;
				MemReadData <= mrd;
				

				
			end if;	

	end process;

end rtl;