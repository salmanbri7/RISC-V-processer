Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity ALU_REG is

	Port (
		A_ad : in integer range 0 to 3;
		B_ad : in integer range 0 to 3;
		WB_ad : in integer range 0 to 3;
		oper : in std_logic_vector (2 downto 0);
		Clk : in std_logic;
		wr_en : in std_logic;
 
		Rout : out std_logic_vector(7 downto 0));
 
end ALU_REG;

architecture Behavioral of ALU_REG is
	type reg is array(3 downto 0) of std_logic_vector(7 downto 0);
	--signal my_reg: reg:=("11111111", "00000000", "11110000", "00001111");
	signal WB: std_logic_vector(7 downto 0) := "00000000";
	signal A: std_logic_vector(7 downto 0) := "00000000";
	signal B: std_logic_vector(7 downto 0) := "00000000";

	component ALU 
	Port (A : in std_logic_vector(7 downto 0);
			B : in std_logic_vector(7 downto 0);
			OP : in std_logic_vector(2 downto 0);
			R : out std_logic_vector(7 downto 0));
			
	end component;
	
	component regfile
	port (clk, wr_en : in std_logic;
			A_ad, B_ad, WB_ad : in integer range 0 to 3;
			WB : in std_logic_vector(7 downto 0);
			A, B : out std_logic_vector(7 downto 0));
	end component;
	
begin

Rout <= WB;

Alu1: ALU port map(A => A,
						B => B,
						OP => oper,
						R => WB);

regfile1: regfile port map (	clk => clk,
								wr_en => wr_en,
								A_ad => A_Ad,
								B_ad => B_ad,
								WB_ad => WB_ad,
								WB => WB,
								A => A,
								B => B);
								


end Behavioral;