----------------------------------------------------------------------------------
--
-- Lab session #2: edge detector testbench
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

entity edgeDetector_tb is
end edgeDetector_tb;

architecture Behavioral of edgeDetector_tb is

	-- Declare component:
	component edgeDetector
	port( 
		 clk: in STD_LOGIC;
		 reset: in STD_LOGIC;
		 enable: in STD_LOGIC;
		 input: in STD_LOGIC;
		 detected: out STD_LOGIC 
		 );
	end component;
	
	-- Inputs
	signal clk: std_logic := '0';
	signal reset: std_logic := '0';
	signal enable: std_logic := '0';
	signal input: std_logic := '0';
	
	-- Outputs
	signal detected: std_logic;
	
	-- clk period
	constant clk_period: time := 10 ns;
	
begin

	-- Instantiation of edgeDetector:
	uut: edgeDetector 
	port map(
			 clk => clk,
			 reset => reset,
			 enable => enable,
		 	 input => input,
	 		 detected => detected
			);
			
	-- Clock signal
	clk_process : process
	begin
		clk <= '0';
		wait for clk_period / 2;
		clk <= '1';
		wait for clk_period / 2;
	end process;
	
	-- Other stimulus
	stim_process : process
	begin
		-- Reset circuit:
		reset <= '0';
		wait for 80 ns;
		reset <= '1';
		wait for 20 ns;
		
		-- Test circuit with enable disabled:
		enable <= '0';
		input <= '0';
		wait for clk_period;
		input <= '1';
		wait for clk_period;
		input <= '0';
		wait for clk_period;
		
		-- Test circuit with enable enabled:
		enable <= '1';
		wait for 2*clk_period;
		input <= '1';
		wait for 2*clk_period;
		input <= '0';
		wait for 2*clk_period;
		
		-- Test circuit with enable disabled again:
		enable <= '0';
		input <= '1';
		wait for 3*clk_period;
		input <= '0';
		wait for clk_period;
		
		wait;
	end process;
end Behavioral;
