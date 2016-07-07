library ieee;
use ieee.std_logic_1164.all;

---------------AR地址寄存器---------------
--存放要读写的内存单元的地址

--需要执行指令时，指令的地址会从程序计数器转到AR地址寄存器然后PC自增1
--由于没有cache，因此PC内直接存放地址，并直接送到AR
--由AR地址寄存器把地址发送到地址总线
--地址总线会接收地址并把地址对应的内存单元的内容通过数据总线发送到IR指令寄存器

--输入可能为来自PC（程序计数器）的地址或来自ALU输出（对读写内存指令）的地址
--输出为需要访问的地址（无论是从内存单元获取代码或数据），送往地址总线

--与IR（指令寄存器）共用控制信号REC

--------------REC控制信号说明--------------
------|REC|--------|      操作      |-----
------|---|--------|----------------|-----
------| 00|--------|     无操作     |-----
------| 01|--------| AR接收PC的地址  |-----
------| 11|--------| AR接收ALU的输出 |-----
------| 10|--------|   AR不做操作    |-----
------------------------------------------

----实体说明----
entity ar is
	port(
		 --从alu_out接收经过ALU计算后的地址
		 alu_out:   in std_logic_vector(7 downto 0);
	     --从pc接收来自pc程序计数器的地址
	     pc:        in std_logic_vector(7 downto 0);
	     --rec为AR输入数据来源的控制信号
	     rec:       in std_logic_vector(1 downto 0);
	     --clk为时钟，reset为复位，reset低电平有效
	     clk,reset: in std_logic;
	     --q为输出地址，送往地址总线
	     q:         out std_logic_vector(15 downto 0));
end ar;

----实体行为说明----
architecture behave of ar is
begin
	process(clk,reset)
	begin
		--当reset为低电平时AR寄存器清零
		if reset = '0' then            
        	q <= "0000000000000000";
        --当时钟正跳变来临时触发AR工作
        elsif clk'event and clk = '1' then
			--通过rec控制信号选择AR接收地址的来源
			case rec is
				--当rec为01时从PC程序计数器接收地址
				when "01"=>
					q <= "00000000" & pc;
				--当rec为11时从ALU接收地址
				when "11"=>
					q <= "00000000" & alu_out;
				--当其他情况时AR不做操作
				when others=>
					null;
			end case;		
        end if;
	end process;
end behave;