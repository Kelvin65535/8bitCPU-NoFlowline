library ieee;
use ieee.std_logic_1164.all;

entity t3 is
port(wr          : in std_logic;
     alu_out     : in std_logic_vector(7 downto 0);
     output      : out std_logic_vector(15 downto 0));
end t3;

architecture behave of t3 is
begin
	process(wr,alu_out)
	begin
		case wr is
		when '1'=>
			output<="ZZZZZZZZZZZZZZZZ";
		when '0'=>
			output<="00000000" & alu_out(7) & alu_out(6) & alu_out(5) & alu_out(4) & alu_out(3) & alu_out(2) & alu_out(1) & alu_out(0);
		end case;
	end process;
end behave;