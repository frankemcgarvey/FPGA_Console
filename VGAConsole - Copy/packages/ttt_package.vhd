library ieee;
use ieee.std_logic_1164.all;
use work.target_package.all;
use work.shape_package.all;
use work.properties_package.all;

----------------------------Package---------------------------------------------------
package ttt_package is 

function winCondition(field0 : std_logic_vector(1 downto 0); field1 : std_logic_vector(1 downto 0); field2 : std_logic_vector(1 downto 0);
                       field3 : std_logic_vector(1 downto 0); field4 : std_logic_vector(1 downto 0); field5 : std_logic_vector(1 downto 0); 
					   field6 : std_logic_vector(1 downto 0); field7 : std_logic_vector(1 downto 0); field8 : std_logic_vector(1 downto 0); 
					   symbol : std_logic_vector(1 downto 0))
					   return std_logic;
procedure drawXorO(
					variable x, y 		 	   : in  natural;
					signal   sel       	       : in  std_logic_vector(1 downto 0);
					constant x_xPosL, x_xPosR,
							 y_xPos,
							 x_oPos, y_oPos    : in  integer;
					signal   r, g, b   	       : out std_logic_vector(9 downto 0)); 
procedure drawPound(
					variable x, y              : in natural;
					--constant xStart, xEnd,
					--		 yStart, yEnd      : in natural;
					constant color             : std_logic_vector(2 downto 0);
					signal r, g, b             : out std_logic_vector(9 downto 0));	
					
		
end package;
---------------------------------------------------------------------------------------
----------------------------Package_Body-----------------------------------------------
package body ttt_package  is

function winCondition( field0 : std_logic_vector(1 downto 0); field1 : std_logic_vector(1 downto 0); field2 : std_logic_vector(1 downto 0);
                       field3 : std_logic_vector(1 downto 0); field4 : std_logic_vector(1 downto 0); field5 : std_logic_vector(1 downto 0); 
					   field6 : std_logic_vector(1 downto 0); field7 : std_logic_vector(1 downto 0); field8 : std_logic_vector(1 downto 0); 
					   symbol : std_logic_vector(1 downto 0)) 
					   return std_logic is
begin

	if(symbol = "01") then
		if   ((field0 = field1) and (field1 = field2)) then return '1';
		elsif((field3 = field4) and (field4 = field5)) then return '1';
		elsif((field6 = field7) and (field7 = field8)) then return '1';
		elsif((field8 = field5) and (field5 = field2)) then return '1';
		elsif((field7 = field4) and (field4 = field1)) then return '1';
		elsif((field6 = field3) and (field3 = field0)) then return '1';
		elsif((field8 = field4) and (field4 = field0)) then return '1';
		elsif((field6 = field4) and (field4 = field2)) then return '1';
		else                                                return '0';
		end if;
	elsif(symbol = "10") then 
		if   ((field0 = field1) and (field1 = field2)) then return '1';
		elsif((field3 = field4) and (field4 = field5)) then return '1';
		elsif((field6 = field7) and (field7 = field8)) then return '1';
		elsif((field8 = field5) and (field5 = field2)) then return '1';
		elsif((field7 = field4) and (field4 = field1)) then return '1';
		elsif((field6 = field3) and (field3 = field0)) then return '1';
		elsif((field8 = field4) and (field4 = field0)) then return '1';
		elsif((field6 = field4) and (field4 = field2)) then return '1';
		else                                                return '0';
		end if;

	end if;

end function;
----------------------------------------------------------------------------------------
procedure drawPound(
					variable x, y              : in natural;
					--constant xStart, xEnd,
					--		 yStart, yEnd      : in natural;
					constant color             : std_logic_vector(2 downto 0);
					signal r, g, b             : out std_logic_vector(9 downto 0)) is

begin
------------------Hashtag-------------------------------
	drawBox(x, y, 250, 280, 100, 400, color, r, g, b);
	drawBox(x, y, 360, 390, 100, 400, color, r, g, b);
	drawBox(x, y, 170, 470, 290, 320, color, r, g, b);
	drawBox(x, y, 170, 470, 180, 210, color, r, g, b);


end procedure;


procedure drawXorO(
					variable x, y 		 	   : in  natural;
					signal   sel       	       : in  std_logic_vector(1 downto 0);
					constant x_xPosL, x_xPosR,
							 y_xPos,
							 x_oPos, y_oPos    : in  integer;
					signal   r, g, b   	       : out std_logic_vector(9 downto 0)) is
	
begin
--variable x, y              : in integer;
--						constant xStart, yStart,
--								 ring, iRing       : in natural;
--						constant color             : std_logic_vector(2 downto 0);
--						signal r, g, b             : out std_logic_vector(9 downto 0))
	if   (sel = "01") then    drawX(x, y, 50, x_xPosL, x_xPosR, y_xPos, color(7), r, g, b);
	elsif(sel = "10") then drawRing(x, y, x_oPos, y_oPos, 1250, 300, color(7), r, g, b);
	elsif(sel = "11") then null;
	else                   null;
	end if;
end procedure;

end package body; 