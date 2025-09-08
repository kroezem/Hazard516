library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity EXMEM_latches is
    port(
        -- CONTROL SIGNALS 
        clk,en,rst : in std_logic;
       
        -- INPUTS
        PC_in : in std_logic_vector(15 downto 0);
        PC_tb_in : in std_logic_vector(15 downto 0);
        instr_in : in std_logic_vector(15 downto 0);

        mem_wr_en_in : in std_logic;
        mem_rd_en_in : in std_logic;
        
        
        wb_en_in : in std_logic;
        wb_idx_in : in std_logic_vector(2 downto 0);
        
        din_in : in std_logic_vector(15 downto 0);
        result_in : in std_logic_vector(15 downto 0);
        
        -- OUTPUTS
        PC_out : out std_logic_vector(15 downto 0);
        PC_tb_out : out std_logic_vector(15 downto 0);
        instr_out : out std_logic_vector(15 downto 0);

        mem_wr_en_out : out std_logic;
        mem_rd_en_out : out std_logic;
        
        wb_en_out : out std_logic;
        wb_idx_out : out std_logic_vector(2 downto 0);
        
        din_out : out std_logic_vector(15 downto 0);
        result_out : out std_logic_vector(15 downto 0)

    );
end EXMEM_latches;

architecture Behavioral of EXMEM_latches is

signal PC : std_logic_vector(15 downto 0) := x"0000";

signal PC_tb : std_logic_vector(15 downto 0) := x"FFFF";
signal instr : std_logic_vector(15 downto 0) := x"0000";

signal mem_wr_en : std_logic := '0';
signal mem_rd_en : std_logic := '0';
signal wb_en : std_logic := '0';
signal wb_idx : std_logic_vector(2 downto 0);
signal din : std_logic_vector(15 downto 0);
signal result : std_logic_vector(15 downto 0);


begin
    
    process(clk)
    begin
    if rising_edge(clk) then
        if (rst = '1') then
--            PC <= x"0000";
            PC_TB <= x"FFFF";
            instr <= (others => '0');
            mem_wr_en <= '0';
            mem_rd_en <= '0';
            wb_en <= '0';
            wb_idx <= (others => '0');
            din <= (others => '0');
            result <= (others => '0');
            
        elsif (en = '1') then
            PC <= PC_in;
            PC_TB <= PC_tb_in;
            instr <= instr_in;
            mem_wr_en <= mem_wr_en_in;
            mem_rd_en <= mem_rd_en_in;
            wb_en <= wb_en_in;
            wb_idx <= wb_idx_in;
            din <= din_in;
            result <= result_in;
            
        end if;
    end if;
    end process;

    PC_out <= PC;
    PC_tb_out <= PC_tb;
    instr_out <= instr;
    mem_wr_en_out <= mem_wr_en;
    mem_rd_en_out <= mem_rd_en;
    wb_en_out <= wb_en;
    wb_idx_out <= wb_idx;
    din_out <= din;
    result_out <= result;


end Behavioral;
