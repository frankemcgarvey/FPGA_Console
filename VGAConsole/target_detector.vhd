library ieee;
use ieee.std_logic_1164.all;
use work.target_package.all;

entity targetDetector is
	port(
	x           	      : in  integer range -100 to 800;
	button                : in  std_logic := '0';
	numberOne, numberTwo  : out integer range 0 to 10);  
end targetDetector;

architecture behavior of targetDetector is
begin				
	process(button)
	variable detector     : integer;
	begin
		detector := (320 - x)*(320 - x);
		if(button'EVENT and button = '1') then
			if   (detector <  50 or detector = 0) then numberOne <= 5; numberTwo <= 0;
			elsif(detector <  400)                 then numberOne <= 3; numberTwo <= 0; 
			elsif(detector < 1000) 				   then numberOne <= 2; numberTwo <= 0;
			elsif(detector < 2000)				   then numberOne <= 1; numberTwo <= 0;
			elsif(detector < 3200)				   then numberOne <= 5; numberTwo <= 10;
			else                                        numberOne <= 0; numberTwo <= 0;
			end if;
		end if;
	end process;
				
end behavior;

