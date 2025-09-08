----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/11/2025
-- Design Name: 
-- Module Name: ram - Dummy RAM Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Simple behavioral RAM storing 16-bit words with explicit init for 
--              first 8 addresses.
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

entity dummy_ram is
    port (
        clk   : in std_logic;
        
        addra,addrb  : in std_logic_vector(15 downto 0);

        ena,enb,wea    : in std_logic;
        dina   : in std_logic_vector(15 downto 0); 
        
        douta  : out std_logic_vector(15 downto 0);
        doutb  : out std_logic_vector(15 downto 0)
    );
end entity dummy_ram;

architecture dummy_ram of dummy_ram is

    ----------------------------------------------------------------------------
    -- Memory array for storing up to 256 words (16-bit each). 
    -- Here we explicitly set the first 8 locations to some dummy instructions.
    ----------------------------------------------------------------------------
    type mem_array is array (0 to 1023) of std_logic_vector(15 downto 0);
    signal mem : mem_array := (others => (others => '0'));

begin

    ----------------------------------------------------------------------------
    -- Single clocked process handling both Port A (read/write) and Port B (read)
    ----------------------------------------------------------------------------
    process(clk)
    begin
        if not rising_edge(clk) then

            if wea = '1' then
                mem(to_integer(unsigned(addra(7 downto 0)))) <= dina;
            end if;

            if ena = '1' then
                douta <= mem(to_integer(unsigned(addra(7 downto 0))));
            else
                douta <= (others => '0');
            end if;


            if enb = '1' then
                doutb <= mem(to_integer(unsigned(addrb(7 downto 0))));
            else
                doutb <= (others => '0');
            end if;

        end if;
    end process;

end architecture dummy_ram;
