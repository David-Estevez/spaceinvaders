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
USE ieee.numeric_std.ALL;
LIBRARY std;
USE std.textio.ALL;
 
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
		variable previousX, previousY: integer := -1;
   begin		
      -- hold reset state for 100 ns.
		if i = 0 then
			wait for 40 ns;	
			reset <= '1';
		end if;
		
		-- record image:
		if reset = '1' then
			if VSync = '1' then
				if to_integer( unsigned(X) ) /= previousX and to_integer( unsigned(Y) /= previousY then
					write (write_line, 0);
					previousX := to_integer( unsigned(X) );
					previousY := to_integer( unsigned(Y) );
				end if;
			
				if HSync = '0' then
					writeline (output_file, write_line);
				end if;
			else
				wait;
			end if;
		end if;
		
      wait for clk_period;
			
   end process;

END;
