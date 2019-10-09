library ieee;
use ieee.std_logic_1164.all;
use work.target_package.all;
use work.counter_package.all;
use work.properties_package.all;
use work.shape_package.all;

entity YoItsMe_TheLovableCircuit is
	generic(
	xMin      : integer := -100;
	xMax      : integer := 800;
	nTargets  : integer := 5);
	port(
	target_clock0,
	target_clock1,
	target_clock2,
	clk25,
	clk50,
	red_switch, green_switch, blue_switch,
	hsync, vsync, 
	hactive, vactive, 
	dena,
	reset,
	up, down, lt, rt, button                  : in  std_logic := '0';
	numberOne, numberTwo                      : out natural range 0 to 10;
	r, g, b								      : out std_logic_vector(9 downto 0) := (others => '0'));
end YoItsMe_TheLovableCircuit; 


	

architecture FSM of YoItsMe_TheLovableCircuit is
----------------------------------------------------------------------------------------------
--Color for targets---------------------------------------------------------------------------
----------------------------------------------------------------------------------------------	
	type colorIndex is array(0 to 4) of integer range 0 to 7;
	constant customColor1  : colorIndex := (4, 2, 1, 3, 5);
	constant customColor2  : colorIndex := (4, 7, 2, 3, 5);
	constant customColor3  : colorIndex := (4, 7, 0, 2, 1);

----------------------------------------------------------------------------------------------
--Game States---------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------		
	type gameState is(Start, Play, Menu);
	signal prev_gameState, next_gameState : gameState;
	
	type yState is(Bot, Mid, Top);
	signal prev_yState, next_yState : yState := Mid;
	
	type xState is(Lft, Rght, Idle);
	signal prev_xState, next_xState : xState := Idle;

	type detectorState is(Reload, Ready, Fire, yBot, yMid, yTop);
	signal prev_detState, next_detState : detectorState := Reload;
	
----------------------------------------------------------------------------------------------
--Data types for Game-------------------------------------------------------------------------
----------------------------------------------------------------------------------------------		
	
	--Total score-------------------------------------
	signal totalScore : natural range 0 to 999 := 0;
	--Game time--------------------------------------
	signal startGame : std_logic := '0';
	signal gameTime  : integer range 0 to 60 := 0;
    -------------------------------------------------
	
	--YController time------------------------------------
	signal yRefresh  : std_logic := '1';
	signal yTimer    : integer range 0 to 5 := 0;
	signal yTrigger  : std_logic        := '0';	   
	type   yPos is array(0 to 2) of integer range 0 to 500;
	constant yCoord      : yPos := (50, 160, 340);
    ------------------------------------------------------

	--DetController time------------------------------------
	signal detRefresh  : std_logic := '1';
	signal detTimer    : integer range 0 to 5 := 0;
	signal detTrigger  : std_logic        := '0';
	signal yLocation   : std_logic_vector(2 downto 0);	   
    ------------------------------------------------------

	--XController time------------------------------------
	signal xRefresh  : std_logic := '1';
	signal xTimer    : integer range 0 to 5 := 0;
	signal xTrigger  : std_logic        := '0';
	signal xE        : std_logic        := '0';
	------------------------------------------------------

	--Reticule positions-----------------------------------
	signal xRange    : integer range 0 to 800 := 320;
	signal yCounter  : integer range 0 to 2 := 1;	    
	--------------------------------------------------------
	
	
	--Temp---

begin

--------------------------------------------------------------------------------------------
--Timer for Target Detector-----------------------------------------------------------------
--------------------------------------------------------------------------------------------	
	process(clk50, detTimer, detRefresh)	
	variable detRefreshTime   : integer range 0 to 50_000_000 := 0;
	begin
	if(detTrigger = '1') then 
									detTimer        <= 0;
									detRefreshTime  := 0;
	elsif(rising_edge(clk50)) then detRefreshTime := detRefreshTime + 1;
			if(detRefreshTime = 10_000) then detRefreshTime := 0;							   
				if(detTimer = 2)        then detTimer <= detTimer;
				else                         detTimer <= detTimer + 1;
				end if;
			end if;
	end if;
	end process;
