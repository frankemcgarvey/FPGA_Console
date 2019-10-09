library ieee;

use ieee.std_logic_1164.all;


entity controlGenerator is
	generic(Ha : integer := 96;   --Hpulse
			Hb : integer := 144;  --Hpulse + HBP
			Hc : integer := 784;  --Hpulse + HBP + Hactive
			Hd : integer := 800;  --Hpulse + HBP + Hactive + HFP
			Va : integer := 2;	  --Vpulse
			Vb : integer := 35;	  --Vpulse + VBP
			Vc : integer := 515;  --Vpulse + VBP + Vactive
			Vd : integer := 525); --Vpulse + VBP + Vactive + VFP 	
	port( 
	pixel_clk                : in     std_logic;
	dena                     : out    std_logic;
	h_active, v_active,
	h_sync, v_sync           : buffer std_logic);
end controlGenerator;

architecture behavioral of controlGenerator is
begin 
	
	
	process(pixel_clk)
		variable Hcount: integer range 0 to Hd;
	begin
		if (pixel_clk'EVENT and pixel_clk = '1') then
			Hcount := Hcount + 1;
			if    (Hcount = Ha) then h_sync   <= '1';
			elsif (Hcount = Hb) then h_active <= '1';
			elsif (Hcount = Hc) then h_active <= '0';
			elsif (Hcount = Hd) then h_sync   <= '0'; Hcount := 0;
			end if;
		end if;
	end process;
	
	
	process(h_sync)
		variable Vcount : integer range 0 to Vd;
	begin
		if (h_sync'EVENT and h_sync = '0') then
			Vcount := Vcount + 1;
			if    (Vcount = Va) then v_sync   <= '1';
			elsif (Vcount = Vb) then v_active <= '1';
			elsif (Vcount = Vc) then v_active <= '0';
			elsif (Vcount = Vd) then v_sync   <= '0'; Vcount := 0; 
			end if;
		end if;
	end process;
	
	dena <= h_active and v_active;
			
	
end behavioral;
