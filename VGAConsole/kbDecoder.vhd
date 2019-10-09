library ieee;
use ieee.std_logic_1164.all;



entity kbDecoder is
	port(
		clk50           : std_logic;
		word   			: in  std_logic_vector(7 downto 0) := (others => '0');
		ps2flag   	    : in  std_logic := '0';
		Up, Down,
		Lft, Rght,
		Replay, 
		toMenu,
		SB              : out std_logic := '0');
	
end kbDecoder;
architecture behavioral of kbDecoder is
signal timer         : std_logic := '0';
signal trigger,
       refresh       : std_logic := '0';
signal prev_ps2Flag  : std_logic := '0';
begin


	process(clk50)	
	begin
	if(rising_edge(clk50)) then trigger <= refresh;
	end if;
	end process;
	
	
	
	process(clk50)

	begin
	
	if(rising_edge(clk50)) then
	prev_ps2Flag <= ps2Flag;
	
	if(prev_ps2Flag = '0' and ps2Flag = '1' ) then 
			case (word) is
					when x"1D" => --Up
						
								
								Up     <= '1';
								
						
						
					when x"1B" => --Down
						
								
								Down <= '1';
								
							
					when x"23" => --Right
						
								
								Rght <= '1';
								
							
					when x"1C" => --Left
						
								
								Lft  <= '1';
								
						
					when x"29" => --Spacebar
						
								
								SB   <= '1';
					
					
					when x"2D" => --Replay
								
								Replay <= '1';
								
					when x"3A" => --toMenu
							  
							   toMenu <= '1';
					when x"F0" =>
						
								Up     <= '0';
								Down   <= '0';
								Lft    <= '0';
								Rght   <= '0';
								Replay <= '0';
								toMenu <= '0';
								SB     <= '0';
					
							
					when others => null;
				end case;
	else 		
		Up     <= '0';
		Down   <= '0';
		Lft    <= '0';
		Rght   <= '0';
		Replay <= '0';
		toMenu <= '0';
		SB     <= '0';
	end if;	
	end if;					
	end process;

end behavioral;