--------------------------------------------------------------------------------------------
--Target Detector---------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
	 
	process(clk50)
	begin
	if(rising_edge(clk50)) then 
		if(reset = '1') then prev_detState <= Reload;
		else                 prev_detState <= next_detState;
		end if;
	end if;
	end process;
	
	process(prev_detState, detRefresh, button, target_clock0, target_clock1, target_clock2, detTimer, detTrigger)

	begin
		
		detRefresh <= '0';
		
		case (prev_detState) is 
			when Reload => 
					if(detTimer = 2) then next_detState <= Ready;
					else                   next_detState <= Reload;
					end if;
						 
			when Ready =>  
				if(button = '1') then next_detState <= Fire; detRefresh <= '1';
				else                  next_detState <= Ready;
				end if;
				
								                
			when Fire => 
			
				if   (yCounter = 2) then next_detState <= yBot;
				elsif(yCounter = 1) then next_detState <= yMid;
				elsif(yCounter = 0) then next_detState <= yTop;
				else                     next_detState <= Fire;
				end if;
			
			when yBot => 
				next_detState <= Reload;

		
			when yMid =>
				next_detState <= Reload;
				
			
			when yTop => 
				next_detState <= Reload;

					
		end case;
	end process;
		
	process(clk50, detTrigger, detRefresh, target_clock0, target_clock1, target_clock2, prev_detState)
	begin		
	if(rising_edge(clk50)) then 
			detTrigger <= detRefresh;
	end if;	
	end process;
	
	process(clk50)
	variable detector0          : natural range 0 to 100000;
	variable detector1          : natural range 0 to 100000;
	variable detector2          : natural range 0 to 100000;
	variable detector_counter0	: integer range -100 to 800 := 0;
	variable detector_counter1	: integer range -100 to 800 := 0;
	variable detector_counter2	: integer range -100 to 800 := 0;
	begin
		intCounter(target_clock0, 800, -100, detector_counter0);
		intCounter(target_clock1, 800, -100, detector_counter1);
		intCounter(target_clock2, 800, -100, detector_counter2);
		
		
		if   (prev_detState = yBot) then
						detector0 := (xRange - detector_counter0)**2;
						numberOne <= 1; numberTwo <= 0; totalScore <= totalScore + 50;
--						if   (detector0 <  radii1(0) or detector0 = 0) then numberOne <= 5; numberTwo <= 0; totalScore <= totalScore + 50; 
--						elsif(detector0 <  radii1(1))                  then numberOne <= 3; numberTwo <= 0; totalScore <= totalScore + 30; 
--						elsif(detector0 <  radii1(2)) 				   then numberOne <= 2; numberTwo <= 0; totalScore <= totalScore + 20; 
--						elsif(detector0 <  radii1(3))				   then numberOne <= 1; numberTwo <= 0; totalScore <= totalScore + 10; 
--						elsif(detector0 <  radii1(4))				   then numberOne <= 0; numberTwo <= 5; totalScore <= totalScore +  5; 
--						else                                                numberOne <= 6; numberTwo <= 9; totalScore <= totalScore;	   
--						end if;
		elsif(prev_detState = yMid) then 
						detector1 := (xRange - detector_counter1)**2;
						if(detector1 < 3200) then numberOne <= 2; numberTwo <= 0; totalScore <= totalScore + 50; 
						else                      numberOne <= 0; numberTwo <= 0; totalScore <= totalScore + 50; 
						end if;
--						if(detector0 < 3200) then numberOne <= 2; numberTwo <= 0;
--						else                      numberOne <= 0; numberTwo <= 0;
--						end if;
--						numberOne <= 2; numberTwo <= 0; totalScore <= totalScore + 50; 
						
--						if   (detector1 <  radii2(0) or detector1 = 0) then numberOne <= 3; numberTwo <= 0; totalScore <= totalScore + 30;
--						elsif(detector1 <  radii2(1))                  then numberOne <= 2; numberTwo <= 0; totalScore <= totalScore + 20; 
--						elsif(detector1 <  radii2(2)) 				   then numberOne <= 1; numberTwo <= 0; totalScore <= totalScore + 10; 
--						elsif(detector1 <  radii2(3))				   then numberOne <= 0; numberTwo <= 5; totalScore <= totalScore +  5; 
--						elsif(detector1 <  radii2(4))				   then numberOne <= 0; numberTwo <= 3; totalScore <= totalScore +  3; 
--						else                                                numberOne <= 3; numberTwo <= 3; totalScore <= totalScore;	   
--						end if;
		elsif(prev_detState = yTop) then
						detector2 := (xRange - detector_counter2)**2;	  
						numberOne <= 3; numberTwo <= 0; totalScore <= totalScore + 30;
--						if   (detector2 <  radii3(0) or detector2 = 0) then numberOne <= 2; numberTwo <= 0; totalScore <= totalScore + 30; 
--						elsif(detector2 <  radii3(1))                  then numberOne <= 1; numberTwo <= 5; totalScore <= totalScore + 15; 
--						elsif(detector2 <  radii3(2)) 				   then numberOne <= 0; numberTwo <= 8; totalScore <= totalScore +  8; 
--						elsif(detector2 <  radii3(3))				   then numberOne <= 0; numberTwo <= 2; totalScore <= totalScore +  2; 
--						elsif(detector2 <  radii3(4))				   then numberOne <= 0; numberTwo <= 1; totalScore <= totalScore +  1; 
--						else                                                numberOne <= 7; numberTwo <= 5; totalScore <= totalScore;	   
--						end if;      
		end if;
	end process;


