library ieee;

use ieee.std_logic_1164.all;


entity buttonController is
	port(
		Up, Down,
		Lft, Rght,
		Button                  : in  std_logic := '0';
		tttPlay, targetPlay,
		menuPlay, connect4Play  : in  std_logic := '0';
		Up0, Down0,
		Lft0, Rght0,
		Button0,
		Up1, Down1,
		Lft1, Rght1,
		Button1,
		Up2, Down2,
		Lft2, Rght2,
		Button2,
		Up3, Down3,
		Lft3, Rght3,
		Button3                 : out std_logic := '0');
end buttonController;

architecture behavioral of buttonController is

signal sel : std_logic_vector(3 downto 0); --011 = ttt : 101 = target : 110 = menu

begin

	  sel <= connect4Play & tttPlay & targetPlay & menuPlay;
	
	  process(sel)
	  begin
	
		  case (sel) is
				when "1110" => 
							Up0     <= Up;
							Down0   <= Down;
							Lft0    <= Lft;
							Rght0   <= Rght;
							Button0 <= Button;  
							 
							Up1     <= '0';
							Down1   <= '0';
							Lft1    <= '0';
							Rght1   <= '0';
							Button1 <= '0';    
							
							Up2     <= '0';
							Down2   <= '0';
							Lft2    <= '0';
							Rght2   <= '0';
							Button2 <= '0';
							
								
							Up3     <= '0';
							Down3   <= '0';
							Lft3    <= '0';
							Rght3   <= '0';
							Button3 <= '0';    
							
				when "1101" =>
							Up1     <= Up;
							Down1   <= Down;
							Lft1    <= Lft;
							Rght1   <= Rght;
							Button1 <= Button; 
							
							Up0     <= '0';
							Down0   <= '0';
							Lft0    <= '0';
							Rght0   <= '0';
							Button0 <= '0';   
							
							Up2     <= '0';
							Down2   <= '0';
							Lft2    <= '0';
							Rght2   <= '0';
							Button2 <= '0';   
							
								
							Up3     <= '0';
							Down3   <= '0';
							Lft3    <= '0';
							Rght3   <= '0';
							Button3 <= '0'; 
				
				when "1011" =>
							Up2     <= Up;
							Down2   <= Down;
							Lft2    <= Lft;
							Rght2   <= Rght;
							Button2 <= Button; 
							
							Up0     <= '0';
							Down0   <= '0';
							Lft0    <= '0';
							Rght0   <= '0';
							Button0 <= '0';
							
							Up1     <= '0';
							Down1   <= '0';
							Lft1    <= '0';
							Rght1   <= '0';
							Button1 <= '0';
							
								
							Up3     <= '0';
							Down3   <= '0';
							Lft3    <= '0';
							Rght3   <= '0';
							Button3 <= '0'; 
							   
				when "0111" => 
							
							Up3     <= Up;
							Down3   <= Down;
							Lft3    <= Lft;
							Rght3   <= Rght;
							Button3 <= Button;   
							
							Up0     <= '0';
							Down0   <= '0';
							Lft0    <= '0';
							Rght0   <= '0';
							Button0 <= '0';   
							
							Up1     <= '0';
							Down1   <= '0';
							Lft1    <= '0';
							Rght1   <= '0';
							Button1 <= '0';  
							
							Up2     <= '0';
							Down2   <= '0';
							Lft2    <= '0';
							Rght2   <= '0';
							Button2 <= '0'; 
						
				            			
				when others => 
							Up0     <= '0';
							Down0   <= '0';
							Lft0    <= '0';
							Rght0   <= '0';
							Button0 <= '0';   
							
							Up1     <= '0';
							Down1   <= '0';
							Lft1    <= '0';
							Rght1   <= '0';
							Button1 <= '0';  
							
							Up2     <= '0';
							Down2   <= '0';
							Lft2    <= '0';
							Rght2   <= '0';
							Button2 <= '0';  
							
								
							Up3     <= '0';
							Down3   <= '0';
							Lft3    <= '0';
							Rght3   <= '0';
							Button3 <= '0';      
		end case;
	end process;
	   
end behavioral;


