----------------------------------------------------------------------------------
--
-- Lab session #4: screenFormat
--
-- Send the screen elements to the VGA controller
--
-- Authors: 
-- David Estévez Fernández
-- Sergio Vilches Expósito
--
----------------------------------------------------------------------------------

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity screenFormat is
port (
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
end screenFormat;

architecture behavioral of screenFormat is
	-- macropixels
	signal x : std_logic_vector (4 downto 0); -- 0 to 19
	signal y : std_logic_vector (3 downto 0); -- 0 to 14

	-- game sprites:
	type sprite is array( 0 to 31, 0 to 31) of std_logic; 
	
	CONSTANT alien1: sprite := ( 
													"00000000000000000000000000000000",
													"00000000000000000000000000000000",
													"00000000000000000000000000000000",
													"00000000000000000000000000000000",
													"00000000000000000000000000000000",	
													"00000000000000000000000000000000",
													"00000000000000000000000000000000",
													"00000000000000000000000000000000",
													"00000000011000000000011000000000",
													"00000000011000000000011000000000",
													"00000000000110000001100000000000",
													"00000000000110000001100000000000",																										
													"00000000011111111111111000000000",
													"00000000011111111111111000000000",
													"00000001111001111110011110000000",
													"00000001111001111110011110000000",
													"00000111111111111111111111100000",	
													"00000111111111111111111111100000",	
													"00000110011111111111111001100000",
													"00000110011111111111111001100000",
													"00000110011000000000011001100000",
													"00000110011000000000011001100000",
													"00000000000111100111100000000000",													
													"00000000000111100111100000000000",
													"00000000000000000000000000000000",
													"00000000000000000000000000000000",
													"00000000000000000000000000000000",
													"00000000000000000000000000000000",
													"00000000000000000000000000000000",	
													"00000000000000000000000000000000",
													"00000000000000000000000000000000",
													"00000000000000000000000000000000"														
												   );
									
	CONSTANT ship_sprite: sprite := ( 
													"00000000000000011000000000000000",
													"00000000000000011000000000000000",
													"00000000000000011000000000000000",
													"00000000000000011000000000000000",
													"00000000000001111110000000000000",
													"00000000000001111110000000000000",
													"00000000000001111110000000000000",
													"00000000000001111110000000000000",
													"00000001100001111110000110000000",	
													"00000001100001111110000110000000",
													"00000001100001111110000110000000",	
													"00000001100001111110000110000000",													
													"00000001100111111111100110000000",
													"00000001100111111111100110000000",													
													"00000001111111100111111110000000",
													"00000001111111100111111110000000",													
													"01100001111110000001111110000110",
													"01100001111110000001111110000110",													
													"01100001111110011001111110000110",
													"01100001111110011001111110000110",													
													"01100001111111111111111110000110",
													"01100001111111111111111110000110",													
													"01100111111111111111111111100110",
													"01100111111111111111111111100110",													
													"01111111111111111111111111111110",	
													"01111111111111111111111111111110",														
													"01111110011111111111111001111110",
													"01111110011111111111111001111110",													
													"01111000011110011001111000011110",
													"01111000011110011001111000011110",													
													"01100000000000011000000000000110",
													"01100000000000011000000000000110"
												   );

	CONSTANT funny_bullet: sprite := ( 
													"00000000000000111100000000000000",
													"00000000000001011110000000000000",
													"00000000000010101111000000000000",
													"00000000000110001111100000000000",	
													"00000000001111111111110000000000",
													"00000000001111110011110000000000",
													"00000000011111110001111000000000",
													"00000000011111100001111000000000",
													"00000000011111110001111000000000",
													"00000000011111100001111000000000",
													"00000000011111100011111000000000",
													"00000000011111110011111000000000",
													"00000000011111111111111000000000",
													"00000000000000000000000000000000",													
													"00000000010111111111111000000000",	
													"00000000010111111111111000000000",														
													"00000000000000000000000000000000",
													"00000000000000000000000000000000",
													"00000000000000000000000000000000",
													"00000000000000000000000000000000",	
													"00000000000000000000000000000000",
													"00000000000000000000000000000000",
													"00000000000000000000000000000000",
													"00000000000000000000000000000000",
													"00000000000000000000000000000000",
													"00000000000000000000000000000000",
													"00000000000000000000000000000000",
													"00000000000000000000000000000000",	
													"00000000000000000000000000000000",
													"00000000000000000000000000000000",
													"00000000000000000000000000000000",
													"00000000000000000000000000000000"
												   );
-- Template:									
--	signal alien1: sprite := ( 
--													"00000000000000000000000000000000",
--													"00000000000000000000000000000000",
--													"00000000000000000000000000000000",
--													"00000000000000000000000000000000",	
--													"00000000000000000000000000000000",
--													"00000000000000000000000000000000",
--													"00000000000000000000000000000000",
--													"00000000000000000000000000000000",
--													"00000000000000000000000000000000",
--													"00000000000000000000000000000000",
--													"00000000000000000000000000000000",
--													"00000000000000000000000000000000",	
--													"00000000000000000000000000000000",
--													"00000000000000000000000000000000",
--													"00000000000000000000000000000000",
--													"00000000000000000000000000000000",
--													"00000000000000000000000000000000",
--													"00000000000000000000000000000000",
--													"00000000000000000000000000000000",
--													"00000000000000000000000000000000",	
--													"00000000000000000000000000000000",
--													"00000000000000000000000000000000",
--													"00000000000000000000000000000000",
--													"00000000000000000000000000000000",
--													"00000000000000000000000000000000",
--													"00000000000000000000000000000000",
--													"00000000000000000000000000000000",
--													"00000000000000000000000000000000",	
--													"00000000000000000000000000000000",
--													"00000000000000000000000000000000",
--													"00000000000000000000000000000000",
--													"00000000000000000000000000000000"
--												   );

	-- Define colors as constants:
	CONSTANT BLACK   : STD_LOGIC_VECTOR( 2 DOWNTO 0) := "000";
	CONSTANT BLUE    : STD_LOGIC_VECTOR( 2 DOWNTO 0) := "001";
	CONSTANT GREEN   : STD_LOGIC_VECTOR( 2 DOWNTO 0) := "010";
	CONSTANT CYAN	  : STD_LOGIC_VECTOR( 2 DOWNTO 0) := "011"; 
	CONSTANT RED	  : STD_LOGIC_VECTOR( 2 DOWNTO 0) := "100";
	CONSTANT MAGENTA : STD_LOGIC_VECTOR( 2 DOWNTO 0) := "101";
	CONSTANT YELLOW  : STD_LOGIC_VECTOR( 2 DOWNTO 0) := "110";
	CONSTANT WHITE   : STD_LOGIC_VECTOR( 2 DOWNTO 0) := "111";
	

begin
	-- Conversion to macropixels (32x32 blocks)
	x <= VGAx(9 downto 5);
	y <= VGAy(8 downto 5);
	
	-- Process to draw the screen
	process (x,y,test)
		variable currentPixel: std_logic;									-- Stores temporarily the current pixel of the sprite
		variable currentInvader: std_logic_vector( 1 downto 0);		-- Stores the type of the current invader
		variable indX, indY: integer range 0 to 31;						-- Indices inside the 32x32 block
		variable indInv: integer range 0 to 39;							-- Index inside the invaders array 
	begin
		if test = '1' then 
			-- Show test checkerboard pattern
			----------------------------------------
			if (x(0) xor y(0)) = '1' then
				rgb <= BLACK;
			else
				rgb <= WHITE; 
			end if;
		else
			-- Select screen
			case specialScreen is
				when "000" =>
					-- No special screen (show game)
					------------------------------------
					-- Get coordinates inside de 32x32 macropixel
					indX := to_integer(unsigned(VGAx(4 downto 0)));
					indY := to_integer(unsigned(VGAy(4 downto 0)));
					
					-- Convert the 'macropixel' x coordinate to the invArray coordinates (2*x+1, 2*x)
					indInv := to_integer(unsigned(x)) * 2;
					currentInvader := invArray( indInv+1 downto indInv);
					
					-- Show player 1 bullet in red
					if bulletFlying1 = '1' and (x = bullX1) and (y = bullY1) then
						if funny_bullet( indY, indX) = '1' then
							rgb <= RED;
						else
							rgb <= BLACK;
						end if;
					
					-- Show player 2 bullet in magenta
					elsif player2shown  = '1' and bulletFlying2 = '1' and (x = bullX2) and (y = bullY2) then
						if funny_bullet( indY, indX) = '1' then
							rgb <= MAGENTA;
						else
							rgb <= BLACK;
						end if;
						
					-- Show ship 1 in blue		
					elsif (x = shipX1) and (y = std_logic_vector(to_unsigned(14,4))) then
						if ship_sprite( indY, indX) = '1' then
							rgb <= BLUE;
						else
							rgb <= BLACK;
						end if;
						
					-- Show ship 2 in cyan
					elsif  player2shown  = '1' and (x = shipX2) and (y = std_logic_vector(to_unsigned(14,4))) then
						if ship_sprite( indY, indX) = '1' then
							rgb <= CYAN;
						else
							rgb <= BLACK;
						end if;
						
					-- Show invaders in green	
					elsif ( currentInvader /= "00") and (y = invLine) then
						currentPixel := alien1( indY, indX);
						if currentPixel = '1' then
							case currentInvader is 
								when "01" => -- Easy alien
									rgb <= GREEN;
								when "10" => -- Medium alien
									rgb <= YELLOW;
								when "11" => -- Hard alien
									rgb <= WHITE;
								when others =>
									rgb <= "XXX";
							end case;
						else
							rgb <= BLACK;
						end if;
					else
						-- Pixel is black otherwise:
						rgb <= BLACK;
					end if ;
					
				when "001" =>
					-- You win screen
					-------------------------------------
					if (x(0) xor y(0)) = '1' then
						rgb <= BLACK;
					else
						rgb <= RED; 
					end if;
					 -- Temporarily red checkerboard pattern
					
				when "010" =>
					-- You lose screen
					-------------------------------------
					if (x(0) xor y(0)) = '1' then
						rgb <= BLACK;
					else
						rgb <= BLUE; 
					end if;
					-- Temporarily blue checkerboard pattern
					
				when "011" =>
					-- Game won screen
					-------------------------------------
					if (x(0) xor y(0)) = '1' then
						rgb <= BLACK;
					else
						rgb <= YELLOW; 
					end if;
					-- Temporarily blue checkerboard pattern
					
				when others =>
					rgb <= "XXX"; -- Indicate error
				
			end case;
		end if ;
	end process;
end behavioral;
