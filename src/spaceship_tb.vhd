----------------------------------------------------------------------------------
--
-- Lab session #2: ship control testbench
--
-- Control the user spaceship
--
-- Authors: 
-- David Estévez Fernández
-- Sergio Vilches Expósito
--
----------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY spaceship_tb IS
END spaceship_tb;
 
ARCHITECTURE behavior OF spaceship_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT spaceship
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         left : IN  std_logic;
         right : IN  std_logic;
         enable : IN  std_logic;
         posH : OUT  std_logic_vector(4 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal left : std_logic := '0';
   signal right : std_logic := '0';
   signal enable : std_logic := '0';

 	--Outputs
   signal posH : std_logic_vector(4 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: spaceship PORT MAP (
          clk => clk,
          reset => reset,
          left => left,
          right => right,
          enable => enable,
          posH => posH
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
      reset <= '0';
      wait for 100 ns;	
		reset <= '1';
		enable <= '1'; -- without this enabled obviously it doesn't work
      wait for clk_period*2;

      left <= '1';
		wait for clk_period*10;
		
		left <= '0';
		right <= '1';
		wait for clk_period*20;
		
		left <= '1';
		right <= '0';
		wait for clk_period*10;
		
		left <= '0';
		
		
      wait;
   end process;

END;
