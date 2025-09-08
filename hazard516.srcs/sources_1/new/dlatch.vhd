library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dlatch is
    GENERIC ( LEN : integer := 1);
    Port ( D  : in  STD_LOGIC_VECTOR(LEN-1 downto 0);
           CLK : in  STD_LOGIC;
           EN  : in  STD_LOGIC;
           Q  : out STD_LOGIC_VECTOR(LEN-1 downto 0)
           );
end dlatch;

architecture Behavioral of dlatch is
    signal DATA : STD_LOGIC_VECTOR(LEN-1 downto 0);
begin

    DATA <= D when (clk = '1' and EN = '1') else DATA;
    Q <= DATA;

end Behavioral;