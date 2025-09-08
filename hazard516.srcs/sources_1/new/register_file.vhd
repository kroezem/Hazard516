library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all; -- use that, it's a better coding guideline
entity register_file is
    port(
        
        -- Control Signals
        rst,clk: in std_logic; 
        
        -- Reading signals
        rd_index1,rd_index2 : in std_logic_vector(2 downto 0);
        rd_data1,rd_data2: out std_logic_vector(15 downto 0);
        
        --Writing signals
        wr_index: in std_logic_vector(2 downto 0);
        wr_data: in std_logic_vector(15 downto 0);
        wr_en: in std_logic;

        r0,r1,r2,r3,r4,r5,r6,r7: out std_logic_vector(15 downto 0)
  );
end register_file;

architecture behavioural of register_file is
	type reg_array is array (integer range 0 to 7) of std_logic_vector(15 downto 0);


signal reg_file : reg_array := (
        0 => x"0000",
        1 => x"0001",
        2 => x"0002",
        3 => x"0003",
        4 => x"0004",
        5 => x"0005",
        6 => x"0006", --IMM storage
        7 => x"0007" --PC storage
    );


begin 

    process(clk, rst)
    begin
        if rst = '1' then
            for i in 0 to 7 loop
                reg_file(i) <= (others => '0');
            end loop;
            
        elsif not rising_edge(clk) and wr_en = '1' then
            reg_file(to_integer(unsigned(wr_index))) <= wr_data;
        end if;
        
    end process;
    
    rd_data1 <= reg_file(to_integer(unsigned(rd_index1)));
    rd_data2 <= reg_file(to_integer(unsigned(rd_index2)));
    
    r0 <= reg_file(0);
    r1 <= reg_file(1);
    r2 <= reg_file(2);
    r3 <= reg_file(3);
    r4 <= reg_file(4);
    r5 <= reg_file(5);
    r6 <= reg_file(6);
    r7 <= reg_file(7);
    
end behavioural;
