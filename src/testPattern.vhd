----------------------------------------------------------------------------------
-- TEST PATTERN
-- Sergio Vilches
-- David Estévez Fernández
-- Checked boxes pattern, BW, 20 x 15
----------------------------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testPattern is
port (
	x : in std_logic_vector (9 downto 0);
	y : in std_logic_vector (9 downto 0);
	rgb : out std_logic_vector(2 downto 0)
);
end testPattern;

architecture behavioral of testPattern is
	-- internal signals
	signal xCell : std_logic_vector (4 downto 0); -- 0 to 19
	signal yCell : std_logic_vector (3 downto 0); -- 0 to 14

begin
	process (x, y)
	begin
		-- Cell calculation
		--xCell <= std_logic_vector(to_unsigned(1,5)); --std_logic_vector(shift_right(unsigned(x),5)) ; -- Division by 32
		--yCell <= std_logic_vector(to_unsigned(0,4));--std_logic_vector(shift_right(unsigned(y),5)) ; -- Division by 32

		-- RGB value
		if (x(5) xor y(5)) = '1' then
			rgb <= "000";
		else
			rgb <= "111"; 
		end if;
	end process;
end behavioral;
