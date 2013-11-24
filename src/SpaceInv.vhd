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
		specialScreen: in std_logic_vector( 2 downto 0);
		rgb 	: out std_logic_vector(2 downto 0)
);
	END COMPONENT;
	

	component invaders is
   port (
			clk   : in  std_logic;
         reset : in  std_logic;
			start : in  std_logic;
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
	
	COMPONENT edgeDetectorDebounce
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
	signal specialScreen: STD_LOGIC_VECTOR( 2 downto 0);
	signal hit: STD_LOGIC;
	signal testEnable: STD_LOGIC;
	
	-- Reset lines:
	signal leftDetectorReset: STD_LOGIC;
	signal rightDetectorReset: STD_LOGIC;
	signal invadersReset: STD_LOGIC;
	signal spaceshipReset: STD_LOGIC;
	-- TODO Add shooting reset
	
	-- Inputs to ScreenFormat
	signal invArray: std_logic_vector (19 downto 0);
	signal invLine : std_logic_vector (3 downto 0);
	signal shipX	: std_logic_vector (4 downto 0);
	signal bullX 	: std_logic_vector (4 downto 0) := "11111";  
	signal bullY 	: std_logic_vector (3 downto 0) := "1111";

	-- Output from the edge detectors
	signal leftDetected: STD_LOGIC;
	signal rightDetected: STD_LOGIC;
	
	-- State machine things:
	type State is ( testState, Start, Playing, YouWin, YouLose );
	signal currentState, nextState: State;

begin
	vgaController: vga 
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
					VGAx 				=> X,
					VGAy 				=> Y,
					test 				=> testEnable,
					invArray 		=> invArray,
					invLine 			=> invLine,
					shipX	 			=> shipX,
					bullX 			=> bullX,
					bullY 			=> bullY,
					specialScreen  => specialScreen,
					rgb 	 			=> rgb
					);
	
	badGuys: invaders
		PORT MAP(
					clk => clk,
					reset => invadersReset,
					start => inicio,
					bullX => bullX,
					bullY => bullY,
					hit => hit,
					invArray => invArray,
					invLine => invLine
        			);	
	
	spaceshipControl: spaceship 
		PORT MAP( 
					clk => clk,
					reset => spaceshipReset,
					left => leftDetected,
					right => rightDetected,
					enable => '1',
					posH => shipX 
					);
				
	leftEdgeDetector: edgeDetectorDebounce
		PORT MAP(
					clk => clk,
					reset => leftDetectorReset,
					enable => '1',
					input => Izquierda,
					detected => leftDetected
					);
					
	rightEdgeDetector: edgeDetectorDebounce
		PORT MAP(
					clk => clk,
					reset => rightDetectorReset,
					enable =>  '1',
					input => Derecha,
					detected => rightDetected
					);
					
	-- Process for changing states:
	process( clk, reset)
	begin
		-- Reset
		if reset = '1' then
			currentState <= Start;
		-- Update State
		elsif clk'Event and clk = '1' then
					currentState <= nextState;				
		end if;
	end process;
	
	-- Process for modelling the transitions / outputs 
	-- of the state machine
	process( currentState, Test, Inicio, invArray, invLine, Izquierda, Derecha)
	begin
		nextState <= currentState;
		
			case currentState is
				when testState=> 
					-- Show checkerboard pattern
					-- Set outputs:
					testEnable <= '1';
					specialScreen <= "000";
					leftDetectorReset <= '1';
					rightDetectorReset <= '1';
					invadersReset <= '1';
					spaceshipReset <= '1';
					
					-- Next state:
					if ( Test = '0' ) then
						nextState <= Start;
					end if;
				
				when Start =>
					-- Wait for user to start the game
					-- Set outputs:
					testEnable <= '0';
					specialScreen <= "000";
					leftDetectorReset <= '1';
					rightDetectorReset <= '1';
					invadersReset <= '1';
					spaceshipReset <= '1';
					
					-- Next state:
					if ( Test = '1' ) then
						nextState <= testState;
					elsif ( Inicio = '1' ) then
						nextState <= Playing;
					end if;
				
				when Playing =>
					-- Playing the game
					-- Set outputs:
					testEnable <= '0';
					specialScreen <= "000";
					leftDetectorReset <= '0';
					rightDetectorReset <= '0';
					invadersReset <= '0';
					spaceshipReset <= '0';
					
					-- Next state:
					if ( Test = '1' ) then 
						nextState <= testState;
					elsif ( invArray = "00000000000000000000" ) then
						nextState <= YouWin;
					elsif ( invLine = "1110" ) then
						nextState <= YouLose;
					end if;

				when YouWin =>
					-- Winning screen 
					-- Set outputs:
					testEnable <= '0';
					specialScreen <= "001";
					leftDetectorReset <= '0';
					rightDetectorReset <= '0';
					invadersReset <= '1';
					spaceshipReset <= '1';
					
					-- Next state:
					if ( Test = '1' ) then 
						nextState <= testState;
					elsif ( Izquierda = '1' or Derecha = '1' ) then
						nextState <= Start;
					end if;
					
				when YouLose =>
					-- Losing screen
					-- Set outputs:
					testEnable <= '0';
					specialScreen <= "010";
					leftDetectorReset <= '0';
					rightDetectorReset <= '0';
					invadersReset <= '1';
					spaceshipReset <= '1';
					
					-- Next state:
					if ( Test = '1' ) then
						nextState <= testState;
					elsif ( Izquierda = '1' or Derecha = '1' ) then
						nextState <= Start;
					end if;
			end case;
		end process;
		
end Behavioral;

