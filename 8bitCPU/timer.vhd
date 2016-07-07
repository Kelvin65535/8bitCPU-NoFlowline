library ieee;
use ieee.std_logic_1164.all;

entity timer is
   port(
   	  --时钟
      clk      : in std_logic;
      --复位
      reset    : in std_logic;
      --指令类型（OP码）
      ins      : in std_logic_vector(15 downto 0);
      output   : out std_logic_vector(2 downto 0));
end timer;

architecture behave of timer is
	--自定义类型，表示各个状态
	type state_type is(s0,s1,s2,s3,s4,s5);
	signal state:state_type;
begin
	process(clk,reset,ins)
	begin
		--初始状态
		if reset='0' then state<=s0;
		--工作状态切换
		elsif (clk'event and clk='1') then
			case state is
				--初始状态->000节拍
				--AR<-PC, PC<-PC+1
				when s0=>
					state<=s1;
				--000节拍->001
				--IR<-MEM
				when s1=>
					state<=s2;
				--001->011（A组指令）或101（B组指令）
				when s2=>
					if (ins(7) and ins(6))='1' then
					state<=s4;
					else state<=s3;
					end if;
				--A组指令执行完毕
				--011->000
				when s3=>
					state<=s1;
				--101->111
				when s4=>
					state<=s5;
				--B组指令执行完毕
				--111->000
				when s5=>
					state<=s1;
			end case;
        end if;
	end process;

	--各状态下的输出
	process(state)
	begin
		case state is
			when s0=>
			output<="100"; 
			when s1=>
			output<="000"; 
			when s2=>
			output<="001"; 
			when s3=>
			output<="011"; 
			when s4=>
			output<="101"; 
			when s5=>
			output<="111";
		end case;
	end process;
end behave;	