----------------------------------------------------------------------------------------------
--Timer for XController-----------------------------------------------------------------------
----------------------------------------------------------------------------------------------	
	process(clk50, xTimer, xRefresh)	
	variable xRefreshTime   : integer range 0 to 50_000_000 := 0;
	begin
 
	if(xTrigger = '1') then 
									xTimer        <= 0;
									xRefreshTime  := 0;
	elsif(rising_edge(clk50)) then xRefreshTime := xRefreshTime + 1;
			if(xRefreshTime = 10_000) then xRefreshTime := 0;							   
				if(xTimer = 1)   then   xTimer <= xTimer;
				else                    xTimer <= xTimer + 1;
				end if;
			end if;
	end if;
	end process;

----------------------------------------------------------------------------------------------
--FSM for XController-------------------------------------------------------------------------
----------------------------------------------------------------------------------------------	
	process(clk50)
	begin
	if(rising_edge(clk50)) then 
		if(reset = '1') then prev_xState <= Idle;
		else                 prev_xState <= next_xState;
		end if;
	end if;
	end process;
	
	process(prev_xState, xRefresh, Lt, Rt, xTimer, xTrigger)
	begin
		xRefresh <= '0';
		case (prev_xState) is 
			when Idle => 
						if   (Lt = '1' and Rt = '0') then next_xState <= Lft;
														  xRefresh <= '1';
						elsif(Lt = '0' and Rt = '1') then next_xState <= Rght;
						else                              next_xState <= Idle;
						end if;

					
			when Lft => 
						if(xTimer = 1 and (xRange > 0)) then xRefresh <= '1';
						end if;
						
						if   (Lt = '1')  then next_xState <= Lft;
						else                  next_xSTate <= Idle;
						end if;
				
								                
			when Rght => 
						if(xTimer = 1 and (xRange < 640)) then xRefresh <= '1';
						end if;
						if   (Rt = '1')  then next_xState <= Rght;
						else                  next_xSTate <= Idle;
						end if;
				
						
	
    end case;
	
 	end process;		 
	--Delay to prevent glitch when switching from state to state
	process(clk50, xTrigger, xRefresh)
	variable xEcounter : natural range 0 to 50_000_000;
	begin
	
	if(rising_edge(clk50)) then 
		xTrigger <= xRefresh;
	end if;
	
	if(rising_edge(clk50)) then
		if(xEcounter = 1_000_000) then  xE <= not xE;
										xEcounter := 0;
		else                            xEcounter := xEcounter + 1;
		end if;
	end if;
	end process;  
	
	
	process(xE, xRange, prev_xState, Lt, Rt)
	begin
	
	if(rising_edge(xE)) then
		if   (prev_xState = Lft and Lt = '1')  then 
			if(xRange > 0) then xRange <= xRange - 4;
			end if;
		elsif(prev_xState = Rght and Rt = '1') then
			if(xRange < 640) then xRange <= xRange + 4;	
		 	end if;
		else xRange <= xRange;
		end if;
	end if;
	end process;
----------------------------------------------------------------------------------------------
--Timer for YConroller-----------------------------------------------------------------------
----------------------------------------------------------------------------------------------	
	process(clk50, yTimer, yRefresh)	
	variable yRefreshTime   : integer range 0 to 50_000_000 := 0;
	begin
 
	if(yTrigger = '1') then 
									yTimer        <= 0;
									yRefreshTime  := 0;
	elsif(rising_edge(clk50)) then yRefreshTime := yRefreshTime + 1;
			if(yRefreshTime = 50_000_000) then yRefreshTime := 0;							   
				if(yTimer = 1)   then   yTimer <= yTimer;
				else                yTimer <= yTimer + 1;
				end if;
			end if;
	end if;
	end process;

----------------------------------------------------------------------------------------------
--FSM for YController-------------------------------------------------------------------------
----------------------------------------------------------------------------------------------	
	process(clk50)
	begin
	if(rising_edge(clk50)) then 
		if(reset = '1') then prev_yState <= Mid;
		else                 prev_yState <= next_yState;
		end if;
	end if;
	end process;
	
	process(prev_yState, yRefresh, yCounter, Up, Down, yTimer, yTrigger)
	begin
		yRefresh <= '0';
		case (prev_yState) is 
			when Bot => 
						
						yCounter <= 2;
						if(yTimer = 1) then
							if(Up = '1' and Down = '0') then next_yState <= Mid;
															 yRefresh <= '1';
							else                             next_yState <= Bot;
							end if;
						else                                 next_yState <= Bot;
						end if;

					
			when Mid => 
						
						yCounter <= 1;
						if(yTimer = 1) then
							if   (Up = '1' and Down = '0') then next_yState <= Top;
											      			    yRefresh <= '1';
							elsif(Up = '0' and Down = '1') then next_yState <= Bot;
												   			    yRefresh <= '1';
							else                                next_yState <= Mid;
							end if;
						else next_yState <= Mid;
						end if;
					 
								                
			when Top => 
				
						yCounter <= 0;
						if(yTimer = 1) then
							if(Up = '0' and Down = '1') then next_yState <= Mid;
															 yRefresh <= '1';
							else                             next_yState <= Top;
							end if;
						else next_yState <= Top;
						end if;
						
	
    end case;
	
 	end process;		 
	--Delay to prevent glitch when switching from state to state
	process(clk50, yTrigger, yRefresh)
	begin
	
	if(rising_edge(clk50)) then 
		yTrigger <= yRefresh;
	end if;	
	end process;
