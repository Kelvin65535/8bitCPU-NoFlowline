library ieee;
use ieee.std_logic_1164.all;

----------------IRָ��Ĵ���-----------------
--��Ŵ��ڴ���ȡ��ָ������
--���������������ߣ�ָ�����ڴ澭���������߽���IR
--������������߼���׼����һ������

--��AR��ַ�Ĵ������ÿ����ź�REC
-------------REC�����ź�˵��---------------
------|REC|--------|      ����      |-----
------|---|--------|----------------|-----
------| 00|--------|     �޲���     |-----
------| 01|--------|     �޲���     |-----
------| 11|--------|     �޲���     |-----
------| 10|--------|IR���մ�����ָ�� |-----
------------------------------------------

----ʵ������----
entity ir is
	port(
		 --��mem_data���������ڴ��ָ��
		 mem_data:  in std_logic_vector(15 downto 0);
	     --recΪIR�����źţ���AR��ַ�Ĵ�������
	     rec:       in std_logic_vector(1 downto 0);
	     --clkΪʱ�ӣ�resetΪ��λ��reset�͵�ƽ����
	     clk,reset: in std_logic;
	     --qΪ���������ַ���������߼�
	     q:         out std_logic_vector(7 downto 0));
end ir;

----ʵ����Ϊ����----
architecture behave of ir is
begin
	process(clk,reset)
	begin
		--��reset����λ��Ϊ�͵�ƽʱָ��Ĵ�������
		if reset = '0' then            
        	q <= "00000000";
        --��ʱ��Ϊ������ʱ����IR����
        elsif clk'event and clk = '1' then
			--����rec�����źŲ�ͬѡ���Ƿ���ڴ浥Ԫ��ȡָ��
			case rec is
				--��recΪ10ʱ���ڴ浥Ԫ��ȡָ��
				when "10"=>
					q <= mem_data(7) & mem_data(6) & mem_data(5) & mem_data(4) & mem_data(3) & mem_data(2) & mem_data(1) & mem_data(0);
				--�������IR��������
				when others=>
					null;
			end case;		
        end if;
	end process;
end behave;