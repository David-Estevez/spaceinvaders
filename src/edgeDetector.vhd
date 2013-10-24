----------------------------------------------------------------------------------
--
-- Lab session #2: edge detector
--
-- Detects raising edges and ouputs a one-period pulse.
--
-- Authors: 
-- David Estévez Fernández
-- Sergio Vilches Expósito
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity edgeDetector is
	port( clk: in STD_LOGIC;
		  reset: in STD_LOGIC;
		  enable: in STD_LOGIC;
		  input: in STD_LOGIC;
		  detected: out STD_LOGIC );
end edgeDetector;

architecture Behavioral of edgeDetector is
begin
	process( clk, reset)
		variable currentState: STD_LOGIC;
		variable previousState: STD_LOGIC;
	begin
		-- Reset
		if reset = '0' then
			currentState := '0';
			previousState := '0';
			detected <= '0';
			
		-- Synchronous behaviour
		elsif clk'Event and clk = '1' then
			if enable = '1' then
			
				-- Update states
				previousState := currentState;
				currentState := input;
				
				-- If the current state is high, and the previous state was low,
				-- an edge has arrived:
				detected <= currentState and not previousState;
				
			end if;
		end if;
	end process;

end Behavioral;
