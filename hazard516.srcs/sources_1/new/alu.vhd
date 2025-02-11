----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/10/2025 04:14:59 PM
-- Design Name: 
-- Module Name: alu - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all; -- use that, it's a better coding guideline

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu is
port (
	in1,in2 : in STD_LOGIC_VECTOR(15 downto 0);
	alu_mode : in STD_LOGIC_VECTOR(2 downto 0);
	clk : in STD_LOGIC;
    rst : in STD_LOGIC;
    
	result   : out STD_LOGIC_VECTOR(15 downto 0);
	z_flag   : out STD_LOGIC;
	n_flag   : out STD_LOGIC
	);
end alu;

architecture Behavioral of alu is

begin

process(clk)

variable product: std_logic_vector(31 downto 0) := (others => '0');
variable temp: std_logic_vector(15 downto 0) := (others => '0');
variable zeros: std_logic_vector(15 downto 0) := (others => '0');

begin

if (rst = '1') then
    z_flag <= '0';
    n_flag <= '0';
    result <= zeros;
    
else 

    if (alu_mode /= "000") then
        if(alu_mode = "001") then
            temp := STD_LOGIC_VECTOR(signed(in1) + signed(in2));
            
        elsif(alu_mode = "010") then
            temp := STD_LOGIC_VECTOR(signed(in1) - signed(in2));
            
        elsif(alu_mode = "011") then
            product := STD_LOGIC_VECTOR(signed(in1) * signed(in2));
            temp := product (15 downto 0);
            
        elsif(alu_mode = "100") then
            temp := STD_LOGIC_VECTOR(signed(in1) NAND signed(in2));
            
        elsif(alu_mode = "101") then
             temp := STD_LOGIC_VECTOR(shift_left(signed(in1),1));   --UPDATE TO SHIFT BY AN INPUT VALUE
             
        elsif(alu_mode = "110") then
             temp := STD_LOGIC_VECTOR(shift_right(signed(in1),1));   --UPDATE TO SHIFT BY AN INPUT VALUE   
             
        elsif(alu_mode = "111") then
            temp := in1;
            
        else 
            temp := zeros;
    
        end if;
    end if;

    result <= temp;

    if (temp = zeros) then
        z_flag <= '1';
    else
        z_flag <= '0';
    end if;
    
    n_flag <= STD_LOGIC(temp(15));
       
end if;
end process;
    

end Behavioral;
