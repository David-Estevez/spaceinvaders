----------------------------------------------------------------------------------
--
-- Lab session #1: vga controller
--
-- Author: David Estévez Fernández
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           RGB : in  STD_LOGIC_VECTOR (2 downto 0);
           HSync : out  STD_LOGIC;
           VSync : out  STD_LOGIC;
           R : out  STD_LOGIC;
           G : out  STD_LOGIC;
           B : out  STD_LOGIC;
           X : out  STD_LOGIC_VECTOR (9 downto 0);
           Y : out  STD_LOGIC_VECTOR (9 downto 0));
end vga;

architecture Behavioral of vga is

begin
	process(reset, clk)
		-- XCount -> holds the count for the X dimension ( monitor resolution is 640x480 )
		variable HCount: integer range 0 to 800:= 0;
		variable VCount: integer range 0 to 521 := 0;
		variable prescaler: std_logic := '0';
	begin
	-- When resetting, set all outputs to 0
			if reset = '1' then
					HSync <= '1';
					VSync <= '1';
					R <= '0';
					G <= '0';
					B <= '0';
					X <= "0000000000";
					Y <= "0000000000";
			elsif clk'event and clk = '1' then
					-- Prescaler 
					if prescaler = '1' then
						prescaler := '0';
					else
						prescaler := '1';
					end if;
					
					-- Counters:
					if prescaler = '0' then
					
						if HCount = 800 then
							HCount := 0;
						
							if VCount = 521 then
								VCount := 0;
							else
								VCount := VCount + 1;
							end if;
						
							else
								HCount := HCount + 1;
						end if;
					
					end if;
					
					-- HSync:
					if HCount >= 654 and HCount < 752 then
						HSync <= '0';
					else
						HSync <= '1';
					end if;
					
					-- VSync:
					if VCount >= 490 and VCount < 492 then
						VSync <= '0';
					else
						VSync <= '1';
					end if;
						
					-- X / Y position:
					if HCount < 640 then
						X <= std_logic_vector( to_unsigned( HCount, 10) );
					end if;
					
					if VCount < 480 then
						Y <= std_logic_vector( to_unsigned( VCount, 10) );
					end if;
					
					-- Color:
					if VCount < 480 and HCount < 640 then
						R <= RGB(2);
						G <= RGB(1);
						B <= RGB(0);
					else
						R <= '0';
						G <= '0';
						B <= '0';
					end if;
			end if;
	end process;

end Behavioral;

-- This is used to take captures of the screen
LIBRARY std;
USE std.textio.ALL;
architecture Simulation of vga is

begin  	
	process(reset, clk)
		variable HCount: integer range 0 to 640:= 0;
		variable VCount: integer range 0 to 480 := 0;
		variable start: std_logic := '1';
		variable finish: std_logic := '0';
		-- File variables:
		FILE output_image: TEXT is out "output.ppm";
		variable write_line: LINE;
	begin
		if reset = '1' and start = '0' then 
			HCount := 0;
			VCount := 0;
			start := '1';
			finish := '0';
		elsif clk'Event and clk = '1' then
			-- Counter

			if HCount = 639 then
				HCount := 0;
				HSync <= '1';
								
				if VCount = 479 then
					VCount := 0;
					VSync <= '1';
				else
					VCount := VCount + 1;
					VSync <= '0';
				end if;
			else
				HCount := HCount + 1;		
				HSync <= '0';
			end if;
					
		end if;
		
		-- Output
		if HCount < 640 then
			X <= std_logic_vector( to_unsigned(HCount, 10 ));
		end if;
		
		if VCount < 480 then
			Y <= std_logic_vector( to_unsigned(VCount, 10 ));
		end if;
		
		-- Writing things
		if finish = '0' then
			if HCount = 0 and VCount = 0 and start = '1' and reset = '0' then
				-- Write file header
				write( write_line, "P3 640 480 1");
				writeline( output_image, write_line);
				start := '0';
			else
				-- Write R
				--write (write_line, (to_integer( unsigned'( "" & RGB(0) ) )) );
				if RGB(0) = '0' then
					write( write_line, 0);
				else
					write( write_line, 1);
				end if;
				write (write_line, " ");
				

				-- Write G
				--write (write_line, (to_integer( unsigned'( "" & RGB(1) ) )) );
				if RGB(1) = '0' then
					write( write_line, 0);
				else
					write( write_line, 1);
				end if;
				write (write_line, " ");
				-- Write B
				--write (write_line, (to_integer( unsigned'( "" & RGB(2) ) )) );
				if RGB(2) = '0' then
					write( write_line, 0);
				else
					write( write_line, 1);
				end if;
				write (write_line, " ");
				
				if HCount = 0 then
					writeline( output_image, write_line);
				end if;
				
				if start = '0' and HCount = 0 and VCount = 0 then
					finish := '1';
				else
					finish := '0';
				end if;
				
				
			end if;
					
		end if;
		
	R <= RGB(0);
	G <= RGB(1);
	B <= RGB(2);
	end process;
end Simulation;
