library ieee;
use ieee.std_logic_1164.all;
 
-- uncomment the following library declaration if using
-- arithmetic functions with signed or unsigned values
--use ieee.numeric_std.all;
 
entity counter_tb is
end counter_tb;
 
architecture behavior of counter_tb is 
 
    -- component declaration for the unit under test (uut)
 
    component counter
	 generic	(  n: integer;
					max: integer );
    port(
         clk : in  std_logic;
         reset : in  std_logic;
			clear : in std_logic;
			enable: in STD_LOGIC;
         count_out : out  std_logic_vector(n-1 downto 0);
         cout : 		out std_logic
        );
    end component;
    

   --inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
	signal clear : std_logic := '0';
	signal enable: std_logic := '1';

	--outputs
   signal count_out_3 : std_logic_vector(2 downto 0);
   signal cout: std_logic;
   -- clock period definitions
   constant clk_period : time := 40 ns;
 
begin
 
	-- instantiate the unit under test (uut)
   uut: counter
		generic map (3,5) -- 4-bit counter
		port map (
          clk => clk,
          reset => reset,
			 clear => clear,
			 enable => enable,
          count_out => count_out_3,
          cout => cout
        );

   -- clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- stimulus process
   stim_proc: process
   begin		
		reset <= '1';
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		reset <= '0';
      wait for clk_period*10;
		clear <= '1';
		wait for clk_period;
		clear <= '0';
		wait for clk_period*10;
		enable <= '0';
		wait for clk_period*2;
		enable <= '1';
		wait for clk_period*10;
      wait;
   end process;

end;
