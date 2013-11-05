--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:35:46 10/10/2013
-- Design Name:   
-- Module Name:   /home/def/Repositories/DCI_VHDL/Lab1/SpaceInv_tb.vhd
-- Project Name:  Lab1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: SpaceInv
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
LIBRARY std;
USE std.textio.ALL;


 
ENTITY SpaceInv_tb IS
END SpaceInv_tb;
 
ARCHITECTURE behavior OF SpaceInv_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT SpaceInv
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         HSync : OUT  std_logic;
         VSync : OUT  std_logic;
         R : OUT  std_logic;
         G : OUT  std_logic;
         B : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal HSync : std_logic;
   signal VSync : std_logic;
   signal R : std_logic;
   signal G : std_logic;
   signal B : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SpaceInv PORT MAP (
          clk => clk,
          reset => reset,
          HSync => HSync,
          VSync => VSync,
          R => R,
          G => G,
          B => B
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
		FILE output_image: TEXT is out "output.ppm";
		variable write_line: LINE;
		variable dummy: integer := 0;
		variable previousX, previousY: integer := -1;
   begin		
      -- hold reset state for 100 ns.
		if i = 0 then
			wait for 100 ns;	
			reset <= '1';
			
			-- Write header to file:
			write( write_line, "P3 640 480 1");
			writeline( output_image, write_line);
		else
		
			if reset = '1' then
				if VSync = '1' then
					if to_integer( unsigned(X) ) /= previousX and to_integer( unsigned(Y) /= previousY then
						-- Write to a file:
						----------------------------------------------
						-- Red channel
						if R = '0' then
							write (write_line, 0);
						else
							write (write_line, 1);
						end if;
						write (write_line, " ");
						
						-- Green channel
						if G = '0' then
							write (write_line, 0);
						else
							write (write_line, 1);
						end if;
						write (write_line, " ");		
						
						-- Blue channel
						if B = '0' then
							write (write_line, 0);
						else
							write (write_line, 1);
						end if;
						write (write_line, " ");		
					
						previousX := to_integer( unsigned(X) );
						previousY := to_integer( unsigned(Y) );
					end if;
					
					if HSync = '0' then
						writeline (output_image, write_line);
					end if;
				end if;
		end if;
		
      wait for clk_period;
		--------------------------------------------
		
		-- do this just for a whole sreen cycle
		--if i < 640 * 480 then
		--	i := i + 1;
		--else
		--	assert False report "End of simulation." severity error;
		--end if;
		
		wait;
		
   end process;


END;
