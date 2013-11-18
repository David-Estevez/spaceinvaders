----------------------------------------------------------------------------------
-- Invaders
-- Sergio Vilches
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity invaders is
   port (clk   : in  std_logic;
         reset : in  std_logic;
			start : in  std_logic;
         bullX : in  std_logic_vector(4 downto 0);
         bullY : in  std_logic_vector(3 downto 0);
         hit   : out std_logic;
         invArray : inout std_logic_vector(19 downto 0);
			invLine   : inout std_logic_vector(3 downto 0)
         ); 
end invaders;   


architecture behavioral of invaders is
   signal right : std_logic := '0'; -- movement of invaders: 1 = right;
   signal tick  : std_logic; -- Signal from timer
	signal moving : std_logic; 

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
      generic  map (100)
      port     map (
         clk => clk,
         reset => reset,
         en => '1',
         q => tick
   );

   process (reset, clk)
		
   begin
      if reset = '1' then 
			moving <= '0';
         invArray <= "00000000001111111111";
         invLine <= "0000"; 
         right <= '0';
			hit <= '0';

      elsif clk'event and clk = '1' then
      -- Sequential behaviors:
			if (start = '1') then
				moving <= '1';
			end if;
		
			if (tick = '1') and (moving = '1') then
				-- Moving to the right
				if right = '0' then 
					if invArray(19) = '1' then
						right <= '1';
						invLine <= std_logic_vector(unsigned(invLine) + to_unsigned(1,4)); -- Invaders Line ++
					else
						invArray <= invArray(18 downto 0) & '0';
					end if;
				
				-- Moving to the left
				else                
            if invArray(0) = '1' then
						right <= '0';
						invLine <= std_logic_vector(unsigned(invLine) + to_unsigned(1,4)); -- Invaders Line ++
					else
						invArray <= '0' & invArray(19 downto 1);
					end if;
				end if;
			end if;
			
   		-- Checking for bullet
   		if (bullY = invLine) and (invArray(to_integer(unsigned(bullX))) = '1') then
            hit <= '1'; 	
   			invArray(to_integer(unsigned(bullX))) <= '0';
   		else
   			hit <= '0';
   		end if ;
   			
		end if; 	
			
   end process;

end behavioral;