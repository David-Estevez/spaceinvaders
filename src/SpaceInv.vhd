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
use IEEE.NUMERIC_STD.ALL;

entity SpaceInv is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  Test: in STD_LOGIC; 	 
           left1, right1, start1, shoot1: in STD_LOGIC;
           left2, right2, start2, shoot2: in STD_LOGIC;			  
			  LED0, LED1, LED2, LED3, LED4, LED5, LED6, LED7: out STD_LOGIC;
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
		shipX1	: in std_logic_vector (4 downto 0);
		bullX1 	: in std_logic_vector (4 downto 0);  
		bullY1 	: in std_logic_vector (3 downto 0);
		bulletFlying1: in std_logic;
		player2shown : in std_logic;
		shipX2	: in std_logic_vector (4 downto 0);
		bullX2 	: in std_logic_vector (4 downto 0);  
		bullY2 	: in std_logic_vector (3 downto 0);
		bulletFlying2: in std_logic;
		specialScreen: in std_logic_vector( 2 downto 0);
		rgb 	: out std_logic_vector(2 downto 0)
);
	END COMPONENT;
	

	component invaders is
   port (
			clk   : in  std_logic;
         reset : in  std_logic;
			clear : in  std_logic;
			start : in  std_logic;
         bullX1 : in  std_logic_vector(4 downto 0);
         bullY1 : in  std_logic_vector(3 downto 0);
         hit1   : out std_logic;
			bullX2 : in  std_logic_vector(4 downto 0);
         bullY2 : in  std_logic_vector(3 downto 0);
         hit2   : out std_logic;
         invArray : inout std_logic_vector(39 downto 0);
			invLine   : inout std_logic_vector(3 downto 0);
			level  : in  std_logic_vector( 2 downto 0 )
         ); 
	end component;   

	-- Declaration of component player
	component player is
   port ( 
				-- User controls
			  Right : in  STD_LOGIC;
           Left  : in  STD_LOGIC;
           Start : in  STD_LOGIC;
           Shoot : in  STD_LOGIC;
			  
			  -- Control signals
           clk      	 : in  STD_LOGIC;
           Reset 		 : in  STD_LOGIC;
           Clear 		 : in  STD_LOGIC;
			  ScoreClear : in STD_LOGIC;
			  Enable		 : in  STD_LOGIC;
			  
			  -- Internal signals
			  hit	  			: in  STD_LOGIC;
           posShip      : out  STD_LOGIC_VECTOR (4 downto 0);
           startPulse   : out  STD_LOGIC;
           BulletX      : out  STD_LOGIC_VECTOR (4 downto 0);
           BulletY      : out  STD_LOGIC_VECTOR (3 downto 0);
           BulletActive : out  STD_LOGIC;
           Score        : out  STD_LOGIC_VECTOR (7 downto 0)
		  );
	end component;
	
	
	-- Clear lines:
	----------------------------------------------------
	signal player1Clear: STD_LOGIC;
	signal p1ScoreClear: STD_LOGIC;
	signal player2Clear: STD_LOGIC;
	signal p2ScoreClear: STD_LOGIC;
	signal invadersClear: STD_LOGIC;
	
	-- Inputs to ScreenFormat
	----------------------------------------------------
	signal RGB: STD_LOGIC_VECTOR (2 downto 0);
	signal X, Y: STD_LOGIC_VECTOR (9 downto 0);
	signal specialScreen: STD_LOGIC_VECTOR( 2 downto 0);
	signal testEnable: STD_LOGIC;
	signal invArray: std_logic_vector (39 downto 0);
	signal invLine : std_logic_vector (3 downto 0);
	
	-- Invaders trigger:
	----------------------------------------------------
	signal invadersStart: STD_LOGIC;
	
	-- Player 1 signals:
	----------------------------------------------------
	-- User control signals
	signal p1right: std_logic;
	signal p1left: std_logic;
	signal p1start: std_logic;
	signal p1shoot: std_logic;
	signal p1enable: std_logic;
	
	-- Internal signals
	signal p1startPulse: std_logic;
	signal p1posH	: std_logic_vector (4 downto 0);
	signal p1hit : std_logic;
	signal p1bullX 	: std_logic_vector (4 downto 0);  
	signal p1bullY 	: std_logic_vector (3 downto 0);
	signal p1bulletFlying  : std_logic;
	signal p1Score:  std_logic_vector (7 downto 0);
	
	-- Player 2 signals
	---------------------------------------------------
	-- User control signals	
	signal p2right: std_logic;
	signal p2left: std_logic;
	signal p2start: std_logic;
	signal p2shoot: std_logic;
	signal p2enable: std_logic;
	
	-- Internal signals
	signal p2startPulse: std_logic;
	signal p2posH	: std_logic_vector (4 downto 0);
	signal p2hit : std_logic;
	signal p2bullX 	: std_logic_vector (4 downto 0);  
	signal p2bullY 	: std_logic_vector (3 downto 0);
	signal p2bulletFlying  : std_logic;
	signal p2Score:  std_logic_vector (7 downto 0);
	
	-- State machine things:
	------------------------------------------------------
	type State is ( testState, Start, Playing, YouWin, YouLose, WinGame );
	signal currentState, nextState: State;
	
	-- Level control:
	------------------------------------------------------
	signal level: std_logic_vector( 2 downto 0 );
	signal levelClear: std_logic;
	signal levelUp: std_logic;

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
					shipX1	 		=> p1posH,
					bullX1 			=> p1bullX,
					bullY1 			=> p1bullY,
					bulletFlying1  => p1bulletFlying,
					player2shown   => '1',
					shipX2	 		=> p2posH,
					bullX2 			=> p2bullX,
					bullY2 			=> p2bullY,
					bulletFlying2  => p2bulletFlying,
					specialScreen  => specialScreen,
					rgb 	 			=> rgb
					);
	
	badGuys: invaders
		PORT MAP(
					clk => clk,
					reset => Reset,
					Clear => invadersClear,
					start => invadersStart,
					bullX1 => p1bullX,
					bullY1 => p1bullY,
					hit1 => p1hit,
					bullX2 => p2bullX,
					bullY2 => p2bullY,
					hit2 => p2hit,
					invArray => invArray,
					invLine => invLine,
					level => level
        			);	
	
	player1: player
	   PORT MAP ( 
			  Right => p1right,
           Left  => p1left,
           Start => p1start,
           Shoot => p1shoot,
           clk   => clk,
           Reset => reset,
           Clear => player1Clear,
			  ScoreClear => p1ScoreClear,
			  Enable => p1Enable,
			  hit => p1hit,
           posShip => p1posH,
           startPulse => p1startPulse,
           BulletX    => p1bullX,
           BulletY    => p1bullY,
           BulletActive => p1bulletFlying,
           Score        => p1Score
			  );
			  
	player2: player
	   PORT MAP ( 
			  Right => p2right,
           Left  => p2left,
           Start => p2start,
           Shoot => p2shoot,
           clk   => clk,
           Reset => reset,
           Clear => player2Clear,
			  ScoreClear => p2ScoreClear,
			  Enable => p2Enable,
			  hit => p2hit,
           posShip => p2posH,
           startPulse => p2startPulse,
           BulletX    => p2bullX,
           BulletY    => p2bullY,
           BulletActive => p2bulletFlying,
           Score        => p2Score
			  );
   
	-- Linking external I/O lines with players:
	p1right <= right1;
	p1left <= left1;
	p1start <= start1;
	p1shoot <= shoot1;
	
	p2right <= right2;
	p2left <= left2;
	p2start <= start2;
	p2shoot <= shoot2;
	
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
	process( currentState, Test, invArray, invLine, p1startPulse, p2startPulse, level)
	begin
		nextState <= currentState;
		
			case currentState is
				when testState=> 
					-- Show checkerboard pattern
					-- Set outputs:
					-----------------------------
					-- Special signals
					testEnable <= '1';
					specialScreen <= "000";
					-- Invaders signals
					invadersClear <= '1';
					invadersStart <= '0';
					-- Player signals
					p1Enable <= '0';
					player1Clear <= '1';
					player2Clear <= '1';
					-- Level control
					levelUp <= '0';
					
					-- Next state:
					if ( Test = '0' ) then
						nextState <= Start;
					else
						nextState <= currentState;
					end if;
				
				when Start =>
					-- Wait for user to start the game
					-- Set outputs:
					-----------------------------
					-- Special signals
					testEnable <= '0';
					specialScreen <= "000";
					-- Invaders signals
					invadersClear <= '1';
					invadersStart <= '0';
					-- Player signals
					p1Enable <= '0';
					player1Clear <= '1';
					player2Clear <= '1';
					-- Level control
					levelUp <= '0';
					
					-- Next state:
					if ( Test = '1' ) then
						nextState <= testState;
					elsif ( p1startPulse = '1' ) then 
						nextState <= Playing;
					else
						nextState <= currentState;
					end if;
				
				when Playing =>
					-- Playing the game
					-- Set outputs:
					-----------------------------
					-- Special signals
					testEnable <= '0';
					specialScreen <= "000";
					-- Invaders signals
					invadersClear <= '0';
					invadersStart <= '1';
					-- Player signals
					p1Enable <= '1';
					player1Clear <= '0';
					player2Clear <= '0';
					-- Level control
					levelUp <= '0';

					
					-- Next state:
					if ( Test = '1' ) then 
						nextState <= testState;
					elsif ( invArray = "0000000000000000000000000000000000000000" ) then
						nextState <= YouWin;
					elsif ( invLine = "1110" ) then
						nextState <= YouLose;
					else
						nextState <= currentState;
					end if;

				when YouWin =>
					-- Winning screen 
					-- Set outputs:
					-----------------------------
					-- Special signals
					testEnable <= '0';
					specialScreen <= "001";
					-- Invaders signals
					invadersClear <= '1';
					invadersStart <= '0';
					-- Player signals
					p1Enable <= '0';
					player1Clear <= '0';
					player2Clear <= '0';
					-- Level control
					levelUp <= '1';

					-- Next state:
					if ( Test = '1' ) then 
						nextState <= testState;
					elsif ( (p1startPulse = '1') or (p2startPulse = '1')) and (level = "111" ) then
						nextState <= WinGame;
					elsif ( p1startPulse = '1') or (p2startPulse = '1') then
						nextState <= Start;
					else
						nextState <= currentState;
					end if;
					
				when YouLose =>
					-- Losing screen
					-- Set outputs:
					-----------------------------
					-- Special signals
					testEnable <= '0';
					specialScreen <= "010";
					-- Invaders signals
					invadersClear <= '1';
					invadersStart <= '0';
					-- Player signals
					p1Enable <= '0';
					player1Clear <= '0';
					player2Clear <= '0';
					-- Level control
					levelUp <= '0';
					
					-- Next state:
					if ( Test = '1' ) then
						nextState <= testState;
					elsif ( p1startPulse = '1') or (p2startPulse = '1') then
						nextState <= Start;
					else
						nextState <= currentState;
					end if;
					
				when WinGame =>
					-- Win game screen
					-- Set outputs:
					-----------------------------
					-- Special signals
					testEnable <= '0';
					specialScreen <= "011";
					-- Invaders signals
					invadersClear <= '1';
					invadersStart <= '0';
					-- Player signals
					p1Enable <= '0';
					player1Clear <= '0';
					player2Clear <= '0';
					-- Level control
					levelUp <= '0';
					
					-- Next state:
					if ( Test = '1' ) then
						nextState <= testState;
					elsif ( p1startPulse = '1') or (p2startPulse = '1') then
						nextState <= Start;
					else
						nextState <= currentState;
					end if;				
			end case;
		end process;
		
		-- Score and level clear control:
		process( nextState )
		begin
			if nextState = Start and currentState /= YouWin then
					p1ScoreClear <= '1';
					p2ScoreClear <= '1';
					levelClear <= '1';
			else
					p1ScoreClear <= '0';
					p2ScoreClear <= '0';
					levelClear <= '0';
			end if;
		end process;
		
		-- Latch for the player 2 enable signal
		process( clk, Reset)
		begin
			if Reset = '1' then
				p2Enable <= '0';
			elsif clk'event and clk = '1' then
				-- Player 2 enable:
				-------------------------------------------------------------------------------------------------------
				-- Enable player 2 if p2start is pressed on start screen
				if ( currentState = Start ) and (p2startPulse = '1') then
						p2Enable <= '1';
						
				-- Disable player 2 when game is lost
				elsif ( currentState = YouLose or  currentState = WinGame ) and (p1startPulse = '1' or p2startPulse = '1') then
						p2Enable <= '0';
				end if;
			end if;
		end process;

		-- Process controlling the level
		process( clk, Reset)
			variable intLevel : integer range 0 to 7;
			variable previousLevelUp: std_logic;
		begin
			-- Counter for the level (counts edges)
			-- Reset
			if  Reset = '1' then
				intLevel := 0;
				previousLevelUp := '0';
				
			elsif clk'event and clk = '1' then
				-- Clear
				if levelClear = '1' then
					intLevel := 0;
				-- Up counter
				elsif levelUp = '1' and previousLevelUp = '0' and intLevel /= 7 then
					intLevel := intLevel + 1;
				end if;
				
				-- Store the last value
				previousLevelUp := levelUp;
				
			end if;
			
			level <= std_logic_vector( to_unsigned( intLevel, 3));
		end process;
			

		-- Show score on the leds:
		LED0 <= p1score(0);
		LED1 <= p1score(1);
		LED2 <= p1score(2);
		LED3 <= p1score(3);
		LED4 <= p1score(4);
		LED5 <= p1score(5);
		LED6 <= p1score(6);
		LED7 <= p1score(7);
		
end Behavioral;

