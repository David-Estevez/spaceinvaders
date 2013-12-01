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
			Disparo: IN std_logic;
			LED0, LED1, LED2, LED3, LED4, LED5, LED6, LED7: out STD_LOGIC;
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
	signal Disparo : std_logic := '0';

 	--Outputs
	signal LED0, LED1, LED2, LED3, LED4, LED5, LED6, LED7: STD_LOGIC;
   signal HSync : std_logic;
   signal VSync : std_logic;
   signal R : std_logic;
   signal G : std_logic;
   signal B : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
	constant frame_period: time := 16672 us;

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SpaceInv PORT MAP (
          clk => clk,
          reset => reset,
          Test => Test,
          Inicio => Inicio,
          Izquierda => Izquierda,
          Derecha => Derecha,
			 Disparo => Disparo,
			 LED0 => LED0, LED1 => LED1, LED2 => LED2, LED3 => LED3,
			 LED4 => LED4, LED5 => LED5, LED6 => LED6, LED7 => LED7,
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

      -- Go to 'test' state
		test <= '1';
		wait for frame_period;
		
		-- Go to 'start' state:
		test <= '0';
		wait for frame_period;
		
		-- Start the game:
		Inicio <= '1';
		wait for frame_period;
		
		-- Wait until aliens kill you (for this you have to setup aliens
		-- on line 13 or otherwise you will likely die waiting for the simulation)
		Inicio <= '0';
		
		-- Shoot:
		Disparo <= '1';
		wait for frame_period;
		Disparo <= '0';
		
		wait for 130ms;
		
		-- Go to the inicial state again:
		Derecha <= '1';
		wait for 2*frame_period;
		

      wait;
   end process;

END;
