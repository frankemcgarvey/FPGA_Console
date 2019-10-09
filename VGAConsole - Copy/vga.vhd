library ieee;
use ieee.std_logic_1164.all;


entity vga is 
	port(
	clk,
	up, down, lft, rght,
	button, inReplay, inToMenu,
	reset                         : in     std_logic;
	h_sync, v_sync,            
	n_blank, n_sync,
	clk25                         : buffer std_logic;
    targetNumber1, targetNumber2  : out    integer range 0 to 10;
	r, g, b                       : out std_logic_vector(9 downto 0) := (others => '0'));
end vga;

architecture structural of vga is
------------------------------------------------------------------------
component controlGenerator is
	generic(Ha : integer := 96;   --Hpulse
			Hb : integer := 144;  --Hpulse + HBP
			Hc : integer := 784;  --Hpulse + HBP + Hactive
			Hd : integer := 800;  --Hpulse + HBP + Hactive + HFP
			Va : integer := 2;	  --Vpulse
			Vb : integer := 35;	  --Vpulse + VBP
			Vc : integer := 515;  --Vpulse + VBP + Vactive
			Vd : integer := 525); --Vpulse + VBP + Vactive + VFP 	
	port( 
	pixel_clk                : in std_logic;
	dena                     : out    std_logic;
	h_active, v_active,
	h_sync, v_sync           : buffer std_logic);
end component;

component targetGame is
	generic(
	xMin      : integer := -100;
	xMax      : integer := 800);
	port(
	target_clock0,
	target_clock1,
	target_clock2,
	clk25,
	clk50,
	hsync, 
	hactive, vactive, 
	dena,
	reset,
	up, down, lt, rt, button,
	inReplay, inToMenu                        : in  std_logic := '0';
	replay, toMenu                            : out std_logic := '0';
	numberOne, numberTwo                      : out integer range 0 to 10;
	r, g, b								      : out std_logic_vector(9 downto 0) := (others => '0'));
end component;	   

component clock_divider is
	port(
	clk					  : in     std_logic;
	clk25, 
	target_clock0,
	target_clock1,
	target_clock2    	  : buffer std_logic := '0');
end component;

component connect4Game is
	port(
	clk50,
	clk25,
	chipClk,
	Lt, Rt,
	button,
	inReplay, inToMenu,
	reset,
	dena,
	hsync, 
	hActive, vActive        : in  std_logic := '0';
	replay, toMenu          : out std_logic := '0';
	r, g, b                 : out std_logic_vector(9 downto 0) := (others => '0'));
end component;

component tttGame is
	port(
	clk50,
	clk25,
	Up, Dn,
	Lt, Rt,
	button,
	inReplay, inToMenu,
	reset,
	dena,
	hsync, 
	hActive, vActive        : in  std_logic := '0';
	replay, toMenu          : out std_logic := '0';
	r, g, b                 : out std_logic_vector(9 downto 0));
end component;

component gameController is
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
end component;

component RGBcontroller is
	port(
		red0, green0, blue0,    -- 0 = ttt
		red1, green1, blue1,    -- 1 = target 
		red2, green2, blue2,    -- 2 = Menu 
		                        -- 3 = connect4
		red3, green3, blue3       : in  std_logic_vector(9 downto 0) := (others => '0');
		tttPlay, targetPlay,
		menuPlay, connect4Play    : in  std_logic := '0';
		r, g, b                   : out std_logic_vector(9 downto 0) := (others => '0'));
	
end component;

component mainScreen is
	port(
		clk25,
		clk50,
		hsync, 
		hactive,
		vactive, 
		dena,
		reset,
		up, down, 
		Lt, Rt, sel   : in std_logic := '0';
		gameSel       : out std_logic_vector(2 downto 0) := (others => '0');
		r, g, b : out std_logic_vector(9 downto 0)
		);
end component;

component buttonController is
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
end component;
-------------------------------------------------------------------------

signal dena, 
	   hactive, vactive,
	   clk50,
	   target_clock0, 
	   target_clock1, 
	   target_clock2,
	   rst,
	--------------
	   tttPlay,
	   targetPlay,
	   menuPlay,
	   connect4Play,
	--------------
	   tttReplay,
	   targetReplay,
	   connect4Replay,
	----------------       
	   targetToMenu,
	   tttToMenu,
	   connect4ToMenu        : std_logic := '0';
	
	
signal  Up0, Down0,
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
		Button3         : std_logic := '0';	
	
signal gameSel            : std_logic_vector(2 downto 0) := (others => '0');

signal x                  : integer range -100 to 800 := 0;
signal y                  : integer range 0 to 525    := 0;

signal targetRed, targetGreen, targetBlue,
       tttRed, tttGreen, tttBlue,
       menuRed, menuGreen, menuBlue,
       connect4Red, connect4Green, connect4Blue      : std_logic_vector(9 downto 0) := (others => '0');        



begin
	n_blank <= '1';
	n_sync  <= '0';
	
	clk50 <= clk;
	
	rst <= (reset or tttToMenu or targetToMenu or connect4ToMenu);
	
	
	clk_divider  : clock_divider     port map(clk, clk25, target_clock0, target_clock1, target_clock2);
	controls     : controlGenerator  port map(clk25, dena, hactive, vactive, h_sync, v_sync);
	rgb          : RGBcontroller     port map(tttRed, tttGreen, tttBlue, targetRed, targetGreen, targetBlue, menuRed, menuGreen, menuBlue, connect4Red, connect4Green, connect4Blue, tttPlay, targetPlay, menuPlay, connect4Play, r, g, b);
	btnControl   : buttonController  port map(Up, Down, Lft, Rght, Button, tttPlay, targetPlay, menuPlay, connect4Play, Up0, Down0, Lft0, Rght0, Button0, Up1, Down1, Lft1, Rght1, Button1, Up2, Down2, Lft2, Rght2, Button2, Up3, Down3, Lft3, Rght3, Button3);
	
    gmControl    : gameController    port map(clk50, rst, gameSel(1), gameSel(0), gameSel(2), targetReplay, tttReplay, connect4Replay, tttPlay, targetPlay, menuPlay, connect4Play);
	
	
	menu         : mainScreen        port map(clk25, clk50, h_sync, hactive, vactive, dena, reset, Up0, Down0, Lft0, Rght0, Button0, gameSel, menuRed, menuGreen, menuBlue);
	game0        : targetGame        port map(target_clock0, target_clock1, target_clock2, clk25, clk50, h_sync, hactive, vactive, dena, targetPlay, Up1, Down1, Lft1, Rght1, Button1, inReplay, inToMenu, targetReplay, targetToMenu, targetNumber1, targetNumber2, targetRed, targetGreen, targetBlue);
	game1        : tttGame           port map(clk50, clk25, Up2, Down2, Lft2, Rght2, Button2, inReplay, inToMenu, tttPlay, dena, h_sync, hactive, vactive, tttReplay, tttToMenu, tttRed, tttGreen, tttBlue);
	game2        : connect4Game      port map(clk50, clk25, target_clock0, Lft3, Rght3, Button3, inReplay, inToMenu, connect4Play, dena, h_sync, hactive, vactive, connect4Replay, connect4ToMenu, connect4Red, connect4Green, connect4Blue);
	  
end structural;

