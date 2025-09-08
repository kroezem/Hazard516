----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2025 05:38:19 PM
-- Design Name: 
-- Module Name: mem_sel - Behavioral
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

entity mem_sel is
    Port ( pc : in STD_LOGIC_VECTOR (15 downto 0);
           mem_select : out STD_LOGIC;
           addr : out STD_LOGIC_VECTOR (15 downto 0));
end mem_sel;

architecture Behavioral of mem_sel is

begin
    process(pc) begin
        mem_select <= pc(11);
        
        addr <= (others => '0');
        addr(10 downto 0) <= pc(10 downto 0);
    end process;
end Behavioral;
