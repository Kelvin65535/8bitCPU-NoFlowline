library ieee;
use ieee.std_logic_1164.all;

--------------T1����----------------
--���ڲ���ALU�Ľ�λ����Cin
--ͨ��SCI�����ź��ж��Ƿ���ALU�����λ

------------SCI�����ź�--------------
-------|SCI |------|   Cin����    |--
-------|----|------|              |--
-------| 00 |------|      0       |--
-------| 01 |------|      1       |--
-------| 10 |------| FLAG_C��λ��־|--
-------------------------------------

entity t1 is
	port(
		 --flag_cΪ��Դ�ڱ�־λ�Ľ�λ��־
		 flag_c:in std_logic;
	     --sciΪ�����źţ�������ALU�����λ����
	     sci:in std_logic_vector(1 downto 0);
	     --alu_cinΪ�������ALU�����λ
	     alu_cin:out std_logic);
end t1;

architecture behave of t1 is
begin
	process(sci,flag_c)
	begin
		--����sci�ź��ж���ALU����Ľ�λ
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