------------------------------------------------------------------------------------------------
--
-- ECE441/ECE543 Summer 2022
--
-- ASM implemnetation of 4x4 Multiplier
--
-- this code is based on: section 4.4 of Roth "Digitial Systems Design
--                                             Using VHDL"
--                                             (c) 1998 PWS Publishing Company 
--
-------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mult4x4 is
    port (
    clk, St:        in std_logic;
    Mplier, Mcand : in std_logic_vector(3 downto 0);
    Done:           out std_logic;
    Product:        out std_logic_vector(7 downto 0));
end mult4x4;

architecture behave1 of mult4x4 is
    signal State: integer range 0 to 9;
    signal ACC: std_logic_vector(8 downto 0); -- the accumulator
    alias  M:   std_logic is ACC(0); -- M is bit 0 of ACC

begin
    Product <= ACC(7 downto 0);
    
    process (Clk)
    begin
    if clk'event and clk = '1' then
        case State is
        when 0 =>
            if St='1' then
                ACC(8 downto 4) <= "00000";
                ACC(3 downto 0) <= Mplier;
                State <= 1;``
        end if;

        when 1|3|5|7 =>
            if M = '1' then
                ACC(8 downto 4) <= ('0'& ACC(7 downto 4)) + Mcand;
                State <= State + 1;
            else ACC <= '0' & ACC(8 downto 1);   -- shift ACC right
            State <= State + 2;
        end if;

        when 2|4|6|8 =>
            ACC <= '0' & ACC(8 downto 1);
            State <= State + 1;
            when 9 =>
                State <= 0;

end case;
end if;

end process;
Done <= '1' when State = 9 else '0';

end behave1;


