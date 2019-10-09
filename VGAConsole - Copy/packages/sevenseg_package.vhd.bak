library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all; -- for vector type addition operator
use work.shape_package.all;
use work.properties_package.all;

----------------------------Package---------------------------------------------------
package SevenSeg is 
procedure SevenSeg_shapes(
					variable x, y              : in natural;
					--constant xStart, xEnd,
					--		 yStart, yEnd      : in natural;
					constant color             : in std_logic_vector(2 downto 0);
					signal r, g, b             : out std_logic_vector(9 downto 0));
					
procedure bcd_7segment(
					signal BCDin 					   : in natural;
					variable Seven_Segment 			   : out std_logic_vector(6 downto 0));
					
procedure SevSeg1(
					variable x, y 			   : in natural;
					variable atog		 			   : in std_logic_vector(6 downto 0);
					constant color			   : in std_logic_vector(2 downto 0);
					signal r, g, b			   : out std_logic_vector(9 downto 0));
					
procedure SevSeg2(
					variable x, y 			   : in natural;
					variable atog		 			   : in std_logic_vector(6 downto 0);
					constant color			   : in std_logic_vector(2 downto 0);
					signal r, g, b			   : out std_logic_vector(9 downto 0));
					
procedure SevSeg3(
					variable x, y 			   : in natural;
					variable atog		 			   : in std_logic_vector(6 downto 0);
					constant color			   : in std_logic_vector(2 downto 0);
					signal r, g, b			   : out std_logic_vector(9 downto 0));
					
procedure decode7seg(
					variable x, y 			   : in natural;
					signal BCDin1			   : in natural;
					signal BCDin2			   : in natural;
					signal BCDin3			   : in natural;
					constant color             : in std_logic_vector(2 downto 0);
					signal r, g, b			   : out std_logic_vector(9 downto 0));
		
end package;
----------------------------Package_Body-----------------------------------------------
package body SevenSeg is
	
procedure SevenSeg_shapes(
					variable x, y              : in natural;
					constant color             : std_logic_vector(2 downto 0);
					signal r, g, b             : out std_logic_vector(9 downto 0)) is

begin
------------------TOTAL-------------------------------
	drawBox(x, y, 540, 640, 0, 60, color, r, g, b);
	drawBox(x, y, 549, 551, 7, 17, "111", r, g, b);
	drawBox(x, y, 544, 556, 5, 7, "111", r, g, b);
	drawRing(x, y, 570, 11, 35, 25, "111", r, g, b);
	drawBox(x, y, 589, 591, 7, 17, "111", r, g, b);
	drawBox(x, y, 584, 596, 5, 7, "111", r, g, b);
	drawBox(x, y, 604, 606, 7, 17, "111", r, g, b);
	drawBox(x, y, 606, 614, 5, 7, "111", r, g, b);
	drawBox(x, y, 614, 616, 7, 17, "111", r, g, b);
	drawBox(x, y, 606, 614, 10, 12, "111", r, g, b);
	drawBox(x, y, 624, 626, 5, 17, "111", r, g, b);
	drawBox(x, y, 626, 634, 15, 17, "111", r, g, b);
------------------------------------------------------	
	
end procedure;
procedure bcd_7segment(
					signal BCDin 					   : in natural;
					variable Seven_Segment 			   : out STD_LOGIC_VECTOR (6 downto 0)) is

begin

case BCDin is

when 0 =>
Seven_Segment := "0000001"; ---0
when 1 =>
Seven_Segment := "1001111"; ---1
when 2 =>
Seven_Segment := "0010010"; ---2
when 3 =>
Seven_Segment := "0000110"; ---3
when 4 =>
Seven_Segment := "1001100"; ---4
when 5 =>
Seven_Segment := "0100100"; ---5
when 6 =>
Seven_Segment := "0100000"; ---6
when 7 =>
Seven_Segment := "0001111"; ---7
when 8 =>
Seven_Segment := "0000000"; ---8
when 9 =>
Seven_Segment := "0000100"; ---9
when others =>
Seven_Segment := "1111111"; ---null

end case;


end procedure;

procedure SevSeg1(
					variable x, y 			   : in natural;
					variable atog 			   : in std_logic_vector(6 downto 0);
					constant color			   : in std_logic_vector(2 downto 0);
					signal r, g, b			   : out std_logic_vector(9 downto 0)) is
