library ieee;
use ieee.std_logic_1164.all;


entity pixel_clk is
	port(
	clk        : in     std_logic;
	clk_out    : buffer std_logic := '0');
end pixel_clk;

architecture behavior of pixel_clk is
begin
	
	process(clk)
	begin
		if(clk'EVENT and clk = '1') then clk_out <= not clk_out;
		end if;		 
	end process;
	
end behavior;