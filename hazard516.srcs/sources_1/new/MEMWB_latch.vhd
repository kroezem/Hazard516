library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity MEMWB_latches is
    port(
        -- CONTROL SIGNALS 
        clk,en,rst : in std_logic;
       
        -- INPUTS
        pc_in,instr_in : in std_logic_vector(15 downto 0);
        wb_data_in : in std_logic_vector(15 downto 0);
        wb_en_in : in std_logic;
        wb_idx_in : in std_logic_vector(2 downto 0);
        
        -- OUTPUTS
        pc_out,instr_out : out std_logic_vector(15 downto 0);
        wb_data_out : out std_logic_vector(15 downto 0);
        wb_en_out : out std_logic;
        wb_idx_out : out std_logic_vector(2 downto 0)
    );
end MEMWB_latches;

architecture Behavioral of MEMWB_latches is

signal wb_data : std_logic_vector(15 downto 0);
signal wb_en : std_logic := '0';
signal wb_idx : std_logic_vector(2 downto 0);
signal PC : std_logic_vector(15 downto 0) := x"FFFF";
signal instr : std_logic_vector(15 downto 0) := x"0000";

begin
    
    process(clk)
    begin
    if rising_edge(clk) then
        if (rst = '1') then
            pc <= x"FFFF";
            instr <= (others => '0');
            wb_data <= (others => '0');
            wb_en <= '0';
            wb_idx <= (others => '0');
        elsif (en = '1') then
            pc <= pc_in;
            instr <= instr_in;
            wb_data <= wb_data_in;
            wb_en <= wb_en_in;
            wb_idx <= wb_idx_in;
        end if;
    end if;
    end process;

    pc_out <= pc;
    instr_out <= instr;
    wb_data_out <= wb_data;
    wb_en_out <= wb_en;
    wb_idx_out <= wb_idx;

    
end Behavioral;
