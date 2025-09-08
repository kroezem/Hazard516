----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2025 01:50:04 PM
-- Design Name: 
-- Module Name: IFID_latches - Behavioral
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


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IFID_latches is
    Port ( 
        
        -- CONTROL SIGNALS 
        clk,en,rst : in std_logic;
        
        PC_in : in STD_LOGIC_VECTOR(15 downto 0);
        PC_out : out STD_LOGIC_VECTOR(15 downto 0);
        
        instr_in : in STD_LOGIC_VECTOR(15 downto 0);
        instr_out : out STD_LOGIC_VECTOR(15 downto 0)
    );
    
end IFID_latches;

architecture Behavioral of IFID_latches is

signal instr : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal PC : STD_LOGIC_VECTOR(15 downto 0) := x"FFFF";

begin

    process(clk)
    begin
        if rising_edge(clk) then 
            if (rst = '1') then
                instr <= (others => '0');
                PC <= x"FFFF";
        
            elsif en = '1' then
                instr <= instr_in;
                PC <= PC_in;
            end if;
        end if;
        
    end process;
        
    instr_out <= instr;
    PC_out <= PC;

end Behavioral;
