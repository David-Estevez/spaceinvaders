----------------------------------------------------------------------------------
-- TONE GENERATOR
-- Sergio Vilches
-- Outputs an audio tone of a given frequency
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity toneGenerator is
   port (clk   : in  std_logic;
         reset : in  std_logic;
			a		: in  std_logic;
			b		: in  std_logic;
			c		: in  std_logic;
			d		: in  std_logic;
         q     : inout std_logic);-- Tone output
end toneGenerator;   

architecture behavioral of toneGenerator is
	signal count : integer range 0 to 1048575;              -- Used for tone generation
   signal period: integer range 0 to 1048575 := 8 ;        -- 
	signal startPeriod: integer range 0 to 1048575 := 1000 ;-- 20 bits
	signal endPeriod: integer range 0 to 1048575 := 500 ; -- 20 bits
	signal step: integer range 0 to 31 := 0; -- For period sweep
   signal deltaPeriod: integer range -524288 to 524287; -- Period change in each step
   signal tick  : std_logic; -- Signal from timer
	signal toneEnable  : std_logic;
	signal toneStart  : std_logic;
	
   component timer
      generic (t: integer);
      port(
         clk   : in  std_logic;
         reset : in  std_logic;
			en 	: in  std_logic;
         q     : out std_logic
      );
   end component;
	
begin

   stepTimer: timer
      generic  map (33) -- 33 ms steps
      port     map (
         clk => clk,
         reset => reset,
         en => '1',
         q => tick
      );

	-- Sound selection
   process (reset, clk) 
   begin
		if reset = '1' then 
         startPeriod <= 1000;
			endPeriod	<= 1000;
			toneStart 	<= '0';
			
      elsif clk'event and clk = '1' then
			if 	(a = '1') then
				startPeriod <= 100;
				endPeriod	<= 10000;
				toneStart 	<= '1'; 
			elsif (b = '1') then
				startPeriod <= 10000;
				endPeriod	<= 100;
				toneStart 	<= '1'; 
			elsif (c = '1') then
				startPeriod <= 1000;
				endPeriod	<= 500;
				toneStart 	<= '1'; 
			elsif (d = '1') then
				startPeriod <= 500;
				endPeriod	<= 1000;
				toneStart 	<= '1'; 
			else
				toneStart <= '0'; 
			end if;
		end if;
		
	end process;
	
	
	-- Tone generation
   process (reset, clk) 
   begin
      if reset = '1' then 
         count <= 0;
         q <= '0';
      elsif clk'event and clk = '1' then
      -- Sequential behaviors:
         if count = 0 then
            count <= period/2;
            q <= not q;
         elsif toneEnable = '1' then
            count <= count - 1;
			else
				q <= '0';
         end if;
      end if; 
   end process;


   -- Sweep
process (reset, clk) 
   begin
      if reset = '1' then 
         step <= 0;
			toneEnable <= '0';
      elsif clk'event and clk = '1' then
         deltaPeriod <= (endPeriod - startPeriod)/32;
         
			if toneStart = '1' then
				step <= 0;
				toneEnable <= '1';
			elsif (tick = '1' and step < 31) then
				step <= step + 1;
			elsif (tick = '1' and step = 31) then
				toneEnable <= '0';
			end if;
			
         period <= 50 * (startPeriod + deltaPeriod * step); -- The '50' factor converts from us to clock cycles
			
      end if; 
   end process;

end behavioral;