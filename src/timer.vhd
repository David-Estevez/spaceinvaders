----------------------------------------------------------------------------------
-- GENERIC TIMER
-- Sergio Vilches
-- Gives a pulse of one clock cycle width with a period of t
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer is
   generic  (  t: time := 1 ms);
   port (clk   : in  std_logic;
         reset : in  std_logic;
         en    : in  std_logic;
         q     : out std_logic);
end timer;   

architecture behavioral of timer is
	constant clkFreq : integer := 50; -- 50 MHz clock
	constant max : integer := (((t/(1 ns))*clkFreq)/1000)-1;
	signal count : integer range 0 to max;
begin
   process (reset, clk)	   
   begin
      if reset = '0' then 
         count <= 0;
      elsif clk'event and clk = '1' then
      -- Sequential behaviors:
         if count = max then
            count <= 0;
         elsif en = '1' then
            count <= count + 1;
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