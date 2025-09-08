----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2025 10:14:01 AM
-- Design Name: 
-- Module Name: instr_decoder - Behavioral
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


-- DESCRIPTION
-- Takes an instruction from the fetch register (+ CLK_in and EN)
-- Outputs an ALU mode code (3 bits), 3 3-bit register addresses


entity instr_decoder is
port (
    -- INPUTS
	instr : in STD_LOGIC_VECTOR(15 downto 0);
    in_port : in STD_LOGIC_VECTOR(15 downto 0);
    stall : in STD_LOGIC;
    
    -- OUTPUTS
    out_flag : out STD_LOGIC;
    
    rd_idx1 : out STD_LOGIC_VECTOR(2 downto 0);
    rd_idx2 : out STD_LOGIC_VECTOR(2 downto 0);
    
    imm_val : out STD_LOGIC_VECTOR(15 downto 0);
    imm_en : out STD_LOGIC;
    
    opcode : out STD_LOGIC_VECTOR(6 downto 0);
    alu_mode : out STD_LOGIC_VECTOR(2 downto 0);

    mem_wr_en : out STD_LOGIC;
    mem_rd_en : out STD_LOGIC;
    
    wb_en : out STD_LOGIC;
    wb_idx : out STD_LOGIC_VECTOR(2 downto 0);
    mask : out STD_LOGIC_VECTOR(15 downto 0)
    
    

);
end instr_decoder;

architecture Behavioral of instr_decoder is
begin
    
    process(instr, in_port) begin    
        
--        if stall = '1' then
--            opcode <= (others => '0');
--            alu_mode <= (others => '0');                    
            
--            out_flag <= '0';
            
--            wb_en <= '0';
--            wb_idx <= (others => '0');
            
--            rd_idx1 <= (others => '0');
--            rd_idx2 <= (others => '0');
            
--            imm_val <= (others => '0');
--            imm_en <= '1';
            
--            mem_wr_en <= '0';
--            mem_rd_en <= '0';
            
--            mask <= x"0000";
            
--        else        
            case to_integer(unsigned(instr(15 downto 9))) is
            
                when 0 =>
                    -- A0 
                    opcode <= instr(15 downto 9);
                    alu_mode <= (others => '0');                    
                    
                    out_flag <= '0';
                    
                    wb_en <= '0';
                    wb_idx <= (others => '0');
                    
                    rd_idx1 <= (others => '0');
                    rd_idx2 <= (others => '0');
                    
                    imm_val <= (others => '0');
                    imm_en <= '0';
                    
                    mem_wr_en <= '0';
                    mem_rd_en <= '0';
                    
                    mask <= x"FFFF";
                    
                when 1 | 2 | 3 =>
                    -- A1
                    opcode <= instr(15 downto 9);
                    alu_mode <= instr(11 downto 9);                    
                    
                    out_flag <= '0';
                    
                    wb_en <= '1';
                    wb_idx <= instr(8 downto 6);
                    
                    rd_idx1 <= instr(5 downto 3);
                    rd_idx2 <= instr(2 downto 0);
                    
                    imm_val <= (others => '0');
                    imm_en <= '0';
                    
                    mem_wr_en <= '0';
                    mem_rd_en <= '0';
                    
                    mask <= x"FFFF";
                    
                when 4 =>
                    -- A1 (NAND CASE)   
                    opcode <= instr(15 downto 9);
                    alu_mode <= instr(11 downto 9);                    
                    
                    out_flag <= '0';
                    
                    wb_en <= '1';
                    wb_idx <= instr(8 downto 6);
                    
                    rd_idx1 <= instr(8 downto 6);
                    rd_idx2 <= instr(5 downto 3);
                    
                    imm_val <= (others => '0');
                    imm_en <= '0';
                    
                    mem_wr_en <= '0';
                    mem_rd_en <= '0';              
                    
                    mask <= x"FFFF";
                when 5 | 6 =>
                    -- A2
                    opcode <= instr(15 downto 9);
                    alu_mode <= instr(11 downto 9);                    
                    
                    out_flag <= '0';
                    
                    wb_en <= '1';
                    wb_idx <= instr(8 downto 6);
                    
                    rd_idx1 <= instr(8 downto 6);
                    rd_idx2 <= (others => '0');
                    
