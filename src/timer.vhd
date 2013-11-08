----------------------------------------------------------------------------------
-- GENERIC TIMER
-- Sergio Vilches
-- Enables Q for a given time, set with time units (ns, us, ms, s)
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity timer is
   generic  (  t: time := 1 ms);
   port (clk   : in  std_logic;
         reset : in  std_logic;
         clear : in  std_logic;
			start : in 	std_logic;
         q     : out std_logic);
end timer;   


architecture behavioral of timer is
	
	constant clkFreq : integer := 50; -- 50 MHz clock
   
begin
   process (reset, clk)
      variable max : integer := ((t/(1 ns))*clkFreq)/1000;
		variable count : integer range 0 to max;
      --    variable n : integer := integer(ceil(log2(real(max))));
	   
   begin
      if reset = '1' then 
         count := 0;
      elsif clk'event and clk = '1' then
      -- Sequential behaviors:
         if clear = '1' then
            count := 0;
         elsif (count < max) and ((count > 0) or (start = '1')) then
            count := count + 1;
         end if;
      end if; 

      -- Concurrent behaviors:
      if count = max then
         q <= '1';
         else
         q <= '0';
      end if;

   end process;

end behavioral;