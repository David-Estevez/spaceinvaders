----------------------------------------------------------------------------------
--
-- Lab session #2: Space Invaders
--
----------------------------------------------------------------------------------
-- Top level entity for the Space Invaders vga controller
-- Authors: David Estevez Fernandez
--				Sergio Vilches Exposito
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SpaceInv is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  Test: in STD_LOGIC; 	 
			  Inicio: in STD_LOGIC; 
           Izquierda, Derecha: in STD_LOGIC;
			  HSync : out  STD_LOGIC;
           VSync : out  STD_LOGIC;
           R,G,B : out  STD_LOGIC
);
end SpaceInv;

architecture Behavioral of SpaceInv is

	 -- Component declaration for vga controller:
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

	-- Compoment declaration for screen format:
	COMPONENT screenFormat
	PORT (
		VGAx 	: in std_logic_vector (9 downto 0);
		VGAy 	: in std_logic_vector (9 downto 0);
		test 	: in std_logic;
		invArray: in std_logic_vector (19 downto 0);
		invLine : in std_logic_vector (3 downto 0);
		shipX	: in std_logic_vector (4 downto 0);
		bullX 	: in std_logic_vector (4 downto 0);  
		bullY 	: in std_logic_vector (3 downto 0);
		rgb 	: out std_logic_vector(2 downto 0)
);
	END COMPONENT;
	

	component invaders is
   port (clk   : in  std_logic;
         reset : in  std_logic;
         bullX : in  std_logic_vector(4 downto 0);
         bullY : in  std_logic_vector(3 downto 0);
         hit   : out std_logic;
         invArray : inout std_logic_vector(19 downto 0);
			invLine   : inout std_logic_vector(3 downto 0)
         ); 
	end component;   

	-- Component declaration for player spaceship control block:
	COMPONENT spaceship
	PORT (  
			clk : in STD_LOGIC;
			reset : in  STD_LOGIC;
         left : in  STD_LOGIC;
         right : in  STD_LOGIC;
         enable : in  STD_LOGIC;
         posH : out  STD_LOGIC_VECTOR (4 downto 0)
		  );
	END COMPONENT;
	
	-- Component declaration for button edge detector (with/without debouncing )
	COMPONENT edgeDetector
	PORT ( 
			clk: in STD_LOGIC;
			reset: in STD_LOGIC;
			enable: in STD_LOGIC;
			input: in STD_LOGIC;
			detected: out STD_LOGIC 
			);
	END COMPONENT;
	
	-- Internal signals
	signal RGB: STD_LOGIC_VECTOR (2 downto 0);
	signal X, Y: STD_LOGIC_VECTOR (9 downto 0);
	signal hit: STD_LOGIC;
	
	-- Inputs to ScreenFormat
	signal invArray: std_logic_vector (19 downto 0);
	signal invLine : std_logic_vector (3 downto 0);
	signal shipX	: std_logic_vector (4 downto 0);
	signal bullX 	: std_logic_vector (4 downto 0) := "11111";  
	signal bullY 	: std_logic_vector (3 downto 0) := "1111";

	-- Output from the edge detectors
	signal leftDetected: STD_LOGIC;
	signal rightDetected: STD_LOGIC;

begin
   checkerboard: formatoVGA 
		PORT MAP( 
					RGB => RGB, 
					X => X, 
					Y => Y, 
					Test => Test
					);
					
	vgaController: entity work.vga(Simulation)
		PORT MAP( 
					clk => clk, 
					reset => reset, 
					RGB => RGB, 
					HSync => HSync, 
					VSync => VSync, 
					R => R, 
					G => G, 
					B => B, 
					X => X, 
					Y => Y 
					);

	framebuffer: screenFormat
		PORT MAP(
					VGAx 		=> X,
					VGAy 		=> Y,
					test 		=> test,
					invArray => invArray,
					invLine 	=> invLine,
					shipX	 	=> shipX,
					bullX 	=> bullX,
					bullY 	=> bullY,
					rgb 	 	=> rgb
					);
	
	badGuys: invaders
		PORT MAP(
					clk => clk,
					reset => reset,
					bullX => bullX,
					bullY => bullY,
					hit => hit,
					invArray => invArray,
					invLine => invLine
        			);	
	
	spaceshipControl: spaceship 
		PORT MAP( 
					clk => clk,
					reset => clk,
					left => leftDetected,
					right => rightDetected,
					enable => '1',
					posH => shipX 
					);
				
	leftEdgeDetector: edgeDetector
		PORT MAP(
					clk => clk,
					reset => reset,
					enable => '1',
					input => Izquierda,
					detected => leftDetected
					);
					
	rightEdgeDetector: edgeDetector
		PORT MAP(
					clk => clk,
					reset => reset,
					enable => '1',
					input => Derecha,
					detected => rightDetected
					);
end Behavioral;

