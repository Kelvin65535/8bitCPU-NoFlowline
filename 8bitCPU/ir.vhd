library ieee;
use ieee.std_logic_1164.all;

----------------IR指令寄存器-----------------
--存放从内存提取的指令内容
--输入来自数据总线，指令由内存经过数据总线进入IR
--输出送往控制逻辑，准备下一步运行

--与AR地址寄存器共用控制信号REC
-------------REC控制信号说明---------------
------|REC|--------|      操作      |-----
------|---|--------|----------------|-----
------| 00|--------|     无操作     |-----
------| 01|--------|     无操作     |-----
------| 11|--------|     无操作     |-----
------| 10|--------|IR接收待运行指令 |-----
------------------------------------------

----实体描述----
entity ir is
	port(
		 --从mem_data输入来自内存的指令
		 mem_data:  in std_logic_vector(15 downto 0);
	     --rec为IR控制信号，与AR地址寄存器共享
	     rec:       in std_logic_vector(1 downto 0);
	     --clk为时钟，reset为复位，reset低电平触发
	     clk,reset: in std_logic;
	     --q为输出，将地址送往控制逻辑
	     q:         out std_logic_vector(7 downto 0));
end ir;

----实体行为描述----
architecture behave of ir is
begin
	process(clk,reset)
	begin
		--当reset（复位）为低电平时指令寄存器清零
		if reset = '0' then            
        	q <= "00000000";
        --当时钟为上升沿时触发IR工作
        elsif clk'event and clk = '1' then
			--根据rec控制信号不同选择是否从内存单元获取指令
			case rec is
				--当rec为10时从内存单元获取指令
				when "10"=>
					q <= mem_data(7) & mem_data(6) & mem_data(5) & mem_data(4) & mem_data(3) & mem_data(2) & mem_data(1) & mem_data(0);
				--其他情况IR不做工作
				when others=>
					null;
			end case;		
        end if;
	end process;
end behave;