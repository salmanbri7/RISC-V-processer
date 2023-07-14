library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ALU_Control is

port 

(

instruction : in std_logic_vector(3 downto 0);
ALUop : in std_logic_vector(1 downto 0);
ALUcontrol : out std_logic_vector(3 downto 0)

);


end ALU_Control;


architecture rtl of ALU_Control is
begin

process(instruction,ALUop)

begin

ALUcontrol <= "0000"; -- default value

if ALUop = "00" then -- immediate 
    if instruction(2 downto 0) = "000" then --addi instruction
    ALUcontrol <= "0010"; -- add
    elsif instruction(2 downto 0) = "110" then --ori instruction
    ALUcontrol <= "0100"; --or
    elsif instruction(2 downto 0) = "111" then -- andi instruction
    ALUcontrol <= "0011"; -- and 
    end if;
    
    
    
elsif ALUop = "01" then -- branch  instructions
    if instruction(2 downto 0) = "000" then --beq instruction
        ALUcontrol <= "0110"; -- sub, 
    elsif instruction(2 downto 0) = "001" then --bne instruction
        ALUcontrol <= "0111"; -- bne sub
    elsif instruction(2 downto 0) = "101" then --bge instruction
        ALUcontrol <= "1000"; -- bge sub
    elsif instruction(2 downto 0) = "100" then --blt instruction
        ALUcontrol <= "1001"; -- blt sub
    end if;

elsif ALUop = "10" then -- alu (R) instructions
    if instruction = "0000" then -- add instruction
        ALUcontrol <= "0010";    --add
    elsif instruction  = "1000" then -- subinstruction
        ALUcontrol <= "0110";    --sub
    elsif instruction = "0111" then --and instruction
        ALUcontrol <= "0011"; -- and
    elsif instruction = "0110" then -- or instruction
       ALUcontrol <= "0100"; -- or
    end if;
	 
elsif ALUop = "11" then -- load & store instructions

    ALUcontrol <= "0010"; -- add
    
    

end if;

end process;

end rtl;