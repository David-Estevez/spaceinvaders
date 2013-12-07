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
    PORT ( 
			  clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  Test: in STD_LOGIC; 	 
           left1, right1, start1, shoot1: in STD_LOGIC;
           left2, right2, start2, shoot2: in STD_LOGIC;			  
			  LED0, LED1, LED2, LED3, LED4, LED5, LED6, LED7: out STD_LOGIC;
			  HSync : out  STD_LOGIC;
           VSync : out  STD_LOGIC;
           R,G,B : out  STD_LOGIC;
           speaker : out std_logic
			);
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal Test : std_logic := '0';
   
	signal start1 : std_logic := '0';
   signal left1 : std_logic := '0';	
   signal right1 : std_logic := '0';
	signal shoot1 : std_logic := '0';
   
	signal start2 : std_logic := '0';
   signal left2 : std_logic := '0';	
   signal right2 : std_logic := '0';
	signal shoot2 : std_logic := '0';
    
	
 	--Outputs
	signal LED0, LED1, LED2, LED3, LED4, LED5, LED6, LED7: STD_LOGIC;
   signal HSync : std_logic;
   signal VSync : std_logic;
   signal R : std_logic;
   signal G : std_logic;
   signal B : std_logic;
   signal speaker : std_logic;
   -- Clock period definitions
   constant clk_period : time := 20 ns;
	constant frame_period: time := 16672 us;

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SpaceInv PORT MAP (
          clk => clk,
          reset => reset,
          Test => Test,
          left1 => left1, right1 => right1, start1 => start1, shoot1 => shoot1,
          left2 => left2, right2 => right2, start2 => start2, shoot2 => shoot2,
			 LED0 => LED0, LED1 => LED1, LED2 => LED2, LED3 => LED3,
			 LED4 => LED4, LED5 => LED5, LED6 => LED6, LED7 => LED7,
          HSync => HSync,
          VSync => VSync,
          R => R,
          G => G,
          B => B,
          speaker => speaker
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
		start1 <= '1';
		wait for frame_period;
		
		-- Wait until aliens kill you (for this you have to setup aliens
		-- on line 13 or otherwise you will likely die waiting for the simulation)
		start1 <= '0';
		
		-- Shoot:
		shoot1 <= '1';
		wait for frame_period;
		shoot1 <= '0';
		
		wait for 130ms;
		
		-- Go to the inicial state again:
		right1 <= '1';
		wait for 2*frame_period;
		

      wait;
   end process;

END;
