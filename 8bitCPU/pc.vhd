library ieee;
use ieee.std_logic_1164.all;

--------------PC程序计数器---------------
--保存指令从内存中的地址
--需要执行指令时，指令的地址会从程序计数器转到AR地址寄存器然后PC自增1
--由于没有cache，因此PC内直接存放地址，并直接送到AR
--由AR地址寄存器把地址发送到地址总线
--地址总线会接收地址并把地址对应的内存单元的内容通过数据总线发送到IR指令寄存器

--en为控制信号，用于控制是否接收ALU输出的结果
----|en|-------|        操作        |-----
----|--|-------|--------------------|-----
----| 0|-------|  不接受ALU输出结果  |-----
----| 1|-------|   接收ALU输出结果   |-----
------------------------------------------

----实体描述----
entity pc is
	port(--alu_out为从ALU接收经过运算后的地址
		 alu_out:   in std_logic_vector(7 downto 0);
	     --en为控制信号，控制是否接受ALU的运算结果
	     en:        in std_logic;
	     --clk为时钟，reset为复位
	     clk,reset: in std_logic;
	     --q为输出，送往AR（地址寄存器）或BUS_MUX（数据选择器）
	     --送往地址寄存器的地址会由AR发送到地址总线
	     --送往数据选择器的地址会进入ALU进行运算
	     q:         out std_logic_vector(7 downto 0));
end pc;

----实体行为描述----
architecture behave of pc is
begin
	process(clk,reset)
	begin
		--当reset（复位）为低电平时程序计数器清零
		if reset = '0' then            
			q <= "00000000";
        --当时钟正跳变来临时
        elsif clk'event and clk = '1' then
			--当en（控制信号）为1时接收ALU运算结果
			--当en为0时PC保持不变
			if en = '1' then
				q <= alu_out;
			end if;
        end if;
	end process;
end behave;