----------------------------------------------------------------------------------------------
--Timer for game------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------	
	
	process(clk50)	
	variable gameCounter	 : integer range 0 to 50_000_000 := 0;
	begin
 
	if(startGame = '1') then 
		if(rising_edge(clk50)) then gameCounter := gameCounter + 1;
			if(gameCounter = 50_000_000) then gameCounter   := 0;
										      gameTime <= gameTime + 1;
			end if;
		end if;
	else
		gameTime      <=0;
		gameCounter  := 0;
	end if;
	end process;

----------------------------------------------------------------------------------------------
--FSM for Game-----------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
	
	process(clk25)
	begin
	if   (reset = '1')        then prev_gameState <= Start;
	elsif(rising_edge(clk25)) then prev_gameState <= next_gameState;
	end if;
	end process;

	process (prev_gameState)
	variable     x      	 : integer range 0    to xMax;
	variable     y       	 : integer range 0    to 525;
	variable yOne            : integer := yCoord(0);
	variable yTwo            : integer := yCoord(1);
	variable yThree          : integer := yCoord(2);
	variable target_counter0 : integer range xMin to xMax := 0;
	variable target_counter1 : integer range xMin to xMax := 0;
	variable target_counter2 : integer range xMin to xMax := 0;  
		
	begin
 --Count columns:------------------------
	pos_edgeCounter(clk25, Hactive, x);
 --Count lines:--------------------------
	pos_edgeCounter(hsync, Vactive, y);

--------------------------------------------------------
 --Generate the image:-------------------
--If display enabled is true, draw targets with switches being background----					

	case (prev_gameState) is
		
		when Start =>  
						if (dena = '1') then
							r <= (others => '1');
							g <= (others => '0');
							b <= (others => '0');
						else
							r <= (others => '0');
							g <= (others => '0');
							b <= (others => '0');
						end if;
						
						if(reset = '1') then startGame <= '0';
						else                 startGame <= '1';
						end if;
						if (gameTime = 3) then next_gameState    <= Play;
						else                   next_gameState    <= Start;
						end if;
		when Play  =>
						
						--Counter:-------------------------------
						intCounter(target_clock0, 800, -100, target_counter0);
						intCounter(target_clock1, 800, -100, target_counter1);
						intCounter(target_clock2, 800, -100, target_counter2);
						if (dena = '1') then
						
						r <= (others => '0');
						g <= (others => '1');
						b <= (others => '0');
	
						for i in 0 to nTargets-1 loop  --Loop to create circles	
							drawDisc(x, y, target_counter0, yOne, radii1((nTargets-1)-i), color(customColor1((nTargets-1)-i)), r, g, b);
						end loop;
						
						for i in 0 to nTargets-1 loop  --Loop to create circles	
							drawDisc(x, y, target_counter1, yTwo, radii2((nTargets-1)-i), color(customColor2((nTargets-1)-i)), r, g, b);
						end loop;
						
						for i in 0 to nTargets-1 loop  --Loop to create circles	
							drawDisc(x, y, target_counter2, yThree, radii3((nTargets-1)-i), color(customColor3((nTargets-1)-i)), r, g, b);
						end loop;
						
						
						drawReticule(x, y, xRange, yCoord(yCounter), 6, color(0), r, g, b);
						
						
					
						
						else
							r <= (others => '0');
							g <= (others => '0');
							b <= (others => '0');
						end if;
						
							if(gameTime = 60) then next_gameState <= Menu; 
						else                   next_gameState <= Play;
						end if;
						startGame <= '1';
						
		when Menu => 
					startGame <= '0';
					if (dena = '1') then
						if(totalScore > 60) then
						r <= (others => '0');
						g <= (others => '0');
						b <= (others => '1');
						
						else
						r <= (others => '1');
						g <= (others => '0');
						b <= (others => '0');
						end if;
						
					else
						r <= (others => '0');
						g <= (others => '0');
						b <= (others => '0');
					end if;
					
				
					next_gameState <= Menu;
						
		end case;

	end process;	
end FSM;
 
