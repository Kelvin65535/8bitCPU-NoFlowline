library ieee;
use ieee.std_logic_1164.all;

entity reg_testb is
	port(clk,reset   : in std_logic;
		 --alu_in_sel ‰»Î
		 input_c     : in std_logic_vector(2 downto 0);
		 cin         : in std_logic;
		 rec         : in std_logic_vector(1 downto 0);
		 pc_en,reg_en: in std_logic;
	     q           : out std_logic_vector(7 downto 0));
end reg_testb;

architecture behave of reg_testb is
begin
	process(clk,reset,input_c,cin,rec,pc_en,reg_en)
	variable temp: std_logic_vector(7 downto 0);
	begin
	    temp := cin & input_c & rec & pc_en & reg_en;
		if reset = '0' then            
		    q <= "00000000";
        elsif clk'event and clk = '1' then
			q <= temp;
        end if;
	end process;
end behave;