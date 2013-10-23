----------------------------------------------------------------------------------
--
-- Lab session #1: vga format
--
----------------------------------------------------------------------------------
-- Tests the vga controller with a checkerboard pattern
--
-- Author: David Estévez Fernández
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity formatoVGA is
    Port ( RGB : out  STD_LOGIC_VECTOR (2 downto 0);
           X : in  STD_LOGIC_VECTOR (9 downto 0);
           Y : in  STD_LOGIC_VECTOR (9 downto 0);
			  Test: in STD_LOGIC);
end formatoVGA;

architecture Behavioral of formatoVGA is
begin
		process( X, Y)
		begin	
			if Test = '0' then
				if std_logic(X(5) xor Y(5)) = '0' then
					RGB <= "000";
				else
					RGB <= "111";
				end if;
			else
				-- Alien
				if X(5) = '1' and Y < std_logic_vector( to_unsigned( 32, 10)) then
					RGB <= "100";
				elsif   (X > std_logic_vector( to_unsigned( 319, 10))) 
					and  (X < std_logic_vector( to_unsigned( 351, 10)))
					and  (Y > std_logic_vector( to_unsigned( 416, 10))) 
					and  (Y > std_logic_vector( to_unsigned( 445, 10)))then
						RGB <= "010";
				elsif X > std_logic_vector( to_unsigned( 319, 10)) 
				and X < std_logic_vector( to_unsigned( 351, 10))  
				and Y > std_logic_vector( to_unsigned( 446, 10)) then
						RGB <= "001";
				else
					RGB <= "000";
				end if;
				
			end if;
		end process;
end Behavioral;

