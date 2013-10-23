----------------------------------------------------------------------------------
--
-- Lab session #1: Space Invaders: vga controller
--
----------------------------------------------------------------------------------
-- Top level entity for the Space Invaders vga controller
-- Author: David Estévez Fernández
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SpaceInv is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           HSync : out  STD_LOGIC;
           VSync : out  STD_LOGIC;
           R,G,B : out  STD_LOGIC;
			  Test: in STD_LOGIC);
end SpaceInv;

architecture Behavioral of SpaceInv is

	 -- Component declaration for vga controller:
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

	-- Compoment declaration for vga checkerboard pattern generator:
	COMPONENT formatoVGA
   PORT ( 
			RGB : out  STD_LOGIC_VECTOR (2 downto 0);
         X : in  STD_LOGIC_VECTOR (9 downto 0);
         Y : in  STD_LOGIC_VECTOR (9 downto 0);
			Test: in STD_LOGIC
		  );
	END COMPONENT;
	
	-- Internal signals
	signal RGB: STD_LOGIC_VECTOR (2 downto 0);
	signal X, Y: STD_LOGIC_VECTOR (9 downto 0);
	
			
begin
   checkerboard: formatoVGA PORT MAP( RGB => RGB, X => X, Y => Y, Test => Test);
	vgaController: vga PORT MAP( clk => clk, reset => reset, RGB => RGB, HSync => HSync, VSync => VSync, R => R, G => G, B => B, X => X, Y => Y );

end Behavioral;

