library ieee;
use ieee.std_logic_1164.all;

-------------FLAG_REG标志寄存器----------------
--       时序逻辑部件，带有清零端RESET；
--       输出只在时钟正跳变时发生变化；
--       接收ALU的标志位输出
--       在控制信号SST的控制下输出实际需要的标志位

--------------控制信号如下----------------
-----|  SST  |----| C |--| Z |--| V |--| S |----
-----|-------|----|---|--|---|--|---|--|---|----
-----|   00  |----|     接受ALU的运算结果   |----
-----|   01  |----| 0 |--| Z |--| V |--| S |----
-----|   10  |----| 1 |--| Z |--| V |--| S |----
-----|   11  |----| C |--| Z |--| V |--| S |----
------------------------------------------------

------实体描述------
entity flag_reg is
		 --sst为控制信号
	port(sst:                         in std_logic_vector(1 downto 0);
	     --c、z、v、s为从ALU输入的标志位，clk为时钟，reset为清零
	     c,z,v,s,clk,reset:           in std_logic;
	     --flag_c,z,v,s为从标志寄存器输出的标志位
	     flag_c,flag_z,flag_v,flag_s: out std_logic);
end flag_reg;

------实体的行为描述------
architecture behave of flag_reg is
begin
	process(clk,reset)
	begin
		--当reset为低电平时寄存器清零
		if reset = '0' then
			flag_c<='0';
			flag_z<='0';
			flag_v<='0';
			flag_s<='0';

		--当时钟上升沿时触发
		elsif clk'event and clk = '1' then
			--根据sst控制信号输出标志位
			case sst is
				--当sst为00时从ALU中接收标志结果
				when "00"=>
					flag_c<=c;
					flag_z<=z;
					flag_v<=v;
					flag_s<=s;
				--当sst为01时输出c->0,z->z,v->v,s->s
				when "01"=>
					flag_c<='0';
				--当sst为10时输出c->1,z->z,v->v,s->s
				when "10"=>
					flag_c<='1';
				--当sst为11时输出c->c,z->z,v->v,s->s
				when "11"=>
					null;
			end case;
		end if;
	end process;
end behave;