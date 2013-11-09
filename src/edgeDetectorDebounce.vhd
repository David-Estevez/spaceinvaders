----------------------------------------------------------------------------------
--
-- Lab session #2: edge detector with debounce integrated
--
-- Detects raising edges and ouputs a one-period pulse from a physical switch.
--
-- Authors: 
-- David Estévez Fernández
-- Sergio Vilches Expósito
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity edgeDetectorDebounce is
	generic( debounceTime: time := 1ms );
	port( clk: in STD_LOGIC;
		  reset: in STD_LOGIC;
		  enable: in STD_LOGIC;
		  input: in STD_LOGIC;
		  detected: out STD_LOGIC );
end edgeDetectorDebounce;

architecture Behavioral of edgeDetectorDebounce is
	-- Description of the states:
	-- Not detected: edge not detected, input is '0'
	-- Edge detected: edge detection
	-- Disabled: state transition will not be possible
	--			    until timer timeout, to avoid bouncing
	-- Waiting: timer timeout has ocurred, but the input
	--				is still '1'. It will remain here until
	--				the input is '0'
	type State is ( notDetected, edgeDetected, Disabled, waiting );
	signal currentState, nextState: State;
	signal counterEnabled: std_logic;
	signal timeout: std_logic;

	component timer is
		generic  (  t: time := 1 ms);
		port (clk   : in  std_logic;
				reset : in  std_logic;
				en    : in  std_logic;
				q     : out std_logic);
	end component;   

begin
	-- Instantiate the timer:
	tim0 : timer generic map ( t => debounceTime ) 
					 port map ( clk => clk, 
									reset => reset, 
									en => counterEnabled, 
									q => timeout );
	
	-- Process for changing states:
	process( clk, reset)
	begin
		-- Reset
		if reset = '0' then
			currentState <= notDetected;
		-- Update State
		elsif clk'Event and clk = '1' then
			if enable = '1' then
					currentState <= nextState;				
			end if;
		end if;
	end process;
	
	
	-- Process for modelling the transitions / outputs 
	-- of the state machine
	process( currentState, input, timeout )
	begin
		nextState <= currentState;
		
		case currentState is
			when notDetected => 
				-- Set outputs 
				detected <= '0';
				counterEnabled <= '0';
				
				-- Define transitions
				if input = '0' then
					nextState <= notDetected;
				else
					nextState <= edgeDetected;
				end if;
				
			when edgeDetected =>
				-- Set outputs
				detected <= '1';
				counterEnabled <= '0';
				
				-- Define transitions
				nextState <= Disabled;
			
			when Disabled =>
				-- Set outputs
				detected <= '0';
				counterEnabled <= '1';
				
				-- Define transitions
				if timeout = '1' then
					if input = '0' then
						nextState <= notDetected;
					else
						nextState <= waiting;
					end if;
				else
						nextState <= Disabled;
				end if;
				
			when waiting =>
				-- Set outputs
				detected <= '0';
				counterEnabled <= '0';
				
				-- Define transitions
				if input = '0' then
					nextState <= notDetected;
				else
					nextState <= waiting;
				end if;
			end case;
		end process;

end Behavioral;
