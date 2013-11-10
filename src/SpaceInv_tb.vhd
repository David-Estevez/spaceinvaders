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
			clk : in  STD_LOGIC;
         reset : in  STD_LOGIC;
			Test: in STD_LOGIC; 	  
         Izquierda, Derecha: in STD_LOGIC;
			HSync : out  STD_LOGIC;
         VSync : out  STD_LOGIC;
         R,G,B : out  STD_LOGIC
			);
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
	signal Test : std_logic := '0';
	signal Izquierda : std_logic := '0';
	signal Derecha: std_logic := '0';

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
			 Test => Test,
			 Izquierda => Izquierda,
			 Derecha => Derecha,
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

   begin
		reset <= '1';	
		wait for 100 ns;	
		reset <= '0';
		Test <= '0';
      wait for 640*480*clk_period;
		assert false report "Simulation stopped" severity failure;
		wait;
		
   end process;

END;
