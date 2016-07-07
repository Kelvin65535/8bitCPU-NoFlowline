library ieee;
use ieee.std_logic_1164.all;

entity bus_mux is
	port(
		 --输入alu的控制信号，进行ALU模块A、B端输入的选择
		 alu_in_sel            : in std_logic_vector(2 downto 0);
		 data				   : in std_logic_vector(15 downto 0);
	     pc,offset,sr,dr	   : in std_logic_vector(7 downto 0);
	     alu_sr,alu_dr         : out std_logic_vector(7 downto 0));
end bus_mux;

architecture behave of bus_mux is
begin
	process(alu_in_sel,data,pc,offset,sr,dr)
	begin
		case alu_in_sel is
		when "000"=>
			alu_sr<=sr;
			alu_dr<=dr;
		when "001"=>
			alu_sr<=sr;
			alu_dr<="00000000";
		when "010"=>
			alu_sr<="00000000";
			alu_dr<=dr;
		when "011"=>
			alu_sr<=offset;
			alu_dr<=pc;
		when "100"=>
			alu_sr<="00000000";
			alu_dr<=pc;
		when "101"=>
			alu_sr<="00000000";
			alu_dr<=data(7) & data(6) & data(5) & data(4) & data(3) & data(2) & data(1) & data(0);
		when others=>
			alu_sr<="00000000";
			alu_dr<="00000000";
		end case;
	end process;
end behave;