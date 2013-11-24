----------------------------------------------------------------------------------
-- Invaders
-- Sergio Vilches
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bullet is
   port (clk      : in  std_logic;
         reset    : in  std_logic;
         hit      : in  std_logic;  -- '1' when an invader has been hit
         disparo  : in  std_logic;  -- pushbutton
         posH     : in  std_logic_vector(4 downto 0);   -- h position of ship
         flying   : inout std_logic;-- '1' if there is a bullet moving   
         bullX    : inout std_logic_vector(4 downto 0);
         bullY    : inout std_logic_vector(3 downto 0)
         ); 
end bullet;   

architecture behavioral of bullet is
   signal tick  : std_logic; -- Signal from timer

   component timer
      generic (t: integer);
      port(
         clk   : in  std_logic;
         reset : in  std_logic;
         en    : in  std_logic;
         q     : out std_logic
      );
   end component;

begin
	
   speedTimer: timer
      generic  map (50) -- Period of movement in ms
      port     map (
         clk => clk,
         reset => reset,
         en => '1',
         q => tick
   );

   process (reset, clk)
		
   begin
      if reset = '1' then 
         bullX <= std_logic_vector(to_unsigned(0,5));
         bullY <= std_logic_vector(to_unsigned(0,4));
         flying <= '0';

      elsif clk'event and clk = '1' then
      -- Sequential behaviors:
         -- Shoot the bullet
         if ((flying = '0') and (disparo = '1')) then
            flying <= '1';  -- bullet moving
            bullX <= posH; -- starting just over the ship
            bullY <= std_logic_vector(to_unsigned(13,4));
         end if;

         -- Check if we have killed any invader
         if (hit = '1') then
            flying <= '0';
         end if;

         -- Moving up!
			if (tick = '1') and (flying = '1') then
            if bully = std_logic_vector(to_unsigned(0,4)) then
               -- We have reached the top of the screen
               flying <= '0';
            else     
               bullY <= std_logic_vector(unsigned(bullY) - to_unsigned(1,4));
            end if;
         end if;		
		end if; 
   end process;
end behavioral;