library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

------------ALU�����߼�����--------------

-----------ALU�����źŶ�Ӧ�Ĺ���------------
---------|I2-I1-I0|---------����----------
--       | 0  0  0|     B + A + Cin
--       | 0  0  1|     B - A - Cin
--       | 0  1  0|        A �� B
--       | 0  1  1|      B ѭ������һλ
--       | 1  0  0|      B ѭ������һλ
--       | 1  0  1|      B ����λѭ������һλ
--       | 1  1  0|      B ����λѭ������һλ
--       | 1  1  1|      B ��
------------------------------------------


-----------------ʵ������------------------------
entity alu is
port(
	 ----��λ����----
	 cin:in std_logic;
     ----ALU����----
     alu_a,alu_b:in std_logic_vector(7 downto 0);
     ----�����ź�����----
     alu_func:in std_logic_vector(2 downto 0);
     ----ALU���----
     alu_out:out std_logic_vector(7 downto 0);
     ----��־λ���----
     ----C��λ��Z�Ƿ�Ϊ0��V�����S�Ƿ�Ϊ��----
     c,z,v,s:out std_logic);
end alu;

-----------------ALU��Ϊ����------------------------
architecture behave of alu is
begin
	--alu_a��alu_bΪ8λ���룬cinΪ��λ���룬alu_funcΪ�����ź�
	process(alu_a,alu_b,cin,alu_func)
	----�����ݴ���������temp����----
	variable temp1,temp2,temp3 : std_logic_vector(7 downto 0) ;
	begin

		--------����Ϊ�����߼����㲿��-------
		--temp1�����ݴ��1Ϊ��չ��8λ�Ľ�λ����
		temp1 := "0000000"&cin;

		--����ALU�����ź�������ɶ�Ӧ������
		--���������ݴ���temp2
		case alu_func is
			--A + B + Cin
			when "000"=>
				temp2 := alu_b+alu_a+temp1;
			--B - A - Cin
			when "001"=>
				temp2 := alu_b-alu_a-temp1;
			--A �� B
			when "010"=>
				temp2 := alu_a and alu_b;
			--B ����һλ
			when "011"=>
				temp2(0) := alu_b(7);
				for I in 7 downto 1 loop
					--��alu_b�ĵ�i-1λ��ֵ��temp2�ĵ�iλ
					temp2(I) := alu_b(I-1);
				end loop;
			--B����һλ
			when "100"=>
				temp2(7) := alu_b(0);
				for I in 6 downto 0 loop
					--��alu_b�ĵ�i+1λ��ֵ��temp2�ĵ�iλ
					temp2(I) := alu_b(I+1);
				end loop;
			--B����һλ
			when "101"=>
			--��1λΪ0
				temp2(0) := cin;
				for I in 7 downto 1 loop
					--��alu_b�ĵ�i-1λ��ֵ��temp2�ĵ�iλ
					temp2(I) := alu_b(I-1);
				end loop;
			--B����һλ
			when "110"=>
				--���λΪ0
				temp2(7) := cin;
				for I in 6 downto 0 loop
					--��alu_b�ĵ�i+1λ��ֵ��temp2�ĵ�iλ
					temp2(I) := alu_b(I+1);
				end loop;
			--��
			when "111"=>
				temp2 := "00000000" - alu_b;
			--�����ź�Ϊ����״��������������
			when others=>
				temp2 := "00000000";
		end case;
		--temp2Ϊalu��������ͨ��alu_out��alu���
		alu_out <= temp2;
		----------�����߼����㲿�ֽ���---------

		----------����Ϊ��־λ���ò���---------
		--��������Ϊ0��z���Ƿ�Ϊ0����־λ��1
		if temp2 = "00000000" then z<='1';
		else z<='0';
		end if;

		--�����λ������λ��Ϊ1��s���Ƿ�Ϊ������־λ��1
		if temp2(7) = '1' then s<='1';
		else s<='0';
		end if;

		--����alu��������v���������־λ
		case alu_func is
			--��alu���мӷ�/��������ʱ����ʱ�����ź�Ϊ000/001/111
			when "000" | "001" | "111"=>
				--��alu_a��alu_bΪ��λ��������������ӽ��temp2Ϊ��������������ʱ�������
				if (alu_a(7)= '1' and alu_b(7)= '1' and temp2(7) = '0') or
				   (alu_a(7)= '0' and alu_b(7)= '0' and temp2(7) = '1') then
					v<='1';
				else v<='0';
				end if;
			--��������������ʱ����ʱv���������־λ����
			when others=>
				v<='0';
		end case;

		--����alu��������c����λ����־λ
		case alu_func is
			--��alu���мӷ�����ʱ����ʱ�����ź�Ϊ000
			--��λ������������
			--��(alu_b + alu_a + temp1) > 11111111 ʱ������λ
			when "000"=>
				temp3 := "11111111"-alu_b-temp1;
				if temp3<alu_a then
					c<='1';
				else c<='0';
				end if;
			--��alu���м�������ʱ����ʱ�����ź�Ϊ001
			--��λ������������
			--��alu_b - alu_a < 0 ʱ������λ
			when "001"=>
				if alu_b<alu_a then
				c<='1';
				else c<='0';
				end if;

			when "011"=>
				c <= alu_b(7);
			when "100"=>
				c <= alu_b(0);
			when "101"=>
				c <= alu_b(7);
			when "110"=>
				c <= alu_b(0);
				
			--�����ź�Ϊ�������ʱv����λ����־λ����
			when others=>
				c<='0';
		end case;
	end process;
end behave;