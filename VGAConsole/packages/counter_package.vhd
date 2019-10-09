library ieee;
use ieee.std_logic_1164.all;

package counter_package is
-------------------------------------------------------------------------------------
	procedure pos_edgeCounter (
							  signal   clk,
							           sgnl    : in     std_logic;    
							  signal   number  : inout  natural);
-------------------------------------------------------------------------------------
	procedure intCounter (
						  signal   clk    : in  std_logic;
						  constant const  : in  natural;
						  constant reset  : in  integer;
						  signal   number : inout  integer);
						
	procedure sigCounter (
						  signal   clk,
								   reset  : in  std_logic;
						  constant const  : in  natural;
						  constant rst  : in  integer;
						  signal   number : inout  integer);
						 
------------------------------------------------------------------------------------- 
-------------------------------------------------------------------------------------
end package;

package body counter_package is
---------------------------------------------------------------------------------------------------------------
		procedure pos_edgeCounter(
								 signal   clk,
							              sgnl    : in     std_logic;    
						    	 signal number  : inout  natural)  is
begin
	if(rising_edge(clk)) then
		if(sgnl = '1') then number <= number + 1;
		else                number <= 0;
		end if;
	end if;
end procedure;
--------------------------------------------------------------------------------------
	procedure intCounter (
						 signal   clk    : in  std_logic;
						 constant const  : in  natural;
						 constant reset  : in  integer;
						 signal   number : inout  integer) is
begin
	if(rising_edge(clk)) then 
		if(number = const) then number <= reset;
		else                    number <= number + 1;
		end if;
	end if;
end procedure;


	procedure sigCounter (
						  signal   clk,
						           reset  : in  std_logic;
						  constant const  : in  natural;
						  constant rst    : in  integer;
						  signal   number : inout  integer) is
						
begin
	if(rising_edge(clk)) then 
		if(reset = '1') then number <= rst;
		else
			if(number = const) then number <= rst;
			else                    number <=  number + 1;
			end if;
		end if;
	end if;
end procedure;

--procedure timer (
--						  signal clk50         : in    std_logic;
--						  signal start         : in    std_logic;
--						  variable secCounter  : inout natural range 0 to 1000000) is
						
--variable counter	 : integer range 0 to 50_000_000 := 0;
--variable timeCounter : integer range 0 to 10000000 := 0;
--	begin
-- 
--	if(rising_edge(clk50)) then 
--		if(start = '1') then secCounter := secCounter + 1;
--		else                 secCounter := 0;
--		end if;
--	end if;
	
--end procedure;						

end package body;
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

