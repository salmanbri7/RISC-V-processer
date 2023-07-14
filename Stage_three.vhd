library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Stage_three is

port 

(

	clk 			: in std_logic;
	imm 			: in std_logic_vector(63 downto 0);
	PC				: in std_logic_vector(63 downto 0);
	rs1_data		: in std_logic_vector(63 downto 0);
	rs2_data		: in std_logic_vector(63 downto 0);
	regWrite		: in std_logic;
	branch		: in std_logic;
	MemtoReg		: in std_logic;
	MemRead		: in std_logic;
	MemWrite		: in std_logic;
	Alusrc		: in std_logic;
	Aluop			: in std_logic_vector(1 downto 0);
	instruction : in std_logic_vector(31 downto 0);
	Alu_haz1		: in std_logic_vector(1 downto 0);
	Alu_haz2		: in std_logic_vector(1 downto 0);
	AluRes_haz	: in std_logic_vector(63 downto 0);
	AluRes_haz2	: in std_logic_vector(63 downto 0);
	
	rd_add	 	: out std_logic_vector(4 downto 0);
	store_data	: out std_logic_vector(63 downto 0);
	PC_out 		: out std_logic_vector(63 downto 0);
	ALU_result	: out std_logic_vector(63 downto 0);
	func3			: out std_logic_vector(2 downto 0);
	MemRead_o	: out std_logic;
	MemWrite_o	: out std_logic;
	branch_o		: out std_logic;
	MemtoReg_o	: out std_logic;
	regWrite_o	: out std_logic;
	zero		 	: out std_logic
	

);


end Stage_three;


architecture rtl of Stage_three is

	component ALU 
	
		Port (A 		: in std_logic_vector(63 downto 0);
				B 		: in std_logic_vector(63 downto 0);
				OP 		: in std_logic_vector(3 downto 0);
				Result 	: out std_logic_vector(63 downto 0);
				zero 	: out std_logic
			);
		
	end component;
	
	
	component ALU_Control is

		port 

		(
	
			instruction : in std_logic_vector(3 downto 0);
			ALUop : in std_logic_vector(1 downto 0);
			ALUcontrol : out std_logic_vector(3 downto 0)

		);
		
	end component;


	signal data_2: std_logic_vector(63 downto 0) := (others=> '0');
	signal data_1: std_logic_vector(63 downto 0) := (others=> '0');
	signal op_alu: std_logic_vector(3 downto 0) := (others=> '0');
	signal rs_data: std_logic_vector(63 downto 0) := (others=> '0');
	signal zr: std_logic := '0';
	signal PC_new: std_logic_vector(63 downto 0) := (others=> '0');
	signal temp: std_logic_vector(3 downto 0):= (others=> '0');
	signal haz: std_logic_vector(1 downto 0):= (others=> '0');





begin
	temp <= instruction(30)&instruction(14 downto 12);
	my_ALU: ALU port map( 	A => data_1,
									B => data_2,
									OP => op_alu,
									Result => rs_data,
									zero => zr
									);
													
	my_alu_control: ALU_Control port map( 	instruction => temp,
														ALUop => Aluop,
														Alucontrol => op_alu
													);

	
	haz <= Alu_haz1 or Alu_haz2;
	
	process(Alusrc,imm,PC,rs2_data,haz,Alu_haz1,Alu_haz2)
		begin
					data_2 <= rs2_data;
					data_1 <= rs1_data;
					
			if haz = "00" then
				if Alusrc ='1' then
					data_2 <= imm;
					data_1 <= rs1_data;
				else
					data_2 <= rs2_data;
					data_1 <= rs1_data;
				end if;
			else										-- R type hazard sitiuations
				if Alu_haz1(0) = '1' then
					data_2 <= AluRes_haz;
				elsif Alu_haz2(0) = '1' then
					data_2 <= AluRes_haz2;
				end if;
				
				if Alu_haz1(1) = '1' then
					data_1 <= AluRes_haz;			
				elsif Alu_haz2(1) = '1' then
					data_1 <= AluRes_haz2;
				end if;
			end if;
			
			PC_new <= std_logic_vector(unsigned(PC) + unsigned(imm));
	end process;

	process(clk)

		begin

			if rising_edge(clk) then
				zero <= zr;
				rd_add <= instruction(11 downto 7);
				store_data <= rs2_data;
				PC_out <= Pc_new;
				ALU_result <= rs_data;
				MemRead_o <= MemRead;
				MemWrite_o <= MemWrite;
				branch_o <= branch;
				MemtoReg_o <= MemtoReg;
				regWrite_o <= regWrite;
				func3 <= instruction(14 downto 12);

				
			end if;	

	end process;

end rtl;