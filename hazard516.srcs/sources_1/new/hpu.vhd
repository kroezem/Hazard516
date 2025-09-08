----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2025 10:14:01 AM
-- Design Name: 
-- Module Name: hpu - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hpu is
   port (
    -- ## REAL IO
        global_clk : in STD_LOGIC;
        
        rst_ex : in STD_LOGIC;
        rst_ld : in STD_LOGIC;
        
        in_port : in STD_LOGIC_VECTOR(15 downto 0);
        
        out_port : out STD_LOGIC_VECTOR(15 downto 0);
    
        debug_console : in STD_LOGIC;
        board_clock: in std_logic;
    
        vga_red : out std_logic_vector( 3 downto 0 );
        vga_green : out std_logic_vector( 3 downto 0 );
        vga_blue : out std_logic_vector( 3 downto 0 );
    
        h_sync_signal : out std_logic;
        v_sync_signal : out std_logic;
                
        
    -- ## TESTBENCH IO

        pc_ex_out : out STD_LOGIC_VECTOR(15 downto 0);
        pc_mem_out : out STD_LOGIC_VECTOR(15 downto 0);

        instr_MEM_out : out STD_LOGIC_VECTOR(15 downto 0);
        instr_EX_out : out STD_LOGIC_VECTOR(15 downto 0);
        

        pc_IFID_out : out STD_LOGIC_VECTOR(15 downto 0);
        pc_IDEX_out : out STD_LOGIC_VECTOR(15 downto 0);
        pc_EXMEM_out : out STD_LOGIC_VECTOR(15 downto 0);
        pc_MEMWB_out : out STD_LOGIC_VECTOR(15 downto 0);
        
        instr_IFID_out : out STD_LOGIC_VECTOR(15 downto 0);
        instr_IDEX_out : out STD_LOGIC_VECTOR(15 downto 0);
        instr_EXMEM_out : out STD_LOGIC_VECTOR(15 downto 0);
        instr_MEMWB_out : out STD_LOGIC_VECTOR(15 downto 0);
        
        n_flag     : out  std_logic;
        z_flag     : out  std_logic;
                
        opcode : out STD_LOGIC_VECTOR(6 downto 0);
       
        in1 : out STD_LOGIC_VECTOR(15 downto 0);
        in2 : out STD_LOGIC_VECTOR(15 downto 0);
        
        alu_mode : out STD_LOGIC_VECTOR(2 downto 0);
        
        rd_idx1,rd_idx2 : out STD_LOGIC_VECTOR(2 downto 0);

        branched,stall : out STD_LOGIC;
        
        wb_en : out STD_LOGIC;
        wb_data : out STD_LOGIC_VECTOR(15 downto 0);
        wb_idx : out STD_LOGIC_VECTOR(2 downto 0);

        r0,r1,r2,r3,r4,r5,r6,r7: out STD_LOGIC_VECTOR(15 downto 0);
                
        pending_wb_debug : out STD_LOGIC_VECTOR(7 downto 0)
        
    );

end hpu;

architecture brent of hpu is
    
 
-- ## INSTRUCTION DECODER and IDIF_LATCHES INTERMEDIARY SIGNALS ##
    signal instr_ID     : STD_LOGIC_VECTOR(15 downto 0);
    signal opcode_ID    : STD_LOGIC_VECTOR(6 downto 0);
    signal alu_mode_ID  : STD_LOGIC_VECTOR(2 downto 0);
    signal out_flag_ID : STD_LOGIC := '0';
    signal PC_ID     : STD_LOGIC_VECTOR(15 downto 0);

    
    signal wb_en_ID     : STD_LOGIC := '0';
    signal wb_idx_ID    : STD_LOGIC_VECTOR(2 downto 0);
    
    signal rd_idx1_ID   : STD_LOGIC_VECTOR(2 downto 0);
    signal rd_idx2_ID   : STD_LOGIC_VECTOR(2 downto 0);
    
    signal imm_val_ID   : STD_LOGIC_VECTOR(15 downto 0);
    signal imm_en_ID    : STD_LOGIC := '0';
    
    signal mem_wr_en_ID : STD_LOGIC := '0';
    signal mem_rd_en_ID : STD_LOGIC := '0';
        
    signal in1_ID,in2_ID : STD_LOGIC_VECTOR(15 downto 0);
    signal rd_data1_ID, rd_data2_ID : STD_LOGIC_VECTOR(15 downto 0);
    signal mask_ID : STD_LOGIC_VECTOR(15 downto 0) := x"FFFF";

    
