LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY toneGenerator_tb IS
END toneGenerator_tb;
 
ARCHITECTURE behavior OF toneGenerator_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT toneGenerator
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         a : IN  std_logic;
         b : IN  std_logic;
         c : IN  std_logic;
         d : IN  std_logic;
         q : INOUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal a : std_logic := '0';
   signal b : std_logic := '0';
   signal c : std_logic := '0';
   signal d : std_logic := '0';

	--BiDirs
   signal q : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: toneGenerator PORT MAP (
          clk => clk,
          reset => reset,
          a => a,
          b => b,
          c => c,
          d => d,
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
      wait for clk_period*10;
		a <= '1';
      wait for clk_period;
		a <= '0';
		wait for 500 ms;	
		b <= '1';
      wait for clk_period;
		b <= '0';

      wait;
   end process;

END;
