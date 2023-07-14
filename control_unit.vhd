library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is

	port (

		inst 			: in std_logic_vector(31 downto 0); -- the instruction
		rd_add_haz	: in std_logic_vector(4 downto 0); -- rd of the previous instruction
		rd_add_haz2	: in std_logic_vector(4 downto 0); -- rd of the previous previous instruction
		imm			: out std_logic_vector(63 downto 0); -- the immediate number
		Alu_haz1		: out std_logic_vector(1 downto 0); -- if 00 take values from registers elseif 10 rs1 data from result elseif 01 rs2 data from result 
		Alu_haz2		: out std_logic_vector(1 downto 0); -- if 00 take values from registers elseif 10 rs1 data from result elseif 01 rs2 data from result 		
		branch 		: out std_logic;	-- if branch instruction set to '1'
		Alusrc 		: out std_logic;	-- if '0' the ALU sources is rs1 and rs2 / if '1' the source is rs1 and the immediate
		rg_write		: out std_logic;  -- if we need to write in the register set to '1'
		MemWrite 	: out std_logic;	-- if writing to memory needed set to '1' 
		MemRead		: out std_logic;  -- if memory reading needed set to '1'
		MemtoReg 	: out std_logic;  -- if writing data to regs from memory set '1' or from ALU clear to '0'
		Aluop 		: out std_logic_vector(1 downto 0) -- the ALU OP code

	);

  

end entity;



architecture rtl of control_unit is

	signal opcode : std_logic_vector(6 downto 0);

begin



opcode <= inst(6 downto 0);

process(inst,opcode)

	begin
	
		imm <= ( others => '0'); --default values
		branch <= '0';
		rg_write <= '0';
		Alusrc <= '0';
		Memwrite<='0';
		MemtoReg<='0';
		ALuop <= "00";
		Memread<='0';
		Alu_haz1 <= "00";
		Alu_haz2 <= "00";
		
		
		if opcode = "0000011" then -- load instructions (I)
			imm <= std_logic_vector(resize(signed(inst(31 downto 20)), imm'length));
			branch <= '0';
			rg_write <= '1';
			Alusrc <= '1';
			Memwrite<='0';
			MemtoReg<='1';
			ALuop <= "11";
			Memread<='1';
			Alu_haz1 <= "00";
			Alu_haz2 <= "00";
			
			

		elsif opcode = "0010011" then -- imediate instructions (I)
			imm <= std_logic_vector(resize(signed(inst(31 downto 20)), imm'length));
			branch <= '0';
			rg_write <= '1';
			Alusrc <= '1';
			Memwrite<='0';
			MemtoReg<='0';
			ALuop <= "00";
			Memread<='1';
			Alu_haz1 <= "00";
			Alu_haz2 <= "00";



		elsif opcode = "0110011" then -- alu instructions (R)
			branch <= '0';
			rg_write <= '1';
			Alusrc <= '0';
			MemWrite <= '0';
			MemRead <= '0';
			MemtoReg <= '0';
			ALuop <= "10";
			
			Alu_haz1 <= "00";
			if rd_add_haz = inst(19 downto 15) then
				Alu_haz1(1) <= '1';
			end if;
			if rd_add_haz = inst(24 downto 20) then
				Alu_haz1(0) <= '1';
			
			end if;
			
			Alu_haz2 <= "00";
			if rd_add_haz2 = inst(19 downto 15) then
				Alu_haz2(1) <= '1';
			end if;
			if rd_add_haz2 = inst(24 downto 20) then
				Alu_haz2(0) <= '1';
			
			end if;


		elsif opcode = "1100011" then -- branch instructions (SB)
			imm <= std_logic_vector(resize(signed(inst(31)&inst(7)&inst(30 downto 25)&inst(11 downto 8)&'0'), imm'length));
			branch <= '1';
			rg_write <= '0';
			Alusrc <= '0';
			Memwrite<='0';
			MemtoReg<='0';
			ALuop <= "01";
			Memread<='0';
			Alu_haz1 <= "00";
			Alu_haz2 <= "00";

			

		elsif opcode = "0100011" then -- store instructions (S)
			imm <= std_logic_vector(resize(signed(inst(31 downto 25)&inst(11 downto 7)), imm'length));
			branch <= '0';
			rg_write <= '0';
			Alusrc <= '1';
			Memwrite<='1';
			MemtoReg<='0';
			ALuop <= "11";
			Memread<='0';
			Alu_haz1 <= "00";
			Alu_haz2 <= "00";

			
		
--		elsif opcode = "1100111" then -- jump and link register instruction (I)
--			imm <= std_logic_vector(resize(signed(inst(31 downto 0)), imm'length));
--			branch <= '1';
--			rg_write <= '1';
--			Alusrc <= '1';
--
--
--			
--				
--		elsif opcode = "1101111" then -- jump and link instruction (UJ)
--			imm <= std_logic_vector(resize(signed(inst(31)&inst(19 downto 12)&inst(20)&inst(30 downto 21)&'0'), imm'length));
--			branch <= '1';
--			rg_write <= '0';
--			Alusrc <= '1';




		end if;

	end process;
end rtl;