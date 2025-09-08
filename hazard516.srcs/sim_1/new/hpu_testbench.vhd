library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity hpu_testbench is
end hpu_testbench;

architecture Behavioral of hpu_testbench is

    -------------------------------------------------------------------------
    -- Updated HPU component definition
    -------------------------------------------------------------------------
    component hpu is
        port (
            -- Clocks and resets
            global_clk : in  std_logic;
            rst_ex     : in  std_logic;
            rst_ld     : in  std_logic;
            
            
                        
            n_flag     : out  std_logic;
            z_flag     : out  std_logic;
                        
            -- Input/Output Ports
            in_port    : in  std_logic_vector(15 downto 0);
            out_port   : out std_logic_vector(15 downto 0);
            
            -- Debug and board
            debug_console : in std_logic;
            board_clock   : in std_logic;
            
            -- Main pipeline signals
            opcode    : out std_logic_vector(6 downto 0);
            in1       : out std_logic_vector(15 downto 0);
            in2       : out std_logic_vector(15 downto 0);
            alu_mode  : out std_logic_vector(2 downto 0);
            branched  : out std_logic;
            stall     : out std_logic;
            wb_en     : out std_logic;
            wb_data   : out std_logic_vector(15 downto 0);
            wb_idx    : out std_logic_vector(2 downto 0);
            r0, r1, r2, r3,
            r4, r5, r6, r7 : out std_logic_vector(15 downto 0);

            pending_wb_debug : out std_logic_vector(7 downto 0);
            rd_idx1,rd_idx2 : out STD_LOGIC_VECTOR(2 downto 0);

            pc_ex_out : out STD_LOGIC_VECTOR(15 downto 0);
            pc_mem_out : out STD_LOGIC_VECTOR(15 downto 0);
    
            instr_MEM_out : out STD_LOGIC_VECTOR(15 downto 0);
            instr_EX_out : out STD_LOGIC_VECTOR(15 downto 0);
            
            -- Updated pipeline outputs
            pc_IFID_out  : out std_logic_vector(15 downto 0);
            pc_IDEX_out  : out std_logic_vector(15 downto 0);
            pc_EXMEM_out : out std_logic_vector(15 downto 0);
            pc_MEMWB_out : out std_logic_vector(15 downto 0);

            instr_IFID_out  : out std_logic_vector(15 downto 0);
            instr_IDEX_out  : out std_logic_vector(15 downto 0);
            instr_EXMEM_out : out std_logic_vector(15 downto 0);
            instr_MEMWB_out : out std_logic_vector(15 downto 0)
        );
    end component;

    -------------------------------------------------------------------------
    -- Testbench signals
    -------------------------------------------------------------------------
    signal global_clk_tb : std_logic := '0';
    signal rst_ex_tb     : std_logic := '0';
    signal rst_ld_tb     : std_logic := '0';
    signal z_flag_tb     : std_logic := '0';
    signal n_flag_tb     : std_logic := '0';
    signal in_port_tb    : std_logic_vector(15 downto 0) := (others => '0');
    signal out_port_tb   : std_logic_vector(15 downto 0);

    signal pc_mem_tb       : std_logic_vector(15 downto 0);
    signal instr_mem_tb    : std_logic_vector(15 downto 0);

    -- Pipeline stage signals
    signal pc_ifid_tb       : std_logic_vector(15 downto 0);
    signal instr_ifid_tb    : std_logic_vector(15 downto 0);

    signal pc_idex_tb       : std_logic_vector(15 downto 0);
    signal instr_idex_tb    : std_logic_vector(15 downto 0);

    signal pc_exmem_tb      : std_logic_vector(15 downto 0);
    signal instr_exmem_tb   : std_logic_vector(15 downto 0);

    signal pc_memwb_tb      : std_logic_vector(15 downto 0);
    signal instr_memwb_tb   : std_logic_vector(15 downto 0);


    -- Control signals
    signal opcode_tb   : std_logic_vector(6 downto 0);
    signal in1_tb      : std_logic_vector(15 downto 0);
    signal in2_tb      : std_logic_vector(15 downto 0);
    signal alu_mode_tb : std_logic_vector(2 downto 0);
    signal branched_tb : std_logic;
    signal stall_tb    : std_logic;
    signal rd_idx1_tb,rd_idx2_tb   : std_logic_vector(2 downto 0);

    signal wb_en_tb    : std_logic;
    signal wb_data_tb  : std_logic_vector(15 downto 0);
    signal wb_idx_tb   : std_logic_vector(2 downto 0);

    -- Register outputs and debug
    signal r0_tb, r1_tb, r2_tb, r3_tb,
           r4_tb, r5_tb, r6_tb, r7_tb : std_logic_vector(15 downto 0);
    signal pending_wb_tb : std_logic_vector(7 downto 0);
    
begin

    -------------------------------------------------------------------------
    -- Instantiate the HPU (excluding VGA-related signals)
    -------------------------------------------------------------------------
    u0 : hpu
        port map (
            global_clk => global_clk_tb,
            rst_ex     => rst_ex_tb,
            rst_ld     => rst_ld_tb,
            in_port    => in_port_tb,
            out_port   => out_port_tb,

            n_flag     => n_flag_tb,
            z_flag     => z_flag_tb,
            
            debug_console => '0',
            board_clock   => '0',

            opcode    => opcode_tb,
            in1       => in1_tb,
            in2       => in2_tb,
            alu_mode  => alu_mode_tb,
            branched  => branched_tb,
            
            rd_idx1   => rd_idx1_tb,
            rd_idx2   => rd_idx2_tb,
            stall     => stall_tb,
            wb_en     => wb_en_tb,
            wb_data   => wb_data_tb,
            wb_idx    => wb_idx_tb,

            r0 => r0_tb, r1 => r1_tb, r2 => r2_tb, r3 => r3_tb,
            r4 => r4_tb, r5 => r5_tb, r6 => r6_tb, r7 => r7_tb,

            pending_wb_debug => pending_wb_tb,

            pc_MEM_out  => pc_MEM_tb,
            instr_MEM_out  => instr_MEM_tb,

            pc_IFID_out  => pc_ifid_tb,
            pc_IDEX_out  => pc_idex_tb,
            pc_EXMEM_out => pc_exmem_tb,
            pc_MEMWB_out => pc_memwb_tb,

            instr_IFID_out  => instr_ifid_tb,
            instr_IDEX_out  => instr_idex_tb,
            instr_EXMEM_out => instr_exmem_tb,
            instr_MEMWB_out => instr_memwb_tb
        );

    -------------------------------------------------------------------------
    -- Clock process
    -------------------------------------------------------------------------
    clock_process : process
    begin
        -- Example initialization
        in_port_tb <= x"5580";
        
        -- Generate a continuous clock
        while true loop
            wait for 2 ns;
            global_clk_tb <= '0';
            wait for 2 ns;
            global_clk_tb <= '1';
        end loop;
    end process;

end Behavioral;
