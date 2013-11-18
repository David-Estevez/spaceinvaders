----------------------------------------------------------------------------------
-- N-BIT COUNTER WITH GENERIC MAXIMUM, ENABLE, COUT AND SYNCHROUNOUS CLEAR
-- Sergio Vilches
-- Counts from 0 to max (included) and then resets to 0
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity counter is
	generic	(  n: integer;
					max: integer );
   port (clk : in  std_logic;
         reset : in  std_logic;
			clear : in std_logic;
			enable: in std_logic;
         count_out : out std_logic_vector (n-1 downto 0);
   		cout : 		out std_logic);
end counter;	


architecture alternate of counter is
begin
	process (reset, clk) 
		variable count: integer range 0 to 2**n - 1;
	begin
		assert (max < 2**n) report "maxCount > counter size" severity error;
		if reset = '1' then 
			count := 0;
		elsif clk'event and clk = '1'	then
		-- Sequential behaviors:
			if clear = '1' then
				count := 0;
			elsif enable = '1' then
				if count = max then
					count := 0;
				else
					count := count + 1;
				end if;
			end if;
		end if; 
		-- Concurrent behaviors:
		
		count_out <= std_logic_vector(to_unsigned(count,n));
		
		if count = max then
			cout <= '1';
			else
			cout <= '0';
		end if;

end process;

end alternate;

--architecture Behavioral of counter is
--	signal count_reg: std_logic_vector(n-1 downto 0);
--begin
--	process (reset, clk) 
--	begin
--		assert (max < 2**n) report "maxCount > counter size" severity error;
--		if reset = '1' then 
--			count_reg <= (count_reg'range => '0');
--		elsif clk'event and clk = '1'	then
--		-- Sequential behaviors:
--			if clear = '1' then
--				count_reg <= (count_reg'range => '0');
--			elsif enable = '1' then
--				if count_reg = std_logic_vector(to_unsigned(max,n)) then
--					count_reg <= (count_reg'range => '0');
--
--				else
--					count_reg <= std_logic_vector( unsigned(count_reg) + 1 );
--				end if;
--			end if;
--		end if; 
--		-- Concurrent behaviors:
--		count_out <= count_reg;
--		
--		if count_reg = std_logic_vector(to_unsigned(max,n)) then
--			cout <= '1';
--			else
--			cout <= '0';
--		end if;
--		
--
--
--end process;
--
--end Behavioral;