--                    imm_val(3 downto 0) <= instr(3 downto 0);
--                    imm_val(15 downto 4) <= (others => instr(3));
                    imm_val <= std_logic_vector(resize(signed(instr(3 downto 0)), 16));
                    imm_en <= '1';
                    
                    mem_wr_en <= '0';
                    mem_rd_en <= '0';     
                    
                    mask <= x"FFFF";
                    
                when 7 => 
                    --TEST
                    opcode <= instr(15 downto 9);
                    alu_mode <= instr(11 downto 9);                    
                    
                    out_flag <= '0';
                    
                    wb_en <= '0';
                    wb_idx <= (others => '0');
                    
                    rd_idx1 <= instr(8 downto 6);
                    rd_idx2 <= (others => '0');
                    
                    imm_val <= (others => '0');
                    imm_en <= '0';
                    
                    mem_wr_en <= '0';
                    mem_rd_en <= '0';   
                    
                    mask <= x"FFFF";   
                
                when 64 | 65 | 66 =>
                    -- B1
                    opcode <= instr(15 downto 9);
                    alu_mode <= (others => '0');                    
                    
                    out_flag <= '0';
                    
                    wb_en <= '0';
                    wb_idx <= (others => '0');
                    
                    rd_idx1 <= (others => '0');
                    rd_idx2 <= (others => '0');
                    
--                    imm_val(8 downto 0) <= instr(8 downto 0);
--                    imm_val(15 downto 9) <= (others => instr(8));
                    imm_val <= std_logic_vector(resize(signed(instr(8 downto 0)), 16));
                    imm_en <= '1';
                    
                    mem_wr_en <= '0';
                    mem_rd_en <= '0';   
                    
                    mask <= x"FFFF";   
                
                when 67 | 68 | 69 =>
                    -- B2
                    opcode <= instr(15 downto 9);
                    alu_mode <= (others => '0');                    
                    
                    out_flag <= '0';
                    
                    wb_en <= '0';
                    wb_idx <= (others => '0');
                    
                    rd_idx1 <= instr(8 downto 6);
                    rd_idx2 <= (others => '0');
                                        
--                    imm_val(5 downto 0) <= instr(5 downto 0);
--                    imm_val(15 downto 6) <= (others => instr(5));
                    imm_val <= std_logic_vector(resize(signed(instr(5 downto 0)), 16));
                    imm_en <= '1';
                    
                    mem_wr_en <= '0';
                    mem_rd_en <= '0';      
                
                    mask <= x"FFFF";
                when 70 =>
                    -- BR.SUB
                    opcode <= instr(15 downto 9);
                    alu_mode <= (others => '0');                    
                    
                    out_flag <= '0';
                    
                    wb_en <= '1';
                    wb_idx <= "111";
                    
                    rd_idx1 <= instr(8 downto 6);
                    rd_idx2 <= (others => '0');
                                        
