library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity CPU is

	port 

	(
		clk 	:  in std_logic
	);


end entity;


architecture rtl of CPU is

	component Stage_one
	port 
		(
		clk 			: in std_logic;
		branch 		: in std_logic;
		newPC			: in std_logic_vector(63 downto 0);
		PC_out		: out std_logic_vector(63 downto 0);
		instruction : out std_logic_vector(31 downto 0)
	);
	end component;

	
	component Stage_two 
	port 
	(
		clk 			: in std_logic;
		regWrite 	: in std_logic;
		instruction : in std_logic_vector(31 downto 0);
		PC 			: in std_logic_vector(63 downto 0);
		WriteReg		: in std_logic_vector(4 downto 0);
		WriteData 	: in std_logic_vector(63 downto 0);
		rd_add_haz	: in std_logic_vector(4 downto 0);
		rd_add_haz2	: in std_logic_vector(4 downto 0);
		
		imm 			: out std_logic_vector(63 downto 0);
		PC_out		: out std_logic_vector(63 downto 0);
		rs1_data		: out std_logic_vector(63 downto 0);
		rs2_data		: out std_logic_vector(63 downto 0);
		Alu_haz1		: out std_logic_vector(1 downto 0);
		Alu_haz2		: out std_logic_vector(1 downto 0);
		regWrite_o	: out std_logic;
		branch		: out std_logic;
		MemtoReg		: out std_logic;
		MemRead		: out std_logic;
		MemWrite		: out std_logic;
		Alusrc		: out std_logic;
		Aluop			: out std_logic_vector(1 downto 0);
		instruction_out : out std_logic_vector(31 downto 0)
	);
	end component;

	component Stage_three
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
	end component;


	component Stage_four
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
	end component;
	

		signal imm1				: std_logic_vector(63 downto 0) := (others=> '0');
		signal RgWrData		: std_logic_vector(63 downto 0) := (others=> '0');
		signal PC1				: std_logic_vector(63 downto 0) := (others=> '0');
		signal PC2				: std_logic_vector(63 downto 0) := (others=> '0');
		signal PC3				: std_logic_vector(63 downto 0) := (others=> '0');
		signal PC4				: std_logic_vector(63 downto 0) := (others=> '0');
		signal inst1			: std_logic_vector(31 downto 0) := (others=> '0');
		signal inst2			: std_logic_vector(31 downto 0) := (others=> '0');
		signal Rs1				: std_logic_vector(63 downto 0) := (others=> '0');
		signal Rs2				: std_logic_vector(63 downto 0) := (others=> '0');
		signal StoreData		: std_logic_vector(63 downto 0) := (others=> '0');
		signal AluRes			: std_logic_vector(63 downto 0) := (others=> '0');
		signal MemReadData	: std_logic_vector(63 downto 0) := (others=> '0');
		signal AluResData		: std_logic_vector(63 downto 0) := (others=> '0');


		signal rd_add1			: std_logic_vector(4 downto 0) := (others=> '0');
		signal rd_add2			: std_logic_vector(4 downto 0) := (others=> '0');

		
		signal fun3				: std_logic_vector(2 downto 0) := (others=> '0');

		
		signal ALUop			: std_logic_vector(1 downto 0) := (others=> '0');
		signal AluHaz1			: std_logic_vector(1 downto 0) := (others=> '0');		
		signal AluHaz2			: std_logic_vector(1 downto 0) := (others=> '0');		

		
		signal PCsrc			: std_logic := '0';
		signal reg_w1			: std_logic := '0';
		signal reg_w2			: std_logic := '0';
		signal reg_w3			: std_logic := '0';
		signal branch1			: std_logic := '0';
		signal branch2			: std_logic := '0';
		signal MemtoReg1		: std_logic := '0';
		signal MemtoReg2		: std_logic := '0';
		signal MemtoReg3		: std_logic := '0';
		signal MemRd1			: std_logic := '0';
		signal MemRd2			: std_logic := '0';
		signal MemWr1			: std_logic := '0';
		signal MemWr2			: std_logic := '0';
		signal Alusrc			: std_logic := '0';
		signal zer				: std_logic := '0';
		
		
		

begin

	stg1: Stage_one port map( 				clk => clk,
													branch => PCsrc,
													newPC => PC4,
													
													PC_out => PC1,
													instruction => inst1
													);
													
	stg2: Stage_two port map( 				clk => clk,
													regWrite => reg_w3,
													instruction => inst1,
													PC => PC1,
													WriteReg	=> rd_add2,
													WriteData => RgWrData,
													rd_add_haz => inst2(11 downto 7),
													rd_add_haz2	=> rd_add1,
													Alu_haz1 => AluHaz1,
													Alu_haz2 => AluHaz2,
													imm => imm1,
													PC_out => PC2,
													rs1_data	=> Rs1,
													rs2_data	=> Rs2,
													
													regWrite_o => reg_w1,
													branch => branch1,
													MemtoReg	=> MemtoReg1,
													MemRead => MemRd1,
													MemWrite	=> MemWr1,
													Alusrc => Alusrc,
													Aluop	=> ALUop,
													instruction_out => inst2
													);
													
	stg3: Stage_three port map( 			clk => clk,
													imm => imm1,
													PC	=> PC2,
													rs1_data	=> Rs1,
													rs2_data	=> Rs2,
													regWrite =>	reg_w1,
													branch => branch1,
													MemtoReg	=> MemtoReg1,
													MemRead => MemRd1,
													MemWrite	=> MemWr1,
													Alusrc => Alusrc,
													Aluop	=> ALUop,
													instruction => inst2,
													Alu_haz1 => AluHaz1,
													Alu_haz2 => AluHaz2,
													AluRes_haz => AluRes,
													AluRes_haz2 => AluResData,
													
													rd_add => rd_add1,
													store_data	=> StoreData,
													PC_out => PC3,
													ALU_result => AluRes,
													func3	=> fun3,
													MemRead_o => MemRd2,
													MemWrite_o => MemWr2,
													branch_o	=> branch2,
													MemtoReg_o => MemtoReg2,
													regWrite_o => reg_w2,
													zero => zer
													);		
											
									
									
	stg4: Stage_four port map( 			clk => clk,
													PC	=> PC3,
													store_data => StoreData,
													regWrite	=> reg_w2,
													branch => branch2,
													MemtoReg	=> MemtoReg2,
													MemRead => MemRd2,
													MemWrite	=> MemWr2,
													zero => zer,
													ALU_result => AluRes,
													rd_add => rd_add1,
													func3	=> fun3,
													
													rd_add_o	=> rd_add2,
													PC_out => PC4,
													Result => AluResData,
													MemReadData => MemReadData,
													PCsrc	=> PCsrc,
													MemtoReg_o => MemtoReg3,
													regWrite_o => reg_w3
													);
													
													
	process(MemtoReg3,AluResData,MemReadData,clk)
	begin 
	
	if MemtoReg3 = '0' then
		RgWrData <= AluResData;
	else
		RgWrData <= MemReadData;
	end if;
	
	end process;
	



end rtl;