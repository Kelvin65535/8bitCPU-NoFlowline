library ieee;
use ieee.std_logic_1164.all;

entity reg_out is
    port(ir,pc,reg_in:       			in std_logic_vector(7 downto 0);
         offset,alu_a,alu_b:  			in std_logic_vector(7 downto 0);
         alu_out,reg_testa,reg_testb:   in std_logic_vector(7 downto 0);
         reg_sel:             			in std_logic_vector(1 downto 0);
         sel:                 			in std_logic_vector(1 downto 0);
         reg_data:            			out std_logic_vector(7 downto 0));
end reg_out;

architecture behave of reg_out is
begin
	process(ir,pc,reg_in,sel,reg_sel,offset,alu_a,alu_b,alu_out,reg_testa)
	variable temp: std_logic_vector(3 downto 0) ;
	begin
	    temp := sel & reg_sel;
		case sel is
			when "00"=>
				--0~3�����ͨ�üĴ�������
				reg_data<=reg_in;

			when "01"=>
				case reg_sel is
				--4�������չ���offset
				when "00"=>
				reg_data<=offset;
				--5��6�����alu����������
				when "01"=>
				reg_data<=alu_a;
				when "10"=>
				reg_data<=alu_b;
				--7�����alu��������
				when "11"=>
				reg_data<=alu_out;
				when others=>
				reg_data<="00000000";
				end case;

			when "11"=>
				case reg_sel is
				--12��13������ض��Ĵ���reg_testa��b�����ݣ�����һЩ�ڲ��ź�
				when "00"=>
				reg_data<=reg_testa;
				when "01"=>
				reg_data<=reg_testb;
				--14�����PC
				when "10"=>
				reg_data<=pc;
				--15�����IR
				when "11"=>
				reg_data<=ir;
				when others=>
				reg_data<="00000000";
				end case;

			when others=>
				reg_data<="00000000";
		end case;
	end process;
end behave;