--                    imm_val(5 downto 0) <= instr(5 downto 0);
--                    imm_val(15 downto 6) <= (others => instr(5));
                    imm_val <= std_logic_vector(resize(signed(instr(5 downto 0)), 16));
                    imm_en <= '1';
                    
                    mem_wr_en <= '0';
                    mem_rd_en <= '0'; 
                    
                    mask <= x"FFFF";     
                    
                when 71 =>
                    -- RETURN
                    opcode <= instr(15 downto 9);
                    alu_mode <= (others => '0');                    
                    
                    out_flag <= '0';
                    
                    wb_en <= '0';
                    wb_idx <= (others => '0');
                    
                    rd_idx1 <= "111";
                    rd_idx2 <= (others => '0');
                    
                    imm_val <= (others => '0');
                    imm_en <= '0';
                    
                    mem_wr_en <= '0';
                    mem_rd_en <= '0';
                    
                    mask <= x"FFFF";                   
                                       
               when 16 => 
               -- LOAD
                    opcode <= instr(15 downto 9);
                    alu_mode <= (others => '0');                    
                    
                    out_flag <= '0';
                    
                    wb_en <= '1';
                    wb_idx <= instr(8 downto 6);
                    
                    rd_idx1 <= instr(5 downto 3);
                    rd_idx2 <= (others => '0');
                    
                    imm_val <= (others => '0');
                    imm_en <= '0';
                    
                    mem_wr_en <= '0';
                    mem_rd_en <= '1';
                    
                    mask <= x"FFFF";
    
               when 17 => 
               -- STORE
                    opcode <= instr(15 downto 9);
                    alu_mode <= (others => '0');                    
                    
                    out_flag <= '0';
                    
                    wb_en <= '0';
                    wb_idx <= (others => '0');
                    
                    rd_idx1 <= instr(8 downto 6);
                    rd_idx2 <= instr(5 downto 3);
                    
                    imm_val <= (others => '0');
                    imm_en <= '0';
                    
                    mem_wr_en <= '1';
                    mem_rd_en <= '0';
                    
                    mask <= x"03FF";
                    
                    
               when 18 =>
               --LOADIMM
                   opcode <= instr(15 downto 9);
                   alu_mode <= "001"; -- Need to add the masked r7 to the immediate value                    
                   
                   out_flag <= '0';
                   
                   wb_en <= '1'; -- Need to write back to register r7
                   wb_idx <= "111";
                   
                   rd_idx1 <= "111"; 
                   rd_idx2 <= (others => '0'); 
                                  
                   imm_en <= '1';
                   
                   mem_wr_en <= '0';
                   mem_rd_en <= '0'; 
                   
                   
                   -- Modulating imm val and mask based on changing upper or lower bits of r7
    
                   imm_val <= (others => '0');
                   if (instr(8) = '1') then
                   
                        mask <= x"00FF";
                        imm_val(15 downto 8) <= instr(7 downto 0);
                        
                   elsif (instr(8) = '0') then
                   
                        mask <= x"FF00";
                        imm_val(7 downto 0) <= instr(7 downto 0);
                   end if;
                   
    
    
                    
                   
               when 19 => 
                         opcode <= instr(15 downto 9);
                         alu_mode <= (others => '0');                    
                         
                         out_flag <= '0';
                         
                         wb_en <= '1';
                         wb_idx <= instr(8 downto 6);
                         
                         rd_idx1 <= instr(5 downto 3);
                         rd_idx2 <= (others => '0');
                         
                         imm_val <= (others => '0');
                         imm_en <= '0';
                         
                         mem_wr_en <= '0';
                         mem_rd_en <= '0';
                         
                        mask <= x"FFFF";                                   
    
               when 32 => 
    --           OUT PORT
                        opcode <= (others => '0');
                        alu_mode <= (others => '0');
                        
                        out_flag <= '1';
                        
                        wb_en <= '0';
                        wb_idx <= (others => '0');
                        
                        rd_idx1 <= instr(8 downto 6);
                        rd_idx2 <= (others => '0');
                        
                        imm_val <= (others => '0');
                        imm_en <= '0';
                        
                        mem_wr_en <= '0';
                        mem_rd_en <= '0';
                        
                        mask <= x"FFFF";        
    
               when 33 => 
    --           IN PORT
                        opcode <= (others => '0');
                        alu_mode <= "001";                    
                       
                        out_flag <= '0';
                        
                        wb_en <= '1';
                        wb_idx <= instr(8 downto 6);
                        
                        rd_idx1 <= (others => '0');
                        rd_idx2 <= (others => '0');
                        
                        imm_val <= in_port;
                        imm_en <= '1';
                        
                        mem_wr_en <= '0';
                        mem_rd_en <= '0';
                        
                        mask <= x"0000";        
    
                when others =>
                    null;
            end case;
--        end if;
    end process;

end Behavioral;
