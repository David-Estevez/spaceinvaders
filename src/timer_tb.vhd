LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY timer_tb IS
END timer_tb;
 
ARCHITECTURE behavior OF timer_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT timer
	 generic	(t: time);
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         clear : IN  std_logic;
			start : IN  std_logic;
         q : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal clear : std_logic := '0';
	signal start : std_logic := '0';

 	--Outputs
   signal q : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: timer
			generic map (10 us)
			PORT MAP (
          clk => clk,
          reset => reset,
          clear => clear,
          start => start,
			 q => q
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		reset <= '1';
      wait for 100 ns;	
		reset <= '0';
		start <= '1';
      wait for clk_period;
		start <= '0';
		wait for 200 ns;
		clear <= '1';
		wait for clk_period;
		clear <= '0';
		wait for 200 ns;
		start <= '1';
      wait for clk_period;
		start <= '0';
		

      -- insert stimulus here 

      wait;
   end process;

END;
