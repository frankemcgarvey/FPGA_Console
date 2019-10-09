library ieee;
use ieee.std_logic_1164.all;
use work.counter_package.all;
use work.properties_package.all;
use work.shape_package.all;

entity mainScreen is
	port(
		clk25,
		clk50,
		hsync, 
		hactive,
		vactive, 
		dena,
		reset,
		up, down,
		lt, rt, sel   : in  std_logic := '0';
		gameSel       : out std_logic_vector(2 downto 0) := (others => '0');
		r, g, b		  : out std_logic_vector(9 downto 0)
		);
end mainScreen;

architecture FSM of mainScreen is
-------------States------------------------------------------
type cursorState is (Bot, Top, Mid);
	signal prev_cursorState, next_cursorState : cursorState := Top;
-------------------------------------------------------------
-------------Signals-----------------------------------------
signal xPix, yPix : natural range 0 to 800;
signal xPos : natural := 320;
signal cursorEn : std_logic_vector(2 downto 0) := "000";
--Cursor Data---------------
signal cursorTrigger,
	   cursorRefresh   : std_logic := '0';
signal cursorTimer     : natural range 0 to 60;
	-----------------------------
-------------------------------------------------------------
begin 

--Count columns:------------------------
process(clk25)
begin
pos_edgeCounter(clk25, Hactive, xPix);
end process;
----------------------------------------

--Count lines:--------------------------
process(hsync)
begin
pos_edgeCounter(hsync, Vactive, yPix);
end process;
---------------------------------------
---------------------------------------------------------------------------------------------
--Timer for cursorConroller------------------------------------------------------------------
---------------------------------------------------------------------------------------------

process(clk50)

variable cursorRefreshTime   : integer range 0 to 50_000_000 := 0;
begin
 
if(cursorTrigger = '1') then 
								cursorTimer        <= 0;
								cursorRefreshTime  := 0;
elsif(rising_edge(clk50)) then 
		cursorRefreshTime := cursorRefreshTime + 1;
		if(cursorRefreshTime = 10_000_000) then cursorRefreshTime := 0;							   
			if(cursorTimer = 1)   then   cursorTimer <= 1;
			else                cursorTimer <= cursorTimer + 1;
			end if;
		end if;
else null;
end if;
end process;


----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--FSM for cursorController--------------------------------------------------------------------
----------------------------------------------------------------------------------------------	
	process(clk50)
	begin
	if(rising_edge(clk50)) then 
		
		if(reset = '1') then prev_cursorState <= Top;
		else                 prev_cursorState <= next_cursorState;
		end if;
	end if;
	end process;
	
	process(prev_cursorState)
	begin
		cursorRefresh <= '0';
		case (prev_cursorState) is 
		
		when Top =>
		
				cursorEn <= "001";
				if(cursorTimer = 1) then
					if   (Up = '0' and Down = '1') then next_cursorState <= Mid;   cursorRefresh <= '1';
					else 													      next_cursorState <= Top;
					end if;
				else                                                              next_cursorState <= Top;
				end if;
		when Bot =>
		
				cursorEn <= "010";
				if(cursorTimer = 1) then
					if (Up = '1' and Down = '0') then next_cursorState <= Mid; cursorRefresh <= '1';
					else						                                next_cursorState <= Bot;
					end if;
				else 														    next_cursorState <= Bot;
				end if;
				
		when Mid =>
				
				cursorEn <= "100";
				if(cursorTimer = 1) then
					if (Up = '1' and Down = '0') then next_cursorState <= Top; cursorRefresh <= '1';
				 elsif (Up = '0' and Down = '1') then next_cursorState <= Bot; cursorRefresh <= '1';
					else 														next_cursorState <= Mid;
				end if;
				else                                                            next_cursorState <= Mid;
		 		end if;
		end case;
	end process;
process(clk50)
	begin
	if(rising_edge(clk50)) then 
		case (prev_cursorState) is 
		
		when Top =>
				
				if(sel = '1') then 
					 gameSel <= "001";
				else gameSel <= "000";
				end if;
				
		when Bot =>
				if(sel = '1') then 	gameSel <= "100";	 
				else                gameSel <= "000";
				end if;
		when Mid =>
				if(sel = '1') then gameSel <= "010";
				else               gameSel <= "000";
				end if;
		end case;
	end if;
end process;

--Delay to prevent glitch when switching from state to state
	process(clk50)
	begin
	if(rising_edge(clk50)) then cursorTrigger <= cursorRefresh;
	end if;	
	end process;

