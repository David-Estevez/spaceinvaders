----------------------------------------------------------------------------------
-- Invaders
-- Sergio Vilches
-- David Estévez Fernández
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bullet is
   port (clk      : in  std_logic;
         reset    : in  std_logic;
			clear		: in  std_logic;
			enable	: in 	std_logic;
         hit      : in  std_logic;  -- '1' when an invader has been hit
         shoot    : in  std_logic;  -- pushbutton
         posH     : in  std_logic_vector(4 downto 0);   -- h position of ship
         flying   : out std_logic;-- '1' if there is a bullet moving   
         bullX    : out std_logic_vector(4 downto 0);
         bullY    : out std_logic_vector(3 downto 0)
         ); 
end bullet;   

architecture behavioral of bullet is
   signal tick  : std_logic; -- Signal from timer
	signal intbullX: 	std_logic_vector( 4 downto 0);
	signal intbullY:	std_logic_vector( 3 downto 0);

	component timer is
		generic  (  t: integer);
		port (clk   : in  std_logic;
				reset : in  std_logic;
				clear : in  std_logic;
				en    : in  std_logic;
				q     : out std_logic);
	end component;   


begin
	
   speedTimer: timer
      generic  map (50) -- Period of movement in ms (5 for a faster simulation)
      port     map (
         clk => clk,
         reset => reset,
			clear => clear,
         en => '1',
         q => tick
   );

   process (reset, clk,intbullX,intbullY)
		variable intflying: std_logic;
   begin
      if reset = '1' then 
         intbullX <= std_logic_vector(to_unsigned(0,5));
         intbullY <= std_logic_vector(to_unsigned(14,4));
         intflying := '0';

      elsif clk'event and clk = '1' then
      -- Sequential behaviors:
			if clear = '1' then
				intbullX <= std_logic_vector(to_unsigned(0,5));
				intbullY <= std_logic_vector(to_unsigned(14,4));
				intflying := '0';
			elsif enable = '1' then
				-- Shoot the bullet
				if ((intflying = '0') and (shoot = '1')) then
					intflying := '1';  -- bullet moving
					intbullX <= posH; -- starting just over the ship
					intbullY <= std_logic_vector(to_unsigned(13,4));
				end if;

				-- Check if we have killed any invader
				if (hit = '1') then
					intflying := '0';
					intbullY <= std_logic_vector(to_unsigned(14,4));
				end if;

				-- Moving up!
				if (tick = '1') and (intflying = '1') then
					if intbullY = std_logic_vector(to_unsigned(0,4)) then
						-- We have reached the top of the screen
						intflying := '0';
						intbullY <= std_logic_vector(to_unsigned(14,4));
					else     
						intbullY <= std_logic_vector(unsigned(intbullY) - to_unsigned(1,4));
					end if;
				end if;
			end if;
		end if;
		
		bullX <= intBullX;
		bullY <= intBullY;
		flying <= intFlying;
   end process;
end behavioral;