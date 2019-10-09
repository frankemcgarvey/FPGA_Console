library ieee;
use ieee.std_logic_1164.all;
use work.shape_package.all;
use work.ttt_package.all;
use work.properties_package.all;
use work.counter_package.all;
use work.target_package.all;
use ieee.numeric_std.all;

entity gameController is
	port(
	clk50,
	reset,
	tttInput,
	targetInput,
	connect4Input,
	targetReplay,
	tttReplay,
	connect4Replay   : in  std_logic := '0';
	tttPlay,
	targetPlay,
	menuPlay,
	connect4Play     : out std_logic := '1');

end gameController;


	

architecture FSM of gameController is


	type gameState is (Menu, targetGame, targetRefresh, tttGame, tttRefresh, connect4Game, connect4Refresh);
	signal next_gameState, prev_gameState : gameState := Menu;
	
	
	signal conRefresh, conTrigger : std_logic := '0';
	signal conTimer               : natural range 0 to 60;
begin

----------------------------------------------------------------------------------------------
--Timer for controller------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
process(clk50, conTimer, conRefresh)	
	variable conRefreshTime   : integer range 0 to 50_000_000 := 0;
	begin
 
	if(conTrigger = '1') then 
									conTimer        <= 0;
									conRefreshTime  := 0;
	elsif(rising_edge(clk50)) then
			if(conRefreshTime = 20_000_000) then conRefreshTime := 20_000_000;							   
												 conTimer <= 1;
			else 								 conRefreshTime := conRefreshTime + 1;
			end if;
	end if;
	end process;
-------------------------------------------------------------------------------
--Controller-------------------------------------------------------------------
-------------------------------------------------------------------------------
	process(clk50)
	begin
	
	if   (reset = '1')        then prev_gameState <= Menu;
	elsif(rising_edge(clk50)) then prev_gameState <= next_gameState;

	end if;
	end process;
	
	process(prev_gameState)
	begin
	
		
		case (prev_gameState) is
			when Menu =>
					conRefresh   <= '0';
					tttPlay      <= '1';
					targetPlay   <= '1';
					connect4Play <= '1';
					menuPlay     <= '0';
					
					if   (tttInput = '0' and targetInput = '1' and connect4Input = '0') then next_gameState <= targetGame;
					elsif(tttInput = '1' and targetInput = '0' and connect4Input = '0') then next_gameState <= tttGame;
					elsif(tttInput = '0' and targetInput = '0' and connect4Input = '1') then next_gameSTate <= connect4Game;
					else                                             						 next_gameState <= Menu;
					end if;
			
			when targetGame =>
					conRefresh   <= '0';
					tttPlay    	 <= '1';
					targetPlay 	 <= '0';
					connect4Play <= '1';
					menuPlay   	 <= '1';
					
					if (targetReplay = '1') then next_gameState <= targetRefresh; conRefresh <= '1';
					else  					     next_gameState <= targetGame;
					end if;
					
					
			when targetRefresh =>
					conRefresh   <= '0';
					tttPlay    	 <= '1';
					targetPlay 	 <= '1';
					connect4Play <= '1';
					menuPlay  	 <= '1';
					
					if(conTimer = 1) then next_gameState <= targetGame;
					else                  next_gamestate <= targetRefresh;
					end if;
					
			when tttGame =>
					conRefresh   <= '0';
					tttPlay    	 <= '0';
					targetPlay 	 <= '1';
					connect4Play <= '1';
					menuPlay   	 <= '1';
					
					if(tttReplay = '1') then next_gameState <= tttRefresh; conRefresh <= '1';
					else                     next_gameState <= tttGame;
					end if;
					
			when tttRefresh =>
					conRefresh   <= '0';
					tttPlay      <= '1';
					targetPlay   <= '1';
					connect4Play <= '1';
					menuPlay   	 <= '1';
					
					if(conTimer = 1) then next_gameState <= tttGame;
					else                  next_gameState <= tttRefresh;
					end if;
			
			when connect4Game =>
					conRefresh   <= '0';
					tttPlay    	 <= '1';
					targetPlay   <= '1';
					connect4Play <= '0';
					menuPlay   	 <= '1';
					
					if(connect4Replay = '1') then next_gameState <= connect4Refresh; conRefresh <= '1';
					else                     	  next_gameState <= connect4Game;
					end if;
					
			when connect4Refresh =>
					conRefresh   <= '0';
					tttPlay    	 <= '1';
					targetPlay 	 <= '1';
					connect4Play <= '1';
					menuPlay   	 <= '1';
					
					if(conTimer = 1) then next_gameState <= connect4Game;
					else                  next_gameState <= connect4Refresh;
					end if;
					
		end case;
	
	end process;
	
	--Delay to prevent glitch when switching from state to state
	process(clk50, conTrigger, conRefresh)
	begin
	if(rising_edge(clk50)) then conTrigger <= conRefresh;
	end if;	
	end process;
end FSM;
