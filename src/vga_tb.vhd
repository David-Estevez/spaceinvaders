----------------------------------------------------------------------------------
--
-- Lab session #1: vga controller testbench
--
----------------------------------------------------------------------------------
-- Testing of the vga controller entity
--
-- Author: David Estévez Fernández
----------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY std;
USE std.textio.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY vga_tb IS
END vga_tb;
 
ARCHITECTURE behavior OF vga_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT vga
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         RGB : IN  std_logic_vector(2 downto 0);
         HSync : OUT  std_logic;
         VSync : OUT  std_logic;
         R : OUT  std_logic;
         G : OUT  std_logic;
         B : OUT  std_logic;
         X : OUT  std_logic_vector(9 downto 0);
         Y : OUT  std_logic_vector(9 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal RGB : std_logic_vector(2 downto 0) := (others => '0');

 	--Outputs
   signal HSync : std_logic;
   signal VSync : std_logic;
   signal R : std_logic;
   signal G : std_logic;
   signal B : std_logic;
   signal X : std_logic_vector(9 downto 0);
   signal Y : std_logic_vector(9 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: vga PORT MAP (
          clk => clk,
          reset => reset,
          RGB => RGB,
          HSync => HSync,
          VSync => VSync,
          R => R,
          G => G,
          B => B,
          X => X,
          Y => Y
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
		variable i: integer := 0;
		FILE output_file: TEXT is out "output.dat";
		variable write_line: LINE;
		variable caca: std_logic;
   begin		
      -- hold reset state for 100 ns.
		if i = 0 then
			wait for 40 ns;	
			reset <= '1';
		end if;
		
		-- other periods
		write (write_line, 0);
		if HSync = '1' then
			writeline (output_file, write_line);
		end if;
		
      wait for clk_period;
		
		-- do this just for a whole sreen cycle
		if i < 640 * 480 then
			i := i + 1;
		else
			assert False report "End of simulation." severity error;
		end if;
			
   end process;

END;
