library ieee;
use ieee.std_logic_1164.all;


entity or8gate is
	port(
		input : std_logic_vector(7 downto 0);
		output : out std_logic);
end or8gate;


architecture dataflow of or8gate is
begin


	output <= (input(0) or input(1) or input(2) or input(3) or input(4) or input(5) or input(6) or input(7));
end dataflow;