begin
if (atog (0) = '0') then --g
drawBox(x, y, 606, 614, 39, 41, "111", r, g, b);
end if;
if  atog (1) = '0' then --f
drawBox(x, y, 604, 606, 27, 39, "111", r, g, b);
end if;
if  atog (2) = '0' then --e
drawBox(x, y, 604, 606, 41, 53, "111", r, g, b);
end if;
if  atog (3) = '0' then --d
drawBox(x, y, 606, 614, 53, 55, "111", r, g, b);
end if;
if  atog (4) = '0' then --c
drawBox(x, y, 614, 616, 41, 53, "111", r, g, b);
end if;
if  atog (5) = '0' then --b
drawBox(x, y, 614, 616, 27, 39, "111", r, g, b);
end if;
if  atog (6) = '0' then --a
drawBox(x, y, 606, 614, 25, 27, "111", r, g, b);
end if;

end procedure;	

procedure SevSeg2(
					variable x, y 			   : in natural;
					variable atog 			   : in std_logic_vector(6 downto 0);
					constant color			   : in std_logic_vector(2 downto 0);
					signal r, g, b			   : out std_logic_vector(9 downto 0)) is
begin
if (atog (0) = '0') then --g
drawBox(x, y, 586, 594, 39, 41, "111", r, g, b);
end if;
if  atog (1) = '0' then --f
drawBox(x, y, 584, 586, 27, 39, "111", r, g, b);
end if;
if  atog (2) = '0' then --e
drawBox(x, y, 584, 586, 41, 53, "111", r, g, b);
end if;
if  atog (3) = '0' then --d
drawBox(x, y, 586, 594, 53, 55, "111", r, g, b);
end if;
if  atog (4) = '0' then --c
drawBox(x, y, 594, 596, 41, 53, "111", r, g, b);
end if;
if  atog (5) = '0' then --b
drawBox(x, y, 594, 596, 27, 39, "111", r, g, b);
end if;
if  atog (6) = '0' then --a
drawBox(x, y, 586, 594, 25, 27, "111", r, g, b);
end if;

end procedure;

procedure SevSeg3(
					variable x, y 			   : in natural;
					variable atog 			   : in std_logic_vector(6 downto 0);
					constant color			   : in std_logic_vector(2 downto 0);
					signal r, g, b			   : out std_logic_vector(9 downto 0)) is
begin
if (atog (0) = '0') then --g
drawBox(x, y, 566, 574, 39, 41, "111", r, g, b);
end if;
if  atog (1) = '0' then --f
drawBox(x, y, 564, 566, 27, 39, "111", r, g, b);
end if;
if  atog (2) = '0' then --e
drawBox(x, y, 564, 566, 41, 53, "111", r, g, b);
end if;
if  atog (3) = '0' then --d
drawBox(x, y, 566, 574, 53, 55, "111", r, g, b);
end if;
if  atog (4) = '0' then --c
drawBox(x, y, 574, 576, 41, 53, "111", r, g, b);
end if;
if  atog (5) = '0' then --b
drawBox(x, y, 574, 576, 27, 39, "111", r, g, b);
end if;
if  atog (6) = '0' then --a
drawBox(x, y, 566, 574, 25, 27, "111", r, g, b);
end if;

end procedure;

procedure decode7seg(
					variable x, y 			   : in natural;
					signal BCDin1			   : in natural;
					signal BCDin2			   : in natural;
					signal BCDin3			   : in natural;
					constant color             : in std_logic_vector(2 downto 0);
					signal r, g, b			   : out std_logic_vector(9 downto 0)) is					
variable Seven_Segment1				   : STD_LOGIC_VECTOR(6 downto 0);
variable Seven_Segment2				   : STD_LOGIC_VECTOR(6 downto 0);
variable Seven_Segment3				   : STD_LOGIC_VECTOR(6 downto 0);

begin
bcd_7segment(BCDin1, Seven_Segment1);
SevSeg1(x,y,Seven_Segment1,color,r,g,b);
bcd_7segment(BCDin2, Seven_Segment2);
SevSeg2(x,y,Seven_Segment2,color,r,g,b);
bcd_7segment(BCDin3, Seven_Segment3);
SevSeg3(x,y,Seven_Segment3,color,r,g,b);
end procedure;
end package body;
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
