library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

------------ALU算术逻辑部件--------------

-----------ALU控制信号对应的功能------------
---------|I2-I1-I0|---------功能----------
--       | 0  0  0|     B + A + Cin
--       | 0  0  1|     B - A - Cin
--       | 0  1  0|        A 与 B
--       | 0  1  1|      B 循环左移一位
--       | 1  0  0|      B 循环右移一位
--       | 1  0  1|      B 带进位循环左移一位
--       | 1  1  0|      B 带进位循环右移一位
--       | 1  1  1|      B 求补
------------------------------------------


-----------------实体描述------------------------
entity alu is
port(
	 ----进位输入----
	 cin:in std_logic;
     ----ALU输入----
     alu_a,alu_b:in std_logic_vector(7 downto 0);
     ----控制信号输入----
     alu_func:in std_logic_vector(2 downto 0);
     ----ALU输出----
     alu_out:out std_logic_vector(7 downto 0);
     ----标志位输出----
     ----C进位、Z是否为0、V溢出、S是否为负----
     c,z,v,s:out std_logic);
end alu;

-----------------ALU行为描述------------------------
architecture behave of alu is
begin
	--alu_a、alu_b为8位输入，cin为进位输入，alu_func为控制信号
	process(alu_a,alu_b,cin,alu_func)
	----用于暂存运算结果的temp变量----
	variable temp1,temp2,temp3 : std_logic_vector(7 downto 0) ;
	begin

		--------以下为算术逻辑运算部分-------
		--temp1用于暂存从1为扩展到8位的进位输入
		temp1 := "0000000"&cin;

		--根据ALU控制信号输入完成对应的运算
		--运算结果均暂存于temp2
		case alu_func is
			--A + B + Cin
			when "000"=>
				temp2 := alu_b+alu_a+temp1;
			--B - A - Cin
			when "001"=>
				temp2 := alu_b-alu_a-temp1;
			--A 与 B
			when "010"=>
				temp2 := alu_a and alu_b;
			--B 左移一位
			when "011"=>
				temp2(0) := alu_b(7);
				for I in 7 downto 1 loop
					--将alu_b的第i-1位赋值到temp2的第i位
					temp2(I) := alu_b(I-1);
				end loop;
			--B右移一位
			when "100"=>
				temp2(7) := alu_b(0);
				for I in 6 downto 0 loop
					--将alu_b的第i+1位赋值到temp2的第i位
					temp2(I) := alu_b(I+1);
				end loop;
			--B左移一位
			when "101"=>
			--第1位为0
				temp2(0) := cin;
				for I in 7 downto 1 loop
					--将alu_b的第i-1位赋值到temp2的第i位
					temp2(I) := alu_b(I-1);
				end loop;
			--B右移一位
			when "110"=>
				--最高位为0
				temp2(7) := cin;
				for I in 6 downto 0 loop
					--将alu_b的第i+1位赋值到temp2的第i位
					temp2(I) := alu_b(I+1);
				end loop;
			--求补
			when "111"=>
				temp2 := "00000000" - alu_b;
			--控制信号为其他状况，运算结果置零
			when others=>
				temp2 := "00000000";
		end case;
		--temp2为alu计算结果，通过alu_out从alu输出
		alu_out <= temp2;
		----------算术逻辑运算部分结束---------

		----------以下为标志位设置部分---------
		--若计算结果为0则z（是否为0）标志位置1
		if temp2 = "00000000" then z<='1';
		else z<='0';
		end if;

		--若最高位（符号位）为1则s（是否为负）标志位置1
		if temp2(7) = '1' then s<='1';
		else s<='0';
		end if;

		--根据alu运算结果置v（溢出）标志位
		case alu_func is
			--当alu进行加法/减法运算时，此时控制信号为000/001/111
			when "000" | "001" | "111"=>
				--当alu_a、alu_b为两位正数（或负数）相加结果temp2为负数（或正数）时发生溢出
				if (alu_a(7)= '1' and alu_b(7)= '1' and temp2(7) = '0') or
				   (alu_a(7)= '0' and alu_b(7)= '0' and temp2(7) = '1') then
					v<='1';
				else v<='0';
				end if;
			--当进行其他运算时，此时v（溢出）标志位置零
			when others=>
				v<='0';
		end case;

		--根据alu运算结果置c（进位）标志位
		case alu_func is
			--当alu进行加法运算时，此时控制信号为000
			--进位发生的条件：
			--当(alu_b + alu_a + temp1) > 11111111 时发生进位
			when "000"=>
				temp3 := "11111111"-alu_b-temp1;
				if temp3<alu_a then
					c<='1';
				else c<='0';
				end if;
			--当alu进行减法运算时，此时控制信号为001
			--进位发生的条件：
			--当alu_b - alu_a < 0 时发生进位
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
				
			--控制信号为其他情况时v（进位）标志位置零
			when others=>
				c<='0';
		end case;
	end process;
end behave;