-- ## ALU, BRANCH and EXMEM_LATCHES INTERMEDIARY SIGNALS ##
    signal rst_ex_EX,rst_ld_EX : STD_LOGIC := '0';

    signal instr_IDEX : STD_LOGIC_VECTOR(15 downto 0);
    signal PC_IDEX : STD_LOGIC_VECTOR(15 downto 0);
    signal PC_EX : STD_LOGIC_VECTOR(15 downto 0);
    signal opcode_EX : STD_LOGIC_VECTOR(6 downto 0);
    signal alu_mode_EX : STD_LOGIC_VECTOR(2 downto 0);
    signal out_flag_EX : STD_LOGIC := '0';

    signal branched_EX,stall_EX : STD_LOGIC := '0';
    signal PC_wb_EX : STD_LOGIC_VECTOR(15 downto 0);


    signal mem_wr_en_EX : STD_LOGIC := '0';
    signal mem_rd_en_EX : STD_LOGIC := '0';

    signal wb_en_EX : STD_LOGIC := '0';
    signal wb_idx_EX : STD_LOGIC_VECTOR(2 downto 0);
    
    signal in1_EX, in2_EX : STD_LOGIC_VECTOR(15 downto 0);
    
    signal alu_result_EX : STD_LOGIC_VECTOR(15 downto 0);
    signal result_EX : STD_LOGIC_VECTOR(15 downto 0);

    signal z_flag_EX, n_flag_EX: STD_LOGIC := '0';
    


-- ## MEMORY and MEMWB_LATCHES INTERMEDIARY SIGNALS ##
    signal PC_MEM : STD_LOGIC_VECTOR(15 downto 0);
    
    signal PC_EXMEM : STD_LOGIC_VECTOR(15 downto 0);
    signal instr_EXMEM : STD_LOGIC_VECTOR(15 downto 0);    
    
    signal PC_MEMWB : STD_LOGIC_VECTOR(15 downto 0);
    signal instr_MEMWB : STD_LOGIC_VECTOR(15 downto 0);

    signal instr_select_MEM : STD_LOGIC := '0';
    signal instr_addr_MEM : STD_LOGIC_VECTOR(15 downto 0);
    signal instr_MEM : STD_LOGIC_VECTOR(15 downto 0);

    signal mem_wr_en_MEM : STD_LOGIC := '0';
    signal mem_rd_en_MEM : STD_LOGIC := '0';
    signal mem_wr_en_MEM_0x0vec : STD_LOGIC_VECTOR(0 downto 0);
 
    signal din_MEM,dout_MEM : STD_LOGIC_VECTOR(15 downto 0);
    signal result_MEM : STD_LOGIC_VECTOR(15 downto 0);
    
    signal rom_dout_MEM : STD_LOGIC_VECTOR(15 downto 0);
    signal ram_dout_MEM : STD_LOGIC_VECTOR(15 downto 0);
    
    
    signal wb_en_MEM : STD_LOGIC := '0';
    signal wb_idx_MEM : STD_LOGIC_VECTOR(2 downto 0);   
    signal wb_data_MEM : STD_LOGIC_VECTOR(15 downto 0);

    signal wb_en_WB : STD_LOGIC := '0';
    signal wb_idx_WB : STD_LOGIC_VECTOR(2 downto 0);   
    signal wb_data_WB : STD_LOGIC_VECTOR(15 downto 0);
    
    
    
    

-- ## LATCHES & RST##
    signal IFID_en_FC: STD_LOGIC := '1';
    signal IFID_rst_FC : STD_LOGIC := '0';
    
    signal IDEX_en_FC: STD_LOGIC := '1';
    signal IDEX_rst_FC : STD_LOGIC := '0';
    
    signal EXMEM_en_FC: STD_LOGIC := '1';
    signal EXMEM_rst_FC: STD_LOGIC := '0';
    
    signal MEMWB_en_FC: STD_LOGIC := '1';
    signal MEMWB_rst_FC: STD_LOGIC := '0';
    
    signal rg_rst_FC : STD_LOGIC := '0';
    signal alu_rst_FC : STD_LOGIC := '0';
    
    signal out_port_FC : STD_LOGIC_VECTOR(15 downto 0);
    
    signal r0_i,r1_i,r2_i,r3_i,r4_i,r5_i,r6_i,r7_i : STD_LOGIC_VECTOR(15 downto 0);
    signal pending_wb : STD_LOGIC_VECTOR(7 downto 0);


