Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU is 
    Port (A 		: in std_logic_vector(63 downto 0);
          B 		: in std_logic_vector(63 downto 0);
          OP 		: in std_logic_vector(3 downto 0);
          Result 	: out std_logic_vector(63 downto 0);
          zero 	: out std_logic
     );
            
end ALU;

architecture behavioral of ALU is 

	signal R : std_logic_vector(63 downto 0) :=(others => '0');
	
begin 
        process(op,A,B,R)
        begin
				zero <= '0'; --default value
            if op= "0000" then 
                R<= (others => '0');
                
            elsif op ="0001" then 
                R<= not a;
                
            elsif op ="0010" then 
                R<= a+b;     
                
            elsif op ="0011" then 
                R<= a and b; 
                
            elsif op ="0100" then 
                R<= a or b; 
                 
            elsif op ="0101" then 
                R<= a  xor b; 
                
            elsif op ="0110" then 
                R<= a-b;

                if R = "0000000000000000000000000000000000000000000000000000000000000000" then
                    Zero <='1';
                end if;

            elsif op ="0111" then 
                R<= a-b;

                if R /= "0000000000000000000000000000000000000000000000000000000000000000" then
                    Zero <='1';
                end if;

            elsif op ="1000" then 
                R<= a-b;

                Zero <= not R(63);
            
            elsif op ="1001" then 
                R<= a-b;
                Zero <=  R(63);

            else 
                R<= (others => '1');
            end if;
            
            
            result <= R;
        end process;
        
        
end behavioral;