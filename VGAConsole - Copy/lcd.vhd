library ieee;
use ieee.std_logic_1164.all;
use work.lcd_package.all;

entity lcdDriver is
	generic(clockDivider  : natural := 100000); --500Hertz--Gives 2 ms for each instruction to initiate.
	port(
		clk,
		reset              : in     std_logic;
		input1, input2     : in     integer range 0 to 10;
		E         		   : buffer std_logic;
		RS, RW    		   : out    std_logic;
		dOut      		   : out    std_logic_vector(7 downto 0));
end lcdDriver;


architecture FSM of lcdDriver is
type state is(FunctionSet1, FunctionSet2, 
		      FunctionSet3, FunctionSet4, 
			  ClearDisplay, DisplayControl, 
			  EntryMode, 
			  WriteData1,  WriteData2, 
			  ReturnHome);

	signal prevState, nextState : state;
	signal lcdNumberOne, lcdNumberTwo : std_logic_vector(7 downto 0);
begin

	process(clk)
	variable counter : natural;
	begin
	
	lcdNumberOne <= num_to_LCD(input1);
	lcdNumberTwo <= num_to_LCD(input2);
		
	if (rising_edge(clk)) then
		if (counter = clockDivider) then counter := 0; E <= not E;
		else                             counter := counter + 1;
		end if;
	end if;
	end process;
-------------------------------------------------------------------------------

	
	
	process(E)
	begin
	if(rising_edge(E)) then
		if(reset = '1') then prevState <= FunctionSet1;
		else                 prevState <= nextState;
		end if;
	end if;
    end process;

	process(prevState)
	constant initialize : std_logic_vector(7 downto 0) := "00111000";
	begin
	
		case (prevState) is 
			when FunctionSet1  	=>
									 RS        <= '0'; 
									 RW        <= '0';
									 dOut      <= initialize;
									 nextState <= FunctionSet2;
			when FunctionSet2 	=>
									 RS   	   <= '0';
									 RW	  	   <= '0';
									 dOut	   <= initialize;
									 nextState <= FunctionSet3;
			when FunctionSet3 	=>
									 RS   	   <= '0';
									 RW   	   <= '0';
									 dOut 	   <= initialize;
									 nextState <= FunctionSet4;
			when FunctionSet4 	=>
									 RS        <= '0';
									 RW        <= '0';
									 dOut 	   <= initialize;
									 nextState <= ClearDisplay;
			when ClearDisplay 	=>
									 RS        <= '0';
									 RW        <= '0';
									 dOut      <= "00000001";
									 nextState <= DisplayControl;
			when DisplayControl	=>
									 RS        <= '0';
									 RW        <= '0';
									 dOut      <= "00001100";
								     nextState <= EntryMode;
			when EntryMode      =>
									 RS        <= '0';
									 RW        <= '0';
									 dOut      <= "00000110";
									 nextState <= WriteData1;
			when WriteData1     =>
									 RS        <= '1';
									 RW        <= '0';
									 
									 dOut      <= lcdNumberOne;
									 nextState <= WriteData2;
			when WriteData2     =>
				                     RS        <= '1';
				                     RW        <= '0';
				                     dOut      <= lcdNumberTwo;
				                     nextState <= returnHome;
		
			when ReturnHome     =>
									 RS        <= '0';
									 RW        <= '0';
									 dOut      <= "10000000";
									 nextState <= WriteData1;
		end case;
			
								 
	
	end process;
end FSM;
