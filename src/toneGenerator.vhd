----------------------------------------------------------------------------------
-- TONE GENERATOR
-- Sergio Vilches
-- David Estevez
-- Outputs audio sweep tones
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity toneGenerator is
   port (clk  		    : in  std_logic;
        reset 		    : in  std_logic;
		p1_posShip 	    : in  std_logic;
        p2_posShip      : in  std_logic;
        p1_BulletActive	: in  std_logic;
        p2_BulletActive	: in  std_logic;
        inv_Hit1        : in  std_logic;
        inv_Hit2        : in  std_logic;
        specialScreen   : in  std_logic_vector( 2 downto 0);
        toneOutput      : out std_logic
    );

end toneGenerator;   

architecture behavioral of toneGenerator is
    
    -- Tone generation
    signal count       : integer range 0 to 1000000;  -- Used for tone generation (20 bits)
	signal clkCycles   : integer range 0 to 1000000;  -- Clock cycles (50 MHz) per period   
    signal toneEnable  : std_logic;
    signal toneStart   : std_logic;
    signal q           : std_logic;
    
    -- Sweep Parameters
    signal startPeriod : integer range 0 to 20000;    -- Period of sound in microseconds (Minimum frequency of 50 Hz = 20,000 microseconds)
    signal endPeriod   : integer range 0 to 20000;    -- Period of sound in microseconds (Minimum frequency of 50 Hz = 20,000 microseconds)
    signal step        : integer range 0 to 31 := 0;  -- For period sweep
	signal deltaPeriod : integer range -524288 to 524287; -- Period change in each step
	signal tick        : std_logic; -- Signal from timer

    -- Glue logic signals
    signal p1_posShip_detected      : std_logic;
    signal p2_posShip_detected      : std_logic;
    signal p1_bulletActive_detected : std_logic;
    signal p2_bUlletActive_detected : std_logic;
    signal fsm_win                  : std_logic;
    signal fsm_loose                : std_logic;
    signal fsm_win_detected         : std_logic;
    signal fsm_loose_detected       : std_logic;
	
    -- The following logic decodes which sound is needed for each situation, analyzing signals already present in spaceInv

    component edgeDetector is
    port( 
        clk: in STD_LOGIC;
        reset: in STD_LOGIC;
        enable: in STD_LOGIC;
        input: in STD_LOGIC;
        detected: out STD_LOGIC 
    );
    end component;

    component edgeDetectorRiseFall is
    port( 
        clk: in STD_LOGIC;
        reset: in STD_LOGIC;
        enable: in STD_LOGIC;
        input: in STD_LOGIC;
        detected: out STD_LOGIC 
    );
    end component;

    component timer is
        generic  (  t: integer := 1); -- Period in ms
        port (clk   : in  std_logic;
            reset : in  std_logic;
            clear : in 	std_logic;
            en    : in  std_logic;
            q     : out std_logic
        );
    end component; 
	
begin

   stepTimer: timer
      generic  map (33) -- 33 ms steps
      port     map (
         clk => clk,
         reset => reset,
         clear => '0',
         en => '1',
         q => tick
      );
      
  

    p1_posShip_edgeDetector: edgeDetectorRiseFall
        port map(
            clk => clk,
            reset => reset,
            enable => '1',
            input => p1_posShip,
            detected => p1_posShip_detected
        );

    p2_posShip_edgeDetector: edgeDetectorRiseFall
        port map(
            clk => clk,
            reset => reset,
            enable => '1',
            input => p2_posShip,
            detected => p2_posShip_detected
        );

    p1_BulletActive_edgeDetector: edgeDetector
        port map(
            clk => clk,
            reset => reset,
            enable => '1',
            input => p1_BulletActive,
            detected => p1_BulletActive_detected
        );

    p2_BulletActive_edgeDetector: edgeDetector
        port map(
            clk => clk,
            reset => reset,
            enable => '1',
            input => p2_BulletActive,
            detected => p2_BulletActive_detected
        );

    fsm_win_edgeDetector: edgeDetector
        port map(
            clk => clk,
            reset => reset,
            enable => '1',
            input => fsm_win,
            detected => fsm_win_detected
        );

    fsm_loose_edgeDetector: edgeDetector
        port map(
            clk => clk,
            reset => reset,
            enable => '1',
            input => fsm_loose,
            detected => fsm_loose_detected
        );


   -- State decoding
    process (specialScreen)
    begin
        case specialScreen is
            when "001" =>
                fsm_win     <= '1';
                fsm_loose   <= '0';
            when "010" =>
                fsm_win     <= '0';
                fsm_loose   <= '1';
            when others => 
                fsm_win     <= '0';
                fsm_loose   <= '0';
        end case;
    end process;

	-- Sound selection. Selects the boundaries of the frequency sweep
   process (reset, clk) 
   begin
		if reset = '1' then 
         startPeriod <= 1000;
			endPeriod	<= 1000;
			toneStart 	<= '0';
			
      elsif clk'event and clk = '1' then
			if 	((p1_posShip_detected or p2_posShip_detected) = '1') then
				startPeriod <= 10000;
				endPeriod	<= 2000;
				toneStart 	<= '1'; 
			elsif ((p1_BulletActive_detected or p2_BulletActive_detected) = '1') then
				startPeriod <= 100;
				endPeriod	<= 1000;
				toneStart 	<= '1'; 
			elsif ((inv_Hit1 or inv_Hit2) = '1') then
				startPeriod <= 1000;
				endPeriod	<= 10000;
				toneStart 	<= '1'; 
			elsif (fsm_win_detected = '1') then
				startPeriod <= 10000;
				endPeriod	<= 100;
				toneStart 	<= '1'; 
            elsif (fsm_loose_detected = '1') then
                startPeriod <= 15000;
                endPeriod   <= 20000;
                toneStart   <= '1'; 
			else
				toneStart <= '0'; 
			end if;
		end if;
		
	end process;
	
	
    -- Tone generation. Just a simple variable square wave generator
    process (reset, clk, q) 
    begin
    if reset = '1' then 
        count <= 0;
        q <= '0';
    elsif clk'event and clk = '1' then
        if count = 0 then
            count <= clkCycles/2;
            q <= not q;
        elsif toneEnable = '1' then
            count <= count - 1;
        else
        	q <= '0';
        end if;
    end if; 

    toneOutput <= q;

    end process;


   -- Sweep. Creates a ramp of frequencies
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
			
         clkCycles <= 50 * (startPeriod + deltaPeriod * step); -- The '50' factor converts from microseconds to clock cycles
			
      end if; 
   end process;

end behavioral;