component console is
    port (

--
-- Stage 1 Fetch
--
        s1_pc : in STD_LOGIC_VECTOR ( 15 downto 0 );
        s1_inst : in STD_LOGIC_VECTOR ( 15 downto 0 );


--
-- Stage 2 Decode
--
        s2_pc : in STD_LOGIC_VECTOR ( 15 downto 0 );
        s2_inst : in STD_LOGIC_VECTOR ( 15 downto 0 );

        s2_reg_a : in STD_LOGIC_VECTOR( 2 downto 0 );
        s2_reg_b : in STD_LOGIC_VECTOR( 2 downto 0 );
        s2_reg_c : in STD_LOGIC_VECTOR( 2 downto 0 );

        s2_reg_a_data : in STD_LOGIC_VECTOR( 15 downto 0 );
        s2_reg_b_data : in STD_LOGIC_VECTOR( 15 downto 0 );
        s2_reg_c_data : in STD_LOGIC_VECTOR( 15 downto 0 );

        s2_immediate : in STD_LOGIC_VECTOR( 15 downto 0 );


--
-- Stage 3 Execute
--
        s3_pc : in STD_LOGIC_VECTOR ( 15 downto 0 );
        s3_inst : in STD_LOGIC_VECTOR ( 15 downto 0 );

        s3_reg_a : in STD_LOGIC_VECTOR( 2 downto 0 );
        s3_reg_b : in STD_LOGIC_VECTOR( 2 downto 0 );
        s3_reg_c : in STD_LOGIC_VECTOR( 2 downto 0 );

        s3_reg_a_data : in STD_LOGIC_VECTOR( 15 downto 0 );
        s3_reg_b_data : in STD_LOGIC_VECTOR( 15 downto 0 );
        s3_reg_c_data : in STD_LOGIC_VECTOR( 15 downto 0 );

        s3_immediate : in STD_LOGIC_VECTOR( 15 downto 0 );

--
-- Branch and memory operation
--
        s3_r_wb : in STD_LOGIC;
        s3_r_wb_data : in STD_LOGIC_VECTOR( 15 downto 0 );

        s3_br_wb : in STD_LOGIC;
        s3_br_wb_address : in STD_LOGIC_VECTOR( 15 downto 0 );

        s3_mr_wr : in STD_LOGIC;
        s3_mr_wr_address : in STD_LOGIC_VECTOR( 15 downto 0 );
        s3_mr_wr_data : in STD_LOGIC_VECTOR( 15 downto 0 );

        s3_mr_rd : in STD_LOGIC;
        s3_mr_rd_address : in STD_LOGIC_VECTOR( 15 downto 0 );

--
-- Stage 4 Memory
--
        s4_pc : in STD_LOGIC_VECTOR( 15 downto 0 );
        s4_inst : in STD_LOGIC_VECTOR( 15 downto 0 );

        s4_reg_a : in STD_LOGIC_VECTOR( 2 downto 0 );

        s4_r_wb : in STD_LOGIC;
        s4_r_wb_data : in STD_LOGIC_VECTOR( 15 downto 0 );

--
-- CPU registers
--

        register_0 : in STD_LOGIC_VECTOR ( 15 downto 0 );
        register_1 : in STD_LOGIC_VECTOR ( 15 downto 0 );
        register_2 : in STD_LOGIC_VECTOR ( 15 downto 0 );
        register_3 : in STD_LOGIC_VECTOR ( 15 downto 0 );
        register_4 : in STD_LOGIC_VECTOR ( 15 downto 0 );
        register_5 : in STD_LOGIC_VECTOR ( 15 downto 0 );
        register_6 : in STD_LOGIC_VECTOR ( 15 downto 0 );
        register_7 : in STD_LOGIC_VECTOR ( 15 downto 0 );

--
-- CPU registers overflow flags
--
        register_0_of : in STD_LOGIC;
        register_1_of : in STD_LOGIC;
        register_2_of : in STD_LOGIC;
        register_3_of : in STD_LOGIC;
        register_4_of : in STD_LOGIC;
        register_5_of : in STD_LOGIC;
        register_6_of : in STD_LOGIC;
        register_7_of : in STD_LOGIC;

--
-- CPU Flags
--
        zero_flag : in STD_LOGIC;
        negative_flag : in STD_LOGIC;
        overflow_flag : in STD_LOGIC;

--
-- Debug screen enable
--
        debug : in STD_LOGIC;

--
-- Text console display memory access signals ( clk is the processor clock )
--
        addr_write : in  STD_LOGIC_VECTOR (15 downto 0);
        clk : in  STD_LOGIC;
        data_in : in  STD_LOGIC_VECTOR (15 downto 0);
        en_write : in  STD_LOGIC;

--
-- Video related signals
--
        board_clock : in STD_LOGIC;
        v_sync_signal : out STD_LOGIC;
        h_sync_signal : out STD_LOGIC;
        vga_red : out STD_LOGIC_VECTOR( 3 downto 0 );
        vga_green : out STD_LOGIC_VECTOR( 3 downto 0 );
        vga_blue : out STD_LOGIC_VECTOR( 3 downto 0 )

    );
