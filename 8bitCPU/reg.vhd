library ieee;
use ieee.std_logic_1164.all;

--------------reg通用寄存器------------------

----实体描述----
entity reg is
	--d为输入信号，q为输出信号
	port(d:in std_logic_vector(7 downto 0);
	     --clk为时钟，reset为清零，
	     --en为控制信号，控制是否能对寄存器写操作
	     clk,reset,en: in std_logic;
	     q:out std_logic_vector(7 downto 0));
end reg;

----实体行为描述----
architecture behave of reg is
begin
	process(clk,reset,en)
	begin
		--当reset（清零）为低电平时对寄存器清零
		if reset = '0' then            
        	q <= "00000000";
        --当时钟上升沿来临时允许对寄存器进行操作
        elsif clk'event and clk = '1' then
        	--当en（写操作控制信号）为1时对寄存器进行写操作
        	if en = '1' then
				q <= d;
			end if;
        end if;
	end process;
end behave;