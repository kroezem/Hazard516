----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/23/2025 11:48:41 AM
-- Design Name: 
-- Module Name: and - Behavioral
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

entity and_gate is
 Port ( 
   -- INPUTS
   in1 : in STD_LOGIC_VECTOR(15 downto 0);
   in2 : in STD_LOGIC_VECTOR(15 downto 0);
   
  -- OUTPUTS
   output : out STD_LOGIC_VECTOR(15 downto 0)
   );
end and_gate;

architecture Behavioral of and_gate is

begin

    output <= in1 and in2;



end Behavioral;
