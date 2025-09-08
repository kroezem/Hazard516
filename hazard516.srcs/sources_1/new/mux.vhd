----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/10/2025 04:43:59 PM
-- Design Name: 
-- Module Name: mux - Behavioral
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

entity mux is
    port(
    en   : in std_logic;
    in0  : in std_logic_vector(15 downto 0);
    in1  : in std_logic_vector(15 downto 0);
    output  : out std_logic_vector(15 downto 0)
);
end mux;

architecture Behavioral of mux is

begin
    process(en, in0, in1)
    begin
        if en = '1' then
            output <= in1;
        else
            output <= in0;
        end if;
        
    end process;
    
end Behavioral;
