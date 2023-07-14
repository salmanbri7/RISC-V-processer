library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regfile is
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
end regfile;

architecture rtl of regfile is

	type reg_array is array(0 to 31) of std_logic_vector(63 downto 0);
	signal regs : reg_array := (x"0000000000000000", x"FFDEAB5678963202", x"0000000000000003", x"0000000000000000",
          others => (others => '0'));
	
begin

	process(clk)
		begin
		if rising_edge(clk) then
			if wr_en = '1' then
				regs(to_integer(unsigned(rd_1))) <= data_in;
			end if;
		end if;
	end process;
	
data_out_1 <= regs(to_integer(unsigned(rs1)));
data_out_2 <= regs(to_integer(unsigned(rs2)));

end rtl;