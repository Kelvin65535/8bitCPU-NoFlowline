library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity dram is
port(reset,wr : in std_logic;
         addr : in std_logic_vector(15 downto 0);
         data : inout std_logic_vector(15 downto 0));
end dram;

architecture b_dram of dram is
type MEMORY is array(0 to 31) of std_logic_vector(15 downto 0);
signal mem : MEMORY;
begin
  process(reset,wr,addr,data)
  begin
    if reset='0' then            
	   mem<=(
	          "0000000011010000", --MVRD R0,25
	          "0000000000011001",
	          "0000000011010100", --MVRD R1,6
	          "0000000000000110",
	          "0000000000110000", --NEG R0
	          "0000000000110100", --NEG R1
	          "0000000001000000", --ROL R0
	          "0000000001010100", --ROR R1
	          "0000000010100000", --STC
	          "0000000001100000", --RCL R0
	          "0000000010100000", --STC
	          "0000000001110100", --RCR R1
	          "0000000000000000",
	          "0000000000000000",
	          "0000000000000000",
	          "0000000000000000",
	          "0000000000000000",
	          "0000000000000000",
	          "0000000000000000",
	          "0000000000000000",
	          "0000000000000000",
	          "0000000000000000",
	          "0000000000000000",
	          "0000000000000000",
	          "0000000000000000",
	          "0000000000000000",
	          "0000000000000000",
	          "0000000000000000",
	          "0000000000000000",
	          "0000000000000000",
	          "0000000000000000",
	          "0000000000000000"
	        );
	end if;
    if wr='1' then
       data<=mem(conv_integer(addr));
    elsif wr='0' then
       mem(conv_integer(addr))<=data;
    end if;
  end process;
end b_dram;
