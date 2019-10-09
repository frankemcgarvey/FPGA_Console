library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

entity debounce is
	generic(count  : integer := 10); 
	port(
		clk50,  
		debIn      : in  std_logic;
		debOut     : out std_logic);
end debounce;



architecture behavioral of debounce is
signal FF          : std_logic_vector(1 downto 0);
signal counterSet  : std_logic;
signal counter     : std_logic_vector(count downto 0) := (others => '0');
begin

	counterSet <= (FF(0) xor FF(1));
	
	
	process(clk50)
	begin
	
	if(rising_edge(clk50)) then 
		FF(0) <= debIn;
		FF(1) <= FF(0);
		
			if   (counterSet = '1')     then counter <= (others => '0');
			elsif(counter(count) = '0') then counter <= counter + 1;
			else                         debOut  <= FF(1);
			end if;
	end if;

	end process;

end behavioral;