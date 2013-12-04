----------------------------------------------------------------------------------
--
-- Lab session #4: screenFormat testbench
--
-- Testing the screenFormat block
--
-- Authors: 
-- David Estévez Fernández
-- Sergio Vilches Expósito
--
----------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.all;
 
ENTITY screenFormat_tb IS
END screenFormat_tb;
 
ARCHITECTURE behavior OF screenFormat_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT screenFormat
    PORT(
         VGAx : IN  std_logic_vector(9 downto 0);
         VGAy : IN  std_logic_vector(9 downto 0);
         test : IN  std_logic;
         invArray : IN  std_logic_vector(39 downto 0);
         invLine : IN  std_logic_vector(3 downto 0);
         shipX : IN  std_logic_vector(4 downto 0);
         bullX : IN  std_logic_vector(4 downto 0);
         bullY : IN  std_logic_vector(3 downto 0);
         bulletFlying : IN  std_logic;
         specialScreen : IN  std_logic_vector(2 downto 0);
         rgb : OUT  std_logic_vector(2 downto 0)
        );
    END COMPONENT;

	 -- Component Declaration for the vga controller
    COMPONENT vga
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         RGB : IN  std_logic_vector(2 downto 0);
         HSync : OUT  std_logic;
         VSync : OUT  std_logic;
         R : OUT  std_logic;
         G : OUT  std_logic;
         B : OUT  std_logic;
         X : OUT  std_logic_vector(9 downto 0);
         Y : OUT  std_logic_vector(9 downto 0)
        );
    END COMPONENT;
    
	--Inputs
	signal clk : std_logic := '0';
   signal reset : std_logic := '0';
	
   signal test : std_logic := '0';
   signal invArray : std_logic_vector(39 downto 0) := (others => '0');
   signal invLine : std_logic_vector(3 downto 0) := (others => '0');
   signal shipX : std_logic_vector(4 downto 0) := (others => '0');
   signal bullX : std_logic_vector(4 downto 0) := (others => '0');
   signal bullY : std_logic_vector(3 downto 0) := (others => '0');
   signal bulletFlying : std_logic := '0';
   signal specialScreen : std_logic_vector(2 downto 0) := (others => '0');
   
	-- Interface signals
   signal RGB : std_logic_vector(2 downto 0);
	signal X : std_logic_vector(9 downto 0);
   signal Y : std_logic_vector(9 downto 0);
	
	signal VGAx : std_logic_vector(9 downto 0) := (others => '0');
   signal VGAy : std_logic_vector(9 downto 0) := (others => '0');



 	--Outputs
   signal HSync : std_logic;
   signal VSync : std_logic;
   signal R : std_logic;
   signal G : std_logic;
   signal B : std_logic;


   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: screenFormat PORT MAP (
          VGAx => X,
          VGAy => Y,
          test => test,
          invArray => invArray,
          invLine => invLine,
          shipX => shipX,
          bullX => bullX,
          bullY => bullY,
          bulletFlying => bulletFlying,
          specialScreen => specialScreen,
          rgb => rgb
        );
		  
	vgaController: vga PORT MAP (
          clk => clk,
          reset => reset,
          RGB => rgb,
          HSync => HSync,
          VSync => VSync,
          R => R,
          G => G,
          B => B,
          X => X,
          Y => Y
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
      reset <= '1';
      wait for 100 ns;	
      reset <= '0';
		
		-- Define screen state:
		test <= '0';
		invArray <= "0000000000000000000001111111101010010101";
		invLine <= std_logic_vector(to_unsigned(0,4));
		shipX <= std_logic_vector(to_unsigned(9,5));
		bullX <= std_logic_vector(to_unsigned(11,5));
		bullY <= std_logic_vector(to_unsigned(0,4));
		bulletFlying <= '1';
		specialScreen <= "000";
      
		wait;
		
   end process;
	
--	counter: process
--		variable intX : integer range 31 to 0 := 0;
--		variable intY : integer range 31 to 0 := 0;
--	begin
--			if intX = 31 then
--				intX := 0;
--				if intY = 31 then
--					intY := 0;
--				else
--					intY := intY +1;
--				end if;
--			else
--				intX := intX +1;
--			end if;
--			
--			VGAx <= std_logic_vector(to_unsigned( intX, 10));
--			VGAy <= std_logic_vector(to_unsigned( intY, 10));
--			
--			wait for clk_period;
--	end process;


END;
