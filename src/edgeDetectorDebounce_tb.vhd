----------------------------------------------------------------------------------
--
-- Lab session #2: edge detector debounce testbench
--
-- Detects raising edges and ouputs a one-period pulse.
--
-- Authors: 
-- David Estévez Fernández
-- Sergio Vilches Expósito
--
----------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY edgeDetectorDebounce_tb IS
END edgeDetectorDebounce_tb;
 
ARCHITECTURE behavior OF edgeDetectorDebounce_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT edgeDetectorDebounce
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         enable : IN  std_logic;
         input : IN  std_logic;
         detected : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal enable : std_logic := '0';
   signal input : std_logic := '0';

 	--Outputs
   signal detected : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: edgeDetectorDebounce PORT MAP (
          clk => clk,
          reset => reset,
          enable => enable,
          input => input,
          detected => detected
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
	-- Reset
	reset <= '0', '1' after 100ns;
	enable <= '0', '1' after 200ns;
	
	-- Other stimulus
	stim_process : process
	begin
			wait for 15*clk_period;
			input <= '1';
			wait for 3*clk_period;
			input <= '0';
			wait for 5*clk_period;
			input <= '1';
			wait for clk_period;
			input <= '0';
			wait for clk_period;
			input <= '1';
			wait for clk_period;
			input <= '0';
			wait for clk_period;
			input <= '1';
			wait for clk_period;
			input <= '0';
			wait for clk_period;			
			input <= '1';
			wait for clk_period;
			input <= '1';
			wait for 1ms;
			input <= '0';
			wait for 5*clk_period;
			input <= '1';
			wait for clk_period;
			input <= '0';
			wait for clk_period;
			input <= '1';
			wait for clk_period;
			input <= '0';
			wait for clk_period;
			input <= '1';
			wait for clk_period;
			input <= '0';
			wait for clk_period;			
			input <= '1';
		wait;
	end process;
END;
