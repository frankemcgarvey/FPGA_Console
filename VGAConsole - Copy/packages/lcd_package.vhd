library ieee;
use ieee.std_logic_1164.all;

package lcd_package is

	function num_to_LCD (signal points : integer) return std_logic_vector;

	
end lcd_package;	


package body lcd_package is
	
	function num_to_LCD (signal points : integer) return std_logic_vector is
	
begin

	case (points) is
			when 0 =>      return "00110000";
			when 1 =>      return "00110001";
			when 2 =>      return "00110010";
			when 3 =>      return "00110011";
			when 4 =>      return "00110100";
			when 5 =>      return "00110101";
			when 6 =>      return "00110110";
			when 7 =>      return "00110111";
			when 8 =>      return "00111000";
			when 9 =>      return "00111001";
			when others => return "11111110";
	end case;
end num_to_LCD;

end package body;