end component;


    

begin
    mem_wr_en_MEM_0x0vec  <= (0=>mem_wr_en_MEM);

    IFID_latch : entity work.IFID_latches
        port map (
            clk => global_clk, en => IFID_en_FC, rst => IFID_rst_FC, 
            PC_in=>PC_MEM,
            PC_out=>PC_ID,
            instr_in=>instr_MEM,
            instr_out=>instr_ID
        );


    decoder : entity work.instr_decoder 
        port map( 
            instr      => instr_ID,
            stall      => stall_EX,
            
            opcode     => opcode_ID,
            alu_mode   => alu_mode_ID,
            
            out_flag   => out_flag_ID,
            
            wb_en      => wb_en_ID,
            wb_idx     => wb_idx_ID,
            
            rd_idx1    => rd_idx1_ID,
            rd_idx2    => rd_idx2_ID,
            
            imm_val    => imm_val_ID,
            imm_en     => imm_en_ID,
            
            mem_wr_en  => mem_wr_en_ID,
            mem_rd_en  => mem_rd_en_ID,
            
            mask => mask_ID,
            in_port => in_port
        );


    registerfile : entity work.register_file 
        port map (
            rst=> rg_rst_FC, clk=>global_clk, 
            
            rd_index1=> rd_idx1_ID, rd_index2 => rd_idx2_ID,
            rd_data1=> rd_data1_ID, rd_data2 => rd_data2_ID,

            wr_index => wb_idx_WB, 
            wr_data => wb_data_WB, 
            wr_en => wb_en_WB,
            r0 => r0_i, r1 => r1_i, r2 => r2_i, r3 => r3_i, r4 => r4_i, r5 => r5_i, r6 => r6_i, r7 => r7_i
        );


    imm_MUX : entity work.mux
        port map(
            en => imm_en_ID,
            in0 => rd_data2_ID,
            in1 => imm_val_ID,
            output => in2_ID
        );
     
    and16bit : entity work.and_gate
        port map(
            in1 => mask_ID,
            in2 => rd_data1_ID,
            output => in1_ID 
        );

    IDEX_latch : entity work.IDEX_LATCHES
        port map(
            clk=>global_clk, en=> IDEX_en_FC, rst => IDEX_rst_FC, 
            
            pc_in => PC_ID, pc_out => pc_IDEX,
            instr_in => instr_ID, instr_out => instr_IDEX,
            
            opcode_in => opcode_ID, opcode_out => opcode_EX, 
            out_flag_in => out_flag_ID, out_flag_out => out_flag_EX, 
            
            mem_wr_en_in => mem_wr_en_ID, mem_rd_en_in => mem_rd_en_ID,
            mem_wr_en_out => mem_wr_en_EX, mem_rd_en_out => mem_rd_en_EX,

            wb_en_in =>wb_en_ID, wb_idx_in => wb_idx_ID,
            wb_en_out => wb_en_EX, wb_idx_out => wb_idx_EX,

            alu_mode_in =>  alu_mode_ID,
            alu_mode_out =>  alu_mode_EX,
            
            in1_in => in1_ID, in2_in => in2_ID,
            in1_out => in1_EX, in2_out => in2_EX
        );

    branch : entity work.branch_logic
        port map(
            rst_ex => rst_ex,rst_ld => rst_ld,
            
            stall=>stall_EX,
        
            PC_in => PC_MEM,
            PC_EX => PC_IDEX,
            opcode_in => opcode_EX,
            in1_in => in1_EX, in2_in => in2_EX,
            z_flag_in => z_flag_EX, n_flag_in => n_flag_EX,
            
            PC_out => PC_EX,
            wb_out => PC_wb_EX,
            branched_out => branched_EX
        );

    alu : entity work.alu
        port map(
            in1 => in1_EX, in2 => in2_EX, 
            alu_mode => alu_mode_EX, rst=> alu_rst_FC,
            
            result => alu_result_EX, 
            z_flag => z_flag_EX, n_flag => n_flag_EX
        );

    result_MUX : entity work.mux
        port map(
            en => branched_EX,
            in0 => alu_result_EX,
            in1 => PC_wb_EX,
            output => result_EX
        );
        

    EXMEM_latch : entity work.EXMEM_latches
        port map(
            clk => global_clk, en => EXMEM_en_FC, rst => EXMEM_rst_FC,
            
            PC_in => PC_EX, PC_out => PC_MEM,
            
            PC_tb_in => PC_IDEX, PC_tb_out => PC_EXMEM,
            instr_in => instr_IDEX, instr_out => instr_EXMEM,

            mem_wr_en_in => mem_wr_en_EX, mem_rd_en_in => mem_rd_en_EX,
            mem_wr_en_out => mem_wr_en_MEM, mem_rd_en_out => mem_rd_en_MEM,

            wb_en_in =>wb_en_EX, wb_idx_in => wb_idx_EX,
            wb_en_out => wb_en_MEM, wb_idx_out => wb_idx_MEM,
            
            din_in => in2_EX, din_out => din_MEM,
            result_in => result_EX, result_out => result_MEM
        );
     
     
    mem_sel : entity work.mem_sel
        port map(
            pc => PC_MEM,
            addr => instr_addr_MEM,
            mem_select => instr_select_MEM
        ); 


    ram : entity work.dummy_ram
        port map(
            clk => global_clk,
            
            addra => result_MEM,
            ena => mem_rd_en_MEM,
            douta => dout_MEM,
            
            addrb => instr_addr_MEM,
            enb => '1',
            doutb => ram_dout_MEM,
    
            wea => mem_wr_en_MEM,
            dina => din_MEM
        );
  
  
    rom : entity work.dummy_rom
        port map(
            clk => global_clk,
            
            addr => instr_addr_MEM,
            en => '1',
            dout => rom_dout_MEM
        );      


    instr_MUX : entity work.mux
        port map(
            en => instr_select_MEM,
            in0 => rom_dout_MEM,
            in1 => ram_dout_MEM,
            output => instr_MEM
        );
    
 
    wb_MUX : entity work.mux
        port map(
            en => mem_rd_en_MEM,
            in0 => result_MEM,
            in1 => dout_MEM,
            output => wb_data_MEM
        );


    MEMWB_latch : entity work.MEMWB_latches
        port map(
            clk => global_clk, en => MEMWB_en_FC, rst => MEMWB_rst_FC,

            PC_in => PC_EXMEM, PC_out => PC_MEMWB,
            instr_in => instr_EXMEM, instr_out => instr_MEMWB,

            wb_en_in =>wb_en_MEM, wb_en_out => wb_en_WB, 
            wb_idx_in => wb_idx_MEM, wb_idx_out => wb_idx_WB,
            
            wb_data_in => wb_data_MEM, wb_data_out => wb_data_WB
        );


   controller : entity work.controller
        port map(
            rst_ex => rst_ex,rst_ld => rst_ld,
    
            clk        => global_clk,
            PC         => PC_MEM,
    
            stall      => stall_EX, 
    
            wb_en_ID   => wb_en_ID,
            wb_en_EX   => wb_en_EX,
            wb_en_WB   => wb_en_WB,
            wb_idx_ID  => wb_idx_ID,
            wb_idx_EX  => wb_idx_EX,
            wb_idx_WB  => wb_idx_WB,
            rd_idx1_ID => rd_idx1_ID,
            rd_idx2_ID => rd_idx2_ID,
    
            in1        => in1_EX,
            out_flag   => out_flag_EX,
    
            branched   => branched_EX,
    
            out_port   => out_port_FC,
    
            IFID_en    => IFID_en_FC,
            IDEX_en    => IDEX_en_FC,
            EXMEM_en   => EXMEM_en_FC,
            MEMWB_en   => MEMWB_en_FC,
    
            rg_rst     => rg_rst_FC,
            alu_rst    => alu_rst_FC,
    
            IFID_rst   => IFID_rst_FC,
            IDEX_rst   => IDEX_rst_FC,
            EXMEM_rst  => EXMEM_rst_FC,
            MEMWB_rst  => MEMWB_rst_FC,
            
            pending_wb_debug => pending_wb
        );

    
    console_display : console
        port map(
        --
        -- Stage 1 Fetch
        --
            s1_pc    => PC_MEM,
            s1_inst  => instr_MEM, 
        
        --
        -- Stage 2 Decode
        --
            
            s2_pc    => PC_ID, 
            s2_inst  => instr_ID,   
            
            s2_reg_a => wb_idx_ID,
            s2_reg_b => rd_idx1_ID,
            s2_reg_c => rd_idx2_ID,
            
            s2_reg_a_data => (others => '0'),
            s2_reg_b_data => rd_data1_ID,
            s2_reg_c_data => rd_data2_ID,
            s2_immediate   => imm_val_ID,
        
        --
        -- Stage 3 Execute
        --
            
            s3_pc    => PC_IDEX,
            s3_inst  => instr_IDEX, 
            
            s3_reg_a => alu_mode_EX,
            s3_reg_b => (others => '0'), 
            s3_reg_c => (others => '0'),
            
            s3_reg_a_data => (others => '0'), 
            s3_reg_b_data => in1_EX,     
            s3_reg_c_data => in2_EX,
            s3_immediate  => (others => '0'),
            
            s3_r_wb       => wb_en_EX,
            s3_r_wb_data  => result_EX,
            
            s3_br_wb         => branched_EX,
            s3_br_wb_address => PC_wb_EX,
            
            s3_mr_wr         => mem_wr_en_EX,
            s3_mr_wr_address => result_EX, 
            s3_mr_wr_data    => in2_EX, 
            
            s3_mr_rd         => mem_rd_en_EX,
            s3_mr_rd_address => result_EX, 
    
        
        --
        -- Stage 4 Memory
        --
        
            s4_pc      => PC_EXMEM,  
            s4_inst    => instr_EXMEM,   
            s4_reg_a   => wb_idx_MEM,  
            s4_r_wb    => wb_en_MEM,   
            s4_r_wb_data => wb_data_MEM,
        
        --
        -- CPU registers
        --
        
            register_0 => r0_i,
            register_1 => r1_i,
            register_2 => r2_i,
            register_3 => r3_i,
            register_4 => r4_i,
            register_5 => r5_i,
            register_6 => r6_i,
            register_7 => r7_i,
        
            register_0_of => '0',
            register_1_of => '0',
            register_2_of => '0',
            register_3_of => '0',
            register_4_of => '0',
            register_5_of => '0',
            register_6_of => '0',
            register_7_of => '0',
        
        --
        -- CPU Flags
        --
            zero_flag     => z_flag_EX,
            negative_flag => n_flag_EX,
            overflow_flag => '0',
    
    --
    -- Debug screen enable
    --
            debug => debug_console,
    
    --
    -- Text console display memory access signals ( clk is the processor clock )
    --
    
        clk => global_clk,
        addr_write => x"0000",
        data_in => x"0000",
        en_write => '0',
    
    --
    -- Video related signals
    --
    
    
        board_clock => board_clock,
        h_sync_signal => h_sync_signal,
        v_sync_signal => v_sync_signal,
        vga_red => vga_red,
        vga_green => vga_green,
        vga_blue => vga_blue
    );



