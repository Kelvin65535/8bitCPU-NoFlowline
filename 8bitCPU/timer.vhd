library ieee;
use ieee.std_logic_1164.all;

entity timer is
   port(
   	  --ʱ��
      clk      : in std_logic;
      --��λ
      reset    : in std_logic;
      --ָ�����ͣ�OP�룩
      ins      : in std_logic_vector(15 downto 0);
      output   : out std_logic_vector(2 downto 0));
end timer;

architecture behave of timer is
	--�Զ������ͣ���ʾ����״̬
	type state_type is(s0,s1,s2,s3,s4,s5);
	signal state:state_type;
begin
	process(clk,reset,ins)
	begin
		--��ʼ״̬
		if reset='0' then state<=s0;
		--����״̬�л�
		elsif (clk'event and clk='1') then
			case state is
				--��ʼ״̬->000����
				--AR<-PC, PC<-PC+1
				when s0=>
					state<=s1;
				--000����->001
				--IR<-MEM
				when s1=>
					state<=s2;
				--001->011��A��ָ���101��B��ָ�
				when s2=>
					if (ins(7) and ins(6))='1' then
					state<=s4;
					else state<=s3;
					end if;
				--A��ָ��ִ�����
				--011->000
				when s3=>
					state<=s1;
				--101->111
				when s4=>
					state<=s5;
				--B��ָ��ִ�����
				--111->000
				when s5=>
					state<=s1;
			end case;
        end if;
	end process;

	--��״̬�µ����
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