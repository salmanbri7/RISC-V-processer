library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Stage_two is

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


end Stage_two;


architecture rtl of Stage_two is

	component control_unit 

		port (

			inst 			: in std_logic_vector(31 downto 0); -- the instruction
			rd_add_haz	: in std_logic_vector(4 downto 0); -- rd of the previous instruction
			rd_add_haz2	: in std_logic_vector(4 downto 0);
			imm			: out std_logic_vector(63 downto 0); -- the immediate number
			Alu_haz1		: out std_logic_vector(1 downto 0); -- if 00 take values from registers elseif 10 rs1 data from result elseif 01 rs2 data from result 
			Alu_haz2		: out std_logic_vector(1 downto 0);
			branch 		: out std_logic;	-- if branch instruction set to '1'
			Alusrc 		: out std_logic;	-- if '0' the ALU sources is rs1 and rs2 / if '1' the source is rs1 and the immediate
			rg_write		: out std_logic;  -- if we need to write in the register set to '1'
			MemWrite 	: out std_logic;	-- if writing to memory needed set to '1' 
			MemRead		: out std_logic;  -- if memory reading needed set to '1'
			MemtoReg 	: out std_logic;  -- if writing data to regs from memory set '1' or from ALU clear to '0'
			Aluop 		: out std_logic_vector(1 downto 0) -- the ALU OP code

		);
		
	end component;
	
	
	component regfile
	
		port (
			clk : in std_logic;
			wr_en : in std_logic;
			rs1 : in std_logic_vector(4 downto 0);
			rs2 : in std_logic_vector(4 downto 0);
			rd_1 : in std_logic_vector(4 downto 0);
			data_in : in std_logic_vector(63 downto 0);
			data_out_1 : out std_logic_vector(63 downto 0);
			data_out_2 : out std_logic_vector(63 downto 0)
		);
		
	end component;

	signal im: std_logic_vector(63 downto 0) := (others=> '0');
	signal br: std_logic := '0';
	signal alsrc: std_logic := '0';
	signal rg_wr: std_logic := '0';
	signal Memwr: std_logic := '0';
	signal Memrd: std_logic := '0';
	signal Memreg: std_logic := '0';
	signal alop: std_logic_vector(1 downto 0) := "00";
	signal AluHaz1: std_logic_vector(1 downto 0) := "00";
	signal AluHaz2: std_logic_vector(1 downto 0) := "00";
	signal Data_out_1: std_logic_vector(63 downto 0) := (others=> '0');
	signal Data_out_2: std_logic_vector(63 downto 0) := (others=> '0');



begin

	mt_control: control_unit port map( 	inst => instruction,
													rd_add_haz => rd_add_haz,
													rd_add_haz2	=> rd_add_haz2,
													imm => im,
													Alu_haz1 => AluHaz1,
													Alu_haz2 => AluHaz2,
													branch => br,
													Alusrc => alsrc,
													rg_write => rg_wr,
													MemWrite => Memwr,
													MemRead => Memrd,
													MemtoReg => Memreg,
													Aluop => alop
													);
													
	my_regs: regfile port map( 	clk => clk,
											wr_en => regWrite,
											rs1 => instruction(19 downto 15),
											rs2 => instruction(24 downto 20),
											rd_1 => WriteReg,
											data_in => WriteData,
											data_out_1 => Data_out_1,
											data_out_2 => Data_out_2
											);



	process(clk)

		begin

			if rising_edge(clk) then
				rs1_data <= Data_out_1;
				rs2_data <= Data_out_2;
				
				imm <= im;
				Alu_haz1 <= AluHaz1;
				Alu_haz2 <= AluHaz2;
				regWrite_o <=	rg_wr;
				branch <= br;
				MemtoReg <= Memreg;
				MemRead <= Memrd;
				MemWrite	<= Memwr;
				Alusrc <= alsrc;
				Aluop	<= alop;
				instruction_out <= instruction;
				PC_out <= PC;

				
			end if;	

	end process;

end rtl;