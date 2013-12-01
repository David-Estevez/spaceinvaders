----------------------------------------------------------------------------------
--
-- Lab session #4: Player
--
-- Block with everything needed for a player
--
--
-- Authors: 
-- David Estévez Fernández
-- Sergio Vilches Expósito
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity player is
    Port ( Right : in  STD_LOGIC;
           Left  : in  STD_LOGIC;
           Start : in  STD_LOGIC;
           Shoot : in  STD_LOGIC;
           clk   : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           Clear : in  STD_LOGIC;
			  hit	  : in  STD_LOGIC;
           posShip      : out  STD_LOGIC_VECTOR (4 downto 0);
           startPulse   : out  STD_LOGIC;
           BulletX      : out  STD_LOGIC_VECTOR (4 downto 0);
           BulletY      : out  STD_LOGIC_VECTOR (3 downto 0);
           BulletActive : out  STD_LOGIC;
           Score        : out  STD_LOGIC_VECTOR (7 downto 0));
end player;

architecture Structural of player is

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
	
	-- Component declaration for button edge detector (without debouncing )
	COMPONENT edgeDetector
	PORT ( 
			clk: in STD_LOGIC;
			reset: in STD_LOGIC;
			enable: in STD_LOGIC;
			input: in STD_LOGIC;
			detected: out STD_LOGIC 
			);
	END COMPONENT;
	
	-- Component declaration for button edge detector (with/ debouncing )
	COMPONENT edgeDetectorDebounce
	PORT ( 
			clk: in STD_LOGIC;
			reset: in STD_LOGIC;
			enable: in STD_LOGIC;
			input: in STD_LOGIC;
			detected: out STD_LOGIC 
			);
	END COMPONENT;
	
	-- Component declaration for bullet shooting control
	COMPONENT bullet
   PORT (
			clk      : in  std_logic;
         reset    : in  std_logic;
         hit      : in  std_logic;
         disparo  : in  std_logic;
         posH     : in  std_logic_vector(4 downto 0);
         flying   : out std_logic;   
         bullX    : out std_logic_vector(4 downto 0);
         bullY    : out std_logic_vector(3 downto 0)
         ); 
	END COMPONENT;
	
	-- Signals to connect things internally
	signal leftDetected: std_logic;
	signal rightDetected: std_logic;
	signal posHBus: std_logic_vector( 4 downto 0);
	
begin
	spaceshipControl: spaceship 
		PORT MAP( 
					clk => clk,
					reset => Reset,
					left => leftDetected,
					right => rightDetected,
					enable => '1',
					posH => posHBus 
					);
				
	leftEdgeDetector: edgeDetectorDebounce
		PORT MAP(
					clk => clk,
					reset => Reset,
					enable => '1',
					input => Left,
					detected => leftDetected
					);
					
	rightEdgeDetector: edgeDetectorDebounce
		PORT MAP(
					clk => clk,
					reset => Reset,
					enable =>  '1',
					input => Right,
					detected => rightDetected
					);
					
	startEdgeDetector: edgeDetectorDebounce
			PORT MAP(
					clk => clk,
					reset => Reset,
					enable =>  '1',
					input => Start,
					detected => startPulse
					);
	
	laserGun: bullet
		PORT MAP(
				clk 		=> clk,
				reset 	=> Reset,
				hit   	=> hit,
				disparo 	=>	Shoot, 
				posH    	=> posHBus,
				flying	=> BulletActive,   
				bullX  	=> BulletX,
				bullY  	=> BulletY
				); 
				
	posShip <= posHBus;
	
	process( clk )
		variable intScore: integer range 0 to 255;
	begin
		if Reset = '1' then
			intScore := 0;
			
		elsif clk'event and clk = '1' then
			-- Erase score
			if clear = '1' then
				intScore := 0;
			
			-- Increase score when alien is hit
			elsif hit = '1' then
				intScore := intScore + 1;
			
			end if;
		end if;
		
		score <= std_logic_vector( to_unsigned( intScore, 8));
	end process;
	
end Structural;

