library ieee;
use ieee.std_logic_1164.all;

entity reg_mux is
	port(
		 --4个通用寄存器数据输入
		 reg_0:   in std_logic_vector(7 downto 0);
	     reg_1:   in std_logic_vector(7 downto 0);
		 reg_2:   in std_logic_vector(7 downto 0);
		 reg_3:   in std_logic_vector(7 downto 0);
		 --选择目的寄存器
		 dest_reg:in std_logic_vector(1 downto 0);
		 --选择源寄存器
		 sour_reg:in std_logic_vector(1 downto 0);
		 --外部选择寄存器信号
		 reg_sel: in std_logic_vector(1 downto 0);
		 --总使能信号
		 en:      in std_logic;
		 --4个通用寄存器各自的使能信号
		 en_0:    out std_logic;
	     en_1:    out std_logic;
		 en_2:    out std_logic;
		 en_3:    out std_logic;
		 --目的寄存器的输出数据
		 dr:      out std_logic_vector(7 downto 0);
	     --源寄存器的输出数据
	     sr:      out std_logic_vector(7 downto 0);
	     --输出到外部的寄存器数据
	     reg_out: out std_logic_vector(7 downto 0));
end reg_mux;

architecture behave of reg_mux is
begin
	process(dest_reg,sour_reg,reg_sel,reg_0,reg_1,
	        reg_2,reg_3,en)
	
	--temp每一位代表对应寄存器的使能信号
	variable temp : std_logic_vector(3 downto 0);
	begin
		--选择信号与输出的一一对应，使能信号具体化
		
		--选择目的寄存器
		case dest_reg is
		when "00"=>
			dr<=reg_0;
			temp := "0001";
		when "01"=>
			dr<=reg_1;
			temp := "0010";
		when "10"=>
			dr<=reg_2;
			temp := "0100";
		when "11"=>
			dr<=reg_3;
			temp := "1000";
		end case;

		--总使能信号
		if en = '0' then
			temp := "0000";
		end if;

		--4个通用寄存器各自的使能信号
		en_0 <= temp(0);
		en_1 <= temp(1);
		en_2 <= temp(2);
		en_3 <= temp(3);

		--选择源寄存器
		case sour_reg is
		when "00"=>
			sr<=reg_0;
		when "01"=>
			sr<=reg_1;
		when "10"=>
			sr<=reg_2;
		when "11"=>
			sr<=reg_3;
		end case;

		--外部选择寄存器信号
		case reg_sel is
		when "00"=>
			reg_out<=reg_0;
		when "01"=>
			reg_out<=reg_1;
		when "10"=>
			reg_out<=reg_2;
		when "11"=>
			reg_out<=reg_3;
		end case;
	end process;
end behave;