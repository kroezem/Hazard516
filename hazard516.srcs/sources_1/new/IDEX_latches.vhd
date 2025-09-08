library IEEE;
use IEEE.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;

entity IDEX_latches is
    port(
        -- CONTROL SIGNALS 
        clk,en,rst : in std_logic;
       
        -- INPUTS
        pc_in : in std_logic_vector(15 downto 0);
        instr_in : in std_logic_vector(15 downto 0);
        opcode_in : in std_logic_vector(6 downto 0);
        out_flag_in : in std_logic;
        
        in1_in,in2_in : in std_logic_vector(15 downto 0);
        
        mem_wr_en_in : in std_logic;
        mem_rd_en_in : in std_logic;

        
        wb_en_in : in std_logic;
        wb_idx_in : in std_logic_vector(2 downto 0);
        
        alu_mode_in : in std_logic_vector(2 downto 0);

        
        -- OUTPUTS
        pc_out : out std_logic_vector(15 downto 0);
        instr_out : out std_logic_vector(15 downto 0);
        opcode_out : out std_logic_vector(6 downto 0);
        out_flag_out : out std_logic;

        in1_out,in2_out : out std_logic_vector(15 downto 0);
        
        mem_wr_en_out : out std_logic;
        mem_rd_en_out : out std_logic;

        
        wb_en_out : out std_logic;
        wb_idx_out : out std_logic_vector(2 downto 0);
        
        alu_mode_out : out std_logic_vector(2 downto 0)
    );
end IDEX_latches;

architecture Behavioral of IDEX_latches is

signal instr : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal PC : STD_LOGIC_VECTOR(15 downto 0) := x"FFFF";
signal opcode : std_logic_vector(6 downto 0);
signal out_flag : std_logic := '0';
signal in1, in2 : std_logic_vector(15 downto 0);
signal mem_wr_en : std_logic := '0';
signal mem_rd_en : std_logic := '0';
signal wb_en : std_logic := '0';
signal wb_idx : std_logic_vector(2 downto 0);
signal alu_mode : std_logic_vector(2 downto 0);

begin
    
    process(clk)
    begin        
    if rising_edge(clk) then
        if (rst = '1') then
            opcode <= (others => '0');
            out_flag <= '0';
        
            instr <= (others => '0');
            pc <= x"FFFF";
            
            in1 <= (others => '0');
            in2 <= (others => '0');

            mem_wr_en <= '0';
            mem_rd_en <= '0';
            
            wb_en <= '0';
            wb_idx <= (others => '0');
            
            alu_mode <= (others => '0');

        elsif en = '1' then
            opcode <= opcode_in;  
            out_flag <= out_flag_in;

            pc <= pc_in;
            instr <= instr_in;
            
            in1 <= in1_in;
            in2 <= in2_in;
            
            mem_wr_en <= mem_wr_en_in;
            mem_rd_en <= mem_rd_en_in;
            
            wb_en <= wb_en_in;
            wb_idx <= wb_idx_in;
            
            alu_mode <= alu_mode_in; 
            
        end if;
    end if;
    end process;

    opcode_out <= opcode;  
    out_flag_out <= out_flag;
       
    pc_out <= pc;
    instr_out <= instr;
       
    in1_out <= in1;
    in2_out <= in2;
    
    mem_wr_en_out <= mem_wr_en;
    mem_rd_en_out <= mem_rd_en;
    
    wb_en_out <= wb_en;
    wb_idx_out <= wb_idx;
    
    alu_mode_out <= alu_mode;

    
end Behavioral ; -- Behavioral