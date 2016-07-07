library ieee;
use ieee.std_logic_1164.all;

entity change8To16out is
	port(in_8bit        : inout std_logic_vector(7 downto 0);
	     out_16bit    	: inout std_logic_vector(15 downto 0));
end change8To16out;

architecture behave of change8To16out is
begin
	process(in_8bit)
	begin
		out_16bit <= "00000000" & in_8bit;
	end process;
end behave;
