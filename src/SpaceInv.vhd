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
			  Disparo: in STD_LOGIC;
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
		invArray: in std_logic_vector (39 downto 0);
		invLine : in std_logic_vector (3 downto 0);
		shipX	: in std_logic_vector (4 downto 0);
		bullX 	: in std_logic_vector (4 downto 0);  
		bullY 	: in std_logic_vector (3 downto 0);
		bulletFlying: in std_logic;
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
         invArray : inout std_logic_vector(39 downto 0);
			invLine   : inout std_logic_vector(3 downto 0)
         ); 
	end component;   

	component player is
   port ( 
			  Right : in  STD_LOGIC;
           Left  : in  STD_LOGIC;
           Start : in  STD_LOGIC;
           Shoot : in  STD_LOGIC;
           clk   : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           Clear : in  STD_LOGIC;
			  hit   : in  STD_LOGIC;
           posShip      : out  STD_LOGIC_VECTOR (4 downto 0);
           startPulse   : out  STD_LOGIC;
           BulletX      : out  STD_LOGIC_VECTOR (4 downto 0);
           BulletY      : out  STD_LOGIC_VECTOR (3 downto 0);
           BulletActive : out  STD_LOGIC;
           Score        : out  STD_LOGIC_VECTOR (7 downto 0)
			  );
	end component;
	
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
	signal bulletReset: STD_LOGIC;
	
	-- Inputs to ScreenFormat
	signal invArray: std_logic_vector (39 downto 0);
	signal invLine : std_logic_vector (3 downto 0);
	
	-- Player 1 signals:
	signal startPulse: STD_LOGIC;
	signal posH	: std_logic_vector (4 downto 0);
	signal bullX 	: std_logic_vector (4 downto 0) := "11111";  
	signal bullY 	: std_logic_vector (3 downto 0) := "1111";
	signal bulletFlying  : std_logic;
	signal Score:  STD_LOGIC_VECTOR (7 downto 0);
	
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
					shipX	 			=> posH,
					bullX 			=> bullX,
					bullY 			=> bullY,
					bulletFlying   => bulletFlying,
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
	
	player1: player
	   PORT MAP ( 
			  Right => Derecha,
           Left  => Izquierda,
           Start => Inicio,
           Shoot => Disparo,
           clk   => clk,
           Reset => reset,
           Clear => '0',
			  hit => hit,
           posShip => posH,
           startPulse => startPulse,
           BulletX    => bullX,
           BulletY    => bullY,
           BulletActive => bulletFlying,
           Score        => Score
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
					bulletReset <= '1';
					
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
					bulletReset <= '1';
					
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
					bulletReset <= '0';
					
					-- Next state:
					if ( Test = '1' ) then 
						nextState <= testState;
					elsif ( invArray = "0000000000000000000000000000000000000000" ) then
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
					bulletReset <= '1';
										
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
					bulletReset <= '1';
					
					-- Next state:
					if ( Test = '1' ) then
						nextState <= testState;
					elsif ( Izquierda = '1' or Derecha = '1' ) then
						nextState <= Start;
					end if;
			end case;
		end process;
		
end Behavioral;

