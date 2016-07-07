library ieee;
use ieee.std_logic_1164.all;

-------------FLAG_REG��־�Ĵ���----------------
--       ʱ���߼����������������RESET��
--       ���ֻ��ʱ��������ʱ�����仯��
--       ����ALU�ı�־λ���
--       �ڿ����ź�SST�Ŀ��������ʵ����Ҫ�ı�־λ

--------------�����ź�����----------------
-----|  SST  |----| C |--| Z |--| V |--| S |----
-----|-------|----|---|--|---|--|---|--|---|----
-----|   00  |----|     ����ALU��������   |----
-----|   01  |----| 0 |--| Z |--| V |--| S |----
-----|   10  |----| 1 |--| Z |--| V |--| S |----
-----|   11  |----| C |--| Z |--| V |--| S |----
------------------------------------------------

------ʵ������------
entity flag_reg is
		 --sstΪ�����ź�
	port(sst:                         in std_logic_vector(1 downto 0);
	     --c��z��v��sΪ��ALU����ı�־λ��clkΪʱ�ӣ�resetΪ����
	     c,z,v,s,clk,reset:           in std_logic;
	     --flag_c,z,v,sΪ�ӱ�־�Ĵ�������ı�־λ
	     flag_c,flag_z,flag_v,flag_s: out std_logic);
end flag_reg;

------ʵ�����Ϊ����------
architecture behave of flag_reg is
begin
	process(clk,reset)
	begin
		--��resetΪ�͵�ƽʱ�Ĵ�������
		if reset = '0' then
			flag_c<='0';
			flag_z<='0';
			flag_v<='0';
			flag_s<='0';

		--��ʱ��������ʱ����
		elsif clk'event and clk = '1' then
			--����sst�����ź������־λ
			case sst is
				--��sstΪ00ʱ��ALU�н��ձ�־���
				when "00"=>
					flag_c<=c;
					flag_z<=z;
					flag_v<=v;
					flag_s<=s;
				--��sstΪ01ʱ���c->0,z->z,v->v,s->s
				when "01"=>
					flag_c<='0';
				--��sstΪ10ʱ���c->1,z->z,v->v,s->s
				when "10"=>
					flag_c<='1';
				--��sstΪ11ʱ���c->c,z->z,v->v,s->s
				when "11"=>
					null;
			end case;
		end if;
	end process;
end behave;