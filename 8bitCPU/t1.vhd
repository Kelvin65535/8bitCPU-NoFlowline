library ieee;
use ieee.std_logic_1164.all;

--------------T1器件----------------
--用于产生ALU的进位输入Cin
--通过SCI控制信号判断是否向ALU输入进位

------------SCI控制信号--------------
-------|SCI |------|   Cin输入    |--
-------|----|------|              |--
-------| 00 |------|      0       |--
-------| 01 |------|      1       |--
-------| 10 |------| FLAG_C进位标志|--
-------------------------------------

entity t1 is
	port(
		 --flag_c为来源于标志位的进位标志
		 flag_c:in std_logic;
	     --sci为控制信号，控制向ALU输入进位内容
	     sci:in std_logic_vector(1 downto 0);
	     --alu_cin为输出，向ALU输入进位
	     alu_cin:out std_logic);
end t1;

architecture behave of t1 is
begin
	process(sci,flag_c)
	begin
		--根据sci信号判断向ALU输入的进位
		case sci is
			when "00"=>
				alu_cin<='0';
			when "01"=>
				alu_cin<='1';
			when "10"=>
				alu_cin<=flag_c;
			when others=>
				alu_cin<='0';
		end case;
	end process;
end behave;