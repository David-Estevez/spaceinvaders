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
         bullX : IN  std_logic_vector(4 downto 0);
         bullY : IN  std_logic_vector(3 downto 0);
         hit : OUT  std_logic;
         invArray : INOUT  std_logic_vector(19 downto 0);
         invLine : INOUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal bullX : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(10,5));
   signal bullY : std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(10,4));

	--BiDirs
   signal invArray : std_logic_vector(19 downto 0);
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

      -- insert stimulus here 
      wait;
   end process;
	
	process (hit)
	begin
		if hit = '1' then
			bullX <= std_logic_vector(to_unsigned(0,5)) after clk_period;
			bullY <= std_logic_vector(to_unsigned(0,4)) after clk_period;
		end if;
	end process;
	

END;
