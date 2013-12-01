----------------------------------------------------------------------------------
--
-- Lab session #4: Invaders
--
-- Block controlling the space invaders
--
-- Each invader has its power encoded in 2 bits:
-- 	00 -> no invader
--		01 -> easy invader (1 shot)
--		10 -> medium invader (2 shots)
--		11 -> hard invader (3 shots)
--
-- Authors: 
-- David Estévez Fernández
-- Sergio Vilches Expósito
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity invaders is
   port (clk   : in  std_logic;
         reset : in  std_logic;
			clear : in  std_logic;
			start : in  std_logic;
         bullX : in  std_logic_vector(4 downto 0);
         bullY : in  std_logic_vector(3 downto 0);
         hit   : out std_logic;
         invArray : inout std_logic_vector(39 downto 0);
			invLine   : inout std_logic_vector(3 downto 0)
         ); 
end invaders;   


architecture behavioral of invaders is
   signal right : std_logic := '0'; -- movement of invaders: 1 = right;
   signal tick  : std_logic; -- Signal from timer
	signal moving : std_logic; 
	
	--signal internalInvArray: std_logic_vector(19 downto 0);
	--signal internalInvLine: std_logic_vector( 3 downto 0);

   component timer
      generic (t: integer);
      port(
         clk   : in  std_logic;
         reset : in  std_logic;
			clear : in  std_logic;
         en    : in  std_logic;
         q     : out std_logic
      );
   end component;

begin
	-- Instantiate a timer for invaders movement timing
   speedTimer: timer
      generic  map (10) -- Set this to a value around 10 for a faster simulation
      port map ( clk => clk, reset => reset, clear => clear, en => '1', q => tick );

	-- Main process
   process (reset, clk)
		variable intBulletX: integer; -- Temporarily storage for bullet X position translated into 2-bit-per-alien coordinates
   begin
      if reset = '1' then 
			--Default values:
			moving <= '0';
			right <= '0';
			hit <= '0';
			
			-- Choose this value for simulating 'you win' state:
         --invArray <=  "0000000000000000000000000000000000000000" ;
			-- Otherwise, this is the correct value (for first level):
			invArray <= "0000000000111110101001010101010101010101";
			
			-- Choose this value for simulating 'you lose' state:
			-- invLine <= "1101";
			-- Otherwise, this is the correct value:
         invLine <= "0000"; 
			

      elsif clk'event and clk = '1' then
			if Clear = '1' then
					--Default values:
					moving <= '0';
					right <= '0';
					hit <= '0';
			
					-- Choose this value for simulating 'you win' state:
					--invArray <=  "0000000000000000000000000000000000000000" ;
					-- Otherwise, this is the correct value (for first level):
					invArray <= "0000000000000000000001010101010101010101";
			
					-- Choose this value for simulating 'you lose' state:
					-- invLine <= "1101";
					-- Otherwise, this is the correct value:
					invLine <= "0000"; 
			else	
				-- Sequential behaviors:
				if (start = '1') then
					moving <= '0'; -- Set this to '0' to stop the invaders when testing the bullet
				end if;
		
				if (tick = '1') and (moving = '1') then
					-- Moving to the right
					if right = '0' then 
						-- Condition for reaching the end of the line: there is at least a '1' in either of the 2 final values
						if invArray(39 downto 38) /= "00" then
							right <= '1';
							-- Prevent further movement if the end has been reached
							if invLine /= "1110" then
								invLine <= std_logic_vector(unsigned(invLine) + to_unsigned(1,4)); -- Invaders Line ++
							else
								moving <= '0';
							end if;
						else
							invArray <= invArray(37 downto 0) & "00";
						end if;
				
					-- Moving to the left
					else
						-- Condition for reaching the beginning of the line: there is at least a '1' in either of the 2 first positions				
						if invArray(1 downto 0) /= "00" then
							right <= '0';
							-- Prevent further movement if the end has been reached
							if invLine /= "1110" then
								invLine <= std_logic_vector(unsigned(invLine) + to_unsigned(1,4)); -- Invaders Line ++
							else
								moving <= '0';
							end if;
						else
							invArray <= "00" & invArray(39 downto 2);
						end if;
					end if;
				end if;
			
				-- Checking for bullet
				-- [ There is an alien if there is a '1' in either the position bullX*2 or bullX*2+1 ]
				intBulletX := to_integer(unsigned(bullX))*2;
				if (bullY = invLine) and invArray( intBulletX + 1 downto intBulletX ) /= "00" then
					hit <= '1';
					-- Substract 1 to the alien power
					invArray( intBulletX+1 downto intBulletX ) <= std_logic_vector(unsigned( invArray( intBulletX+1 downto intBulletX )) - 1 );
				else
					hit <= '0';
				end if ;
   		end if;	
		end if; 	
			
   end process;

end behavioral;