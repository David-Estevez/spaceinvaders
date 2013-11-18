LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY SpaceInv_tb IS
END SpaceInv_tb;
 
ARCHITECTURE behavior OF SpaceInv_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT SpaceInv
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         Test : IN  std_logic;
         Inicio : IN  std_logic;
         Izquierda : IN  std_logic;
         Derecha : IN  std_logic;
         HSync : OUT  std_logic;
         VSync : OUT  std_logic;
         R : OUT  std_logic;
         G : OUT  std_logic;
         B : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal Test : std_logic := '0';
   signal Inicio : std_logic := '0';
   signal Izquierda : std_logic := '0';
   signal Derecha : std_logic := '0';

 	--Outputs
   signal HSync : std_logic;
   signal VSync : std_logic;
   signal R : std_logic;
   signal G : std_logic;
   signal B : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SpaceInv PORT MAP (
          clk => clk,
          reset => reset,
          Test => Test,
          Inicio => Inicio,
          Izquierda => Izquierda,
          Derecha => Derecha,
          HSync => HSync,
          VSync => VSync,
          R => R,
          G => G,
          B => B
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
		test <= '0';
		reset <= '1';
      wait for 100 ns;	
		reset <= '0';
      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
