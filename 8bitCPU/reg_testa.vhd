library ieee;
use ieee.std_logic_1164.all;

entity reg_testa is
	port(clk,reset   : in std_logic;
		 --timer ‰»Î
		 input_a     : in std_logic_vector(2 downto 0);
		 --alu_func ‰»Î
		 input_b     : in std_logic_vector(2 downto 0);
	     q           : out std_logic_vector(7 downto 0));
end reg_testa;

architecture behave of reg_testa is
begin
	process(clk,reset,input_a,input_b)
	variable temp: std_logic_vector(7 downto 0);
	begin
	    temp := '0' & input_a & '0' & input_b;
		if reset = '0' then            
		    q <= "00000000";
        elsif clk'event and clk = '1' then
			q <= temp;
        end if;
	end process;
end behave;