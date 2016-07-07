library ieee;
use ieee.std_logic_1164.all;

--------------PC���������---------------
--����ָ����ڴ��еĵ�ַ
--��Ҫִ��ָ��ʱ��ָ��ĵ�ַ��ӳ��������ת��AR��ַ�Ĵ���Ȼ��PC����1
--����û��cache�����PC��ֱ�Ӵ�ŵ�ַ����ֱ���͵�AR
--��AR��ַ�Ĵ����ѵ�ַ���͵���ַ����
--��ַ���߻���յ�ַ���ѵ�ַ��Ӧ���ڴ浥Ԫ������ͨ���������߷��͵�IRָ��Ĵ���

--enΪ�����źţ����ڿ����Ƿ����ALU����Ľ��
----|en|-------|        ����        |-----
----|--|-------|--------------------|-----
----| 0|-------|  ������ALU������  |-----
----| 1|-------|   ����ALU������   |-----
------------------------------------------

----ʵ������----
entity pc is
	port(--alu_outΪ��ALU���վ��������ĵ�ַ
		 alu_out:   in std_logic_vector(7 downto 0);
	     --enΪ�����źţ������Ƿ����ALU��������
	     en:        in std_logic;
	     --clkΪʱ�ӣ�resetΪ��λ
	     clk,reset: in std_logic;
	     --qΪ���������AR����ַ�Ĵ�������BUS_MUX������ѡ������
	     --������ַ�Ĵ����ĵ�ַ����AR���͵���ַ����
	     --��������ѡ�����ĵ�ַ�����ALU��������
	     q:         out std_logic_vector(7 downto 0));
end pc;

----ʵ����Ϊ����----
architecture behave of pc is
begin
	process(clk,reset)
	begin
		--��reset����λ��Ϊ�͵�ƽʱ�������������
		if reset = '0' then            
			q <= "00000000";
        --��ʱ������������ʱ
        elsif clk'event and clk = '1' then
			--��en�������źţ�Ϊ1ʱ����ALU������
			--��enΪ0ʱPC���ֲ���
			if en = '1' then
				q <= alu_out;
			end if;
        end if;
	end process;
end behave;