out_port <= out_port_FC;




-- TESTBENCH IO
instr_MEM_out <= instr_MEM;

instr_IFID_out <= instr_ID;
instr_IDEX_out <= instr_IDEX;
instr_EXMEM_out <= instr_EXMEM;
instr_MEMWB_out <= instr_MEMWB;

pc_MEM_out <= PC_MEM;
pc_EX_out <= PC_EX;
pc_IFID_out <= PC_ID;
pc_IDEX_out <= PC_IDEX;
pc_EXMEM_out <= PC_EXMEM;
pc_MEMWB_out <= PC_MEMWB;

n_flag <= n_flag_EX;
z_flag <= z_flag_EX;

opcode <= opcode_EX;

rd_idx1 <= rd_idx1_ID;
rd_idx2  <= rd_idx2_ID;

stall <= stall_EX;

-- ALU Inputs
in1 <= in1_EX;
in2  <= in2_EX;
alu_mode <= alu_mode_EX; 

branched <= branched_EX;

-- Write-Back Stage Outputs
wb_en <= wb_en_WB;
wb_data <= wb_data_WB;
wb_idx <= wb_idx_WB;

r0 <= r0_i;
r1 <= r1_i;
r2 <= r2_i;
r3 <= r3_i;
r4 <= r4_i;
r5 <= r5_i;
r6 <= r6_i;
r7 <= r7_i;

pending_wb_debug <= pending_wb;

end architecture brent; -- NOOOOOOOO
