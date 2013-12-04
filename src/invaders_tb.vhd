----------------------------------------------------------------------------------
--
-- Lab session #4: Invaders testbech
--
-- Testing the block controlling the space invaders
--
-- Each invader has its power encoded in 2 bits:
-- 	00 -> no invader
--		01 -> easy invader (1 shot) [green]
--		10 -> medium invader (2 shots) [?]
--		11 -> hard invader (3 shots)	[white]
--
-- Authors: 
-- David Estévez Fernández
-- Sergio Vilches Expósito
--
----------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
USE ieee.numeric_std.ALL;
 
ENTITY invaders_tb IS
END invaders_tb;
 
ARCHITECTURE behavior OF invaders_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT invaders
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
			start : in  std_logic;
         bullX : IN  std_logic_vector(4 downto 0);
         bullY : IN  std_logic_vector(3 downto 0);
         hit : OUT  std_logic;
         invArray : INOUT  std_logic_vector(39 downto 0);
         invLine : INOUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
	signal start: std_logic := '0';
   signal bullX : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(10,5));
   signal bullY : std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(10,4));

	--BiDirs
   signal invArray : std_logic_vector(39 downto 0);
   signal invLine : std_logic_vector(3 downto 0);

 	--Outputs
   signal hit : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: invaders PORT MAP (
          clk => clk,
          reset => reset,
			 start => start,
          bullX => bullX,
          bullY => bullY,
          hit => hit,
          invArray => invArray,
          invLine => invLine
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

		wait for 1200 ms;
		
		-- Simulate a bullet:
		bullX <= std_logic_vector(to_unsigned(5,5));
		bullY <= invLine;
		
      wait until hit = '1';
		-- Reset the bullet
		bullX <= std_logic_vector(to_unsigned(0,5)) after clk_period;
		bullY <= std_logic_vector(to_unsigned(0,4)) after clk_period;
	
		wait;
		
   end process;
	

END;