------Main Screen Static Images-----------------------------------
process(clk50)
variable x, y : natural range 0 to 800;
variable yPos : natural := 240;
begin
x:= xPix;
y:= yPix;
if(rising_edge(clk50)) then
----------Background--------------------
	if dena = '1' then
		r <= (others => '1');
		g <= (others => '1');
		b <= (others => '0');
		drawBox(x, y, 140, 500, 150, 460, color(1), r, g, b);
----------------------------------------
--------"CHOOSE A GAME:"----------------
--C--
drawBox(x, y, 50, 60, 60, 90, color(4), r, g, b);
drawBox(x, y, 60, 90, 90, 100, color(4), r, g, b);
drawBox(x, y, 60, 90, 50, 60, color(4), r, g, b);
-----
--H--
drawBox(x, y, 100, 110, 50, 100, color(4), r, g, b);
drawBox(x, y, 130, 140, 50, 100, color(4), r, g, b);
drawBox(x, y, 109, 131, 70, 80, color(4), r, g, b);
-----
--O--
drawBox(x, y, 150, 160, 60, 90, color(4), r, g, b);
drawBox(x, y, 160, 180, 90, 100, color(4), r, g, b);
drawBox(x, y, 160, 180, 50, 60, color(4), r, g, b);
drawBox(x, y, 180, 190, 60, 90, color(4), r, g, b);
-----
--O--
drawBox(x, y, 200, 210, 60, 90, color(4), r, g, b);
drawBox(x, y, 210, 230, 90, 100, color(4), r, g, b);
drawBox(x, y, 210, 230, 50, 60, color(4), r, g, b);
drawBox(x, y, 230, 240, 60, 90, color(4), r, g, b);
-----
--S--
drawBox(x, y, 250, 290, 90, 100, color(4), r, g, b);
drawBox(x, y, 250, 290, 50, 60, color(4), r, g, b);
drawBox(x, y, 250, 290, 70, 80, color(4), r, g, b);
drawBox(x, y, 250, 260, 59, 71, color(4), r, g, b);
drawBox(x, y, 280, 290, 79, 91, color(4), r, g, b);
-----
--E--
drawBox(x, y, 300, 310, 50, 100, color(4), r, g, b);
drawBox(x, y, 309, 340, 50, 60, color(4), r, g, b);
drawBox(x, y, 309, 340, 70, 80, color(4), r, g, b);
drawBox(x, y, 309, 340, 90, 100, color(4), r, g, b);
-----
--A--
drawBox(x, y, 450, 460, 60, 100, color(4), r, g, b);
drawBox(x, y, 480, 490, 60, 100, color(4), r, g, b);
drawBox(x, y, 460, 480, 50, 60, color(4), r, g, b);
drawBox(x, y, 459, 481, 70, 80, color(4), r, g, b);
-----
--G--
drawBox(x, y, 200, 210, 130, 160, color(4), r, g, b);
drawBox(x, y, 210, 240, 120, 130, color(4), r, g, b);
drawBox(x, y, 210, 240, 160, 170, color(4), r, g, b);
drawBox(x, y, 230, 240, 140, 161, color(4), r, g, b);
drawBox(x, y, 220, 231, 140, 150, color(4), r, g, b);
-----
--A--
drawBox(x, y, 260, 280, 120, 130, color(4), r, g, b);
drawBox(x, y, 250, 260, 130, 170, color(4), r, g, b);
drawBox(x, y, 280, 290, 130, 170, color(4), r, g, b);
drawBox(x, y, 259, 281, 140, 150, color(4), r, g, b);
-----
--M--
drawBox(x, y, 300, 310, 120, 170, color(4), r, g, b);
drawBox(x, y, 330, 340, 120, 170, color(4), r, g, b);
drawBox(x, y, 315, 325, 129, 135, color(4), r, g, b);
drawBox(x, y, 309, 315, 125, 130, color(4), r, g, b);
drawBox(x, y, 325, 331, 125, 130, color(4), r, g, b);
drawBox(x, y, 317, 323, 134, 140, color(4), r, g, b);
-----
--E--
drawBox(x, y, 350, 360, 120, 170, color(4), r, g, b);
drawBox(x, y, 359, 390, 120, 130, color(4), r, g, b);
drawBox(x, y, 359, 390, 140, 150, color(4), r, g, b);
drawBox(x, y, 359, 390, 160, 170, color(4), r, g, b);
-----
--:--
drawBox(x, y, 400, 410, 150, 160, color(4), r, g, b);
drawBox(x, y, 400, 410, 130, 140, color(4), r, g, b);
-----
--Target--
drawDisc(x, y, xPos, yPos, 1000, color(7), r, g, b);
drawDisc(x, y, xPos, yPos, 550, color(0), r, g, b);
drawDisc(x, y, xPos, yPos, 270, color(1), r, g, b);
drawDisc(x, y, xPos, yPos, 90, color(4), r, g, b);
drawDisc(x, y, xPos, yPos, 20, color(6), r, g, b);
----------
--#--
drawBox(x, y, 302, 314, 280, 340, color(0), r, g, b);
drawBox(x, y, 326, 338, 280, 340, color(0), r, g, b);
drawBox(x, y, 290, 350, 292, 304, color(0), r, g, b);
drawBox(x, y, 290, 350, 316, 328, color(0), r, g, b);
drawRing(x, y, 320, 310, 35, 10, color(7), r, g, b);
drawRing(x, y, 344, 286, 35, 10, color(7), r, g, b);
drawRing(x, y, 296, 334, 35, 10, color(7), r, g, b); 
-----
--Connect4--
drawBox(x, y, 290, 294, 360, 420, color(0), r, g, b); --column0
drawBox(x, y, 300, 304, 360, 420, color(0), r, g, b); --column1
drawBox(x, y, 310, 314, 360, 420, color(0), r, g, b); --column2
drawBox(x, y, 320, 324, 360, 420, color(0), r, g, b); --column3
drawBox(x, y, 330, 334, 360, 420, color(0), r, g, b); --column4
drawBox(x, y, 340, 344, 360, 420, color(0), r, g, b); --column5
drawBox(x, y, 350, 354, 360, 420, color(0), r, g, b); --column6
drawBox(x, y, 360, 364, 360, 420, color(0), r, g, b); --column7
-----------------------------------------------------	
drawBox(x, y, 290, 364, 360, 364, color(0), r, g, b); --row0
drawBox(x, y, 290, 364, 370, 374, color(0), r, g, b); --row1
drawBox(x, y, 290, 364, 380, 384, color(0), r, g, b); --row2
drawBox(x, y, 290, 364, 390, 394, color(0), r, g, b); --row3
drawBox(x, y, 290, 364, 400, 404, color(0), r, g, b); --row4
drawBox(x, y, 290, 364, 410, 414, color(0), r, g, b); --row5
drawBox(x, y, 290, 364, 419, 423, color(0), r, g, b); --row6
-----------------------------------------------------
drawDiscs(x, y, 297, 417, 7, color(4), r, g, b);
drawDiscs(x, y, 307, 417, 7, color(2), r, g, b);
drawDiscs(x, y, 317, 417, 7, color(4), r, g, b);
drawDiscs(x, y, 317, 407, 7, color(2), r, g, b);
drawDiscs(x, y, 307, 407, 7, color(4), r, g, b);
drawDiscs(x, y, 327, 397, 7, color(2), r, g, b);
drawDiscs(x, y, 337, 387, 7, color(2), r, g, b);
drawDiscs(x, y, 327, 407, 7, color(4), r, g, b);
drawDiscs(x, y, 327, 417, 7, color(2), r, g, b);
drawDiscs(x, y, 337, 417, 7, color(4), r, g, b);
drawDiscs(x, y, 337, 407, 7, color(2), r, g, b);
drawDiscs(x, y, 337, 397, 7, color(4), r, g, b);
drawDiscs(x, y, 347, 417, 7, color(2), r, g, b);
------------
--Sel--
--#Sel--
if cursorEn = "100" then
drawBox(x, y, 240, 260, 303, 317, color(4), r, g, b);
drawBox(x, y, 259, 265, 300, 320, color(4), r, g, b);
drawBox(x, y, 264, 270, 305, 315, color(4), r, g, b);
drawBox(x, y, 269, 275, 307, 313, color(4), r, g, b);
end if;
--TargetSel--
if cursorEn = "001" then
drawBox(x, y, 240, 260, 233, 247, color(4), r, g, b);
drawBox(x, y, 259, 265, 230, 250, color(4), r, g, b);
drawBox(x, y, 264, 270, 235, 245, color(4), r, g, b);
drawBox(x, y, 269, 275, 237, 243, color(4), r, g, b);
end if;
-------
--Connect4 Sel----
if cursorEn = "010" then
drawBox(x, y, 240, 260, 373, 387, color(4), r, g, b);
drawBox(x, y, 259, 265, 370, 390, color(4), r, g, b);
drawBox(x, y, 264, 270, 375, 385, color(4), r, g, b);
drawBox(x, y, 269, 275, 377, 383, color(4), r, g, b);
end if;
----------------------------------------
	else
		r <= (others => '0');
		g <= (others => '0');
		b <= (others => '0');
	end if;
end if;
end process;
end FSM;