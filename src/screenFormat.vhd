----------------------------------------------------------------------------------
-- Screen Format
-- Sergio Vilches
----------------------------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity screenFormat is
port (
	VGAx 	: in std_logic_vector (9 downto 0);
	VGAy 	: in std_logic_vector (9 downto 0);
	test 	: in std_logic;
	invArray: in std_logic_vector (19 downto 0);
	invLine : in std_logic_vector (3 downto 0);
	shipX	: in std_logic_vector (4 downto 0);
	bullX 	: in std_logic_vector (4 downto 0);  
	bullY 	: in std_logic_vector (3 downto 0);
	bulletFlying: in std_logic;
	specialScreen: in std_logic_vector( 2 downto 0);
	rgb 	: out std_logic_vector(2 downto 0)
);
end screenFormat;

architecture behavioral of screenFormat is
	-- macropixels
	signal x : std_logic_vector (4 downto 0); -- 0 to 19
	signal y : std_logic_vector (3 downto 0); -- 0 to 14

begin
	process (VGAx, VGAy) -- Conversion to macropixels
	begin
		x <= VGAx(9 downto 5);
		y <= VGAy(8 downto 5);
	end process;

	process (x,y,test)
	begin
		if test = '1' then -- Show checked pattern
			if (x(0) xor y(0)) = '1' then
				rgb <= "000";
			else
				rgb <= "111"; 
			end if;
		else
			case specialScreen is
				when "000" =>
					-- No special screen (show game)
					------------------------------------
					-- Show bullet in red
					if bulletFlying = '1' and (x = bullX) and (y = bullY) then
						rgb <= "100";
					-- Show ship in blue		
					elsif (x = shipX) and (y = std_logic_vector(to_unsigned(14,4))) then
						rgb <= "001";
					-- Show invaders in green	
					elsif (invArray(to_integer(unsigned(x))) = '1') and (y = invLine) then
						rgb <= "010";
					else
						rgb <= "000";
					end if ;
					
				when "001" =>
					-- You win screen
					-------------------------------------
					rgb <= "100"; -- Temporarily red
					
				when "010" =>
					-- You lose screen
					-------------------------------------
					rgb <= "001"; -- Temporarily blue
					
				when others =>
					rgb <= "XXX"; -- Indicate error
				
			end case;
		end if ;
	end process;
end behavioral;
