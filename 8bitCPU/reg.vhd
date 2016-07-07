library ieee;
use ieee.std_logic_1164.all;

--------------regͨ�üĴ���------------------

----ʵ������----
entity reg is
	--dΪ�����źţ�qΪ����ź�
	port(d:in std_logic_vector(7 downto 0);
	     --clkΪʱ�ӣ�resetΪ���㣬
	     --enΪ�����źţ������Ƿ��ܶԼĴ���д����
	     clk,reset,en: in std_logic;
	     q:out std_logic_vector(7 downto 0));
end reg;

----ʵ����Ϊ����----
architecture behave of reg is
begin
	process(clk,reset,en)
	begin
		--��reset�����㣩Ϊ�͵�ƽʱ�ԼĴ�������
		if reset = '0' then            
        	q <= "00000000";
        --��ʱ������������ʱ����ԼĴ������в���
        elsif clk'event and clk = '1' then
        	--��en��д���������źţ�Ϊ1ʱ�ԼĴ�������д����
        	if en = '1' then
				q <= d;
			end if;
        end if;
	end process;
end behave;