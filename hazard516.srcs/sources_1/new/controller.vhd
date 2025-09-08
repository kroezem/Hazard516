----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2025 12:12:42 PM
-- Design Name: 
-- Module Name: controller - Behavioral
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

entity controller is
    port (
    -- ## INPUTS
        -- ## GLOBAL
            clk,rst_ld,rst_ex : in std_logic;
            PC : in std_logic_vector(15 downto 0);

        -- ## REGISTER MONITORING
            wb_en_ID,wb_en_EX,wb_en_WB : in std_logic;
            wb_idx_ID,wb_idx_EX,wb_idx_WB : in std_logic_vector(2 downto 0);
            rd_idx1_ID,rd_idx2_ID : in std_logic_vector(2 downto 0);
        
        -- ## OUT_PORT MONITORING
            in1 : in std_logic_vector(15 downto 0);
            out_flag : in std_logic;
        
        -- ## BRANCH MONITORING
            branched : in std_logic;

        
    -- ## OUTPUTS
        -- ## CPU OUT_PORT
            out_port : out std_logic_vector(15 downto 0);
          
        -- ## ENABLES
            IFID_en,IDEX_en,EXMEM_en,MEMWB_en,stall : out std_logic;      
            
        -- ## RESETS
            rg_rst,alu_rst : out std_logic;
            IFID_rst,IDEX_rst,EXMEM_rst,MEMWB_rst : out std_logic;
            
            
    -- ## DEBUGGING
        pending_wb_debug : out std_logic_vector(7 downto 0)
     );
     
     
end controller;

 architecture Behavioral of controller is

signal out_port_i : std_logic_vector(15 downto 0) := (others => '0');

signal IFID_en_i : std_logic := '1';
signal IDEX_en_i : std_logic := '1';
signal EXMEM_en_i : std_logic := '1';
signal MEMWB_en_i : std_logic := '1';

signal IFID_rst_i : std_logic := '0';
signal IDEX_rst_i : std_logic := '0';
signal EXMEM_rst_i : std_logic := '0';
signal MEMWB_rst_i : std_logic := '0';
signal rg_rst_i : std_logic := '0';
signal alu_rst_i : std_logic := '0';

signal stall_i : std_logic := '0';

signal pending_wb : std_logic_vector(7 downto 0) := (others => '0');


begin
    process(clk) begin
        
        if out_flag = '1' then
            out_port_i <= in1;
        end if;
        
        
        if not rising_edge(clk) then 
        
            stall_i <= '0';
            IFID_en_i <= '1';
            IDEX_en_i <= '1';
            
            IFID_rst_i <= '0';
            IDEX_rst_i <= '0';
            
            
            -- CLEAR BUSY FLAG ON INCOMING WB
            if wb_en_WB = '1' then
               pending_wb(to_integer(unsigned(wb_idx_WB))) <= '0';
            end if;
            
            -- SET PENDING IF INSTR MADE IT TO EX
            if wb_en_EX = '1' then
               pending_wb(to_integer(unsigned(wb_idx_EX))) <= '1';
               

               if wb_idx_EX = rd_idx1_ID or wb_idx_EX = rd_idx2_ID then
                   stall_i <= '1';
                   IFID_en_i <= '0';
                   IDEX_rst_i <= '1';
               end if;   
               
            end if;        

        
            if branched = '1' then
                IFID_rst_i <= '1';
                IDEX_rst_i <= '1';
                
            elsif pending_wb(to_integer(unsigned(rd_idx1_ID))) = '1' or
            pending_wb(to_integer(unsigned(rd_idx2_ID))) = '1' then
                
                stall_i <= '1';
                IFID_en_i <= '0';
                IDEX_rst_i <= '1';
            
            end if;
        end if;
    end process;
    
    out_port  <= out_port_i;
    
    stall <= stall_i;
    
    IFID_en   <= IFID_en_i;
    IDEX_en   <= IDEX_en_i;
    EXMEM_en  <= EXMEM_en_i;
    MEMWB_en  <= MEMWB_en_i;
    
    IFID_rst  <= IFID_rst_i;
    IDEX_rst  <= IDEX_rst_i;
    EXMEM_rst <= EXMEM_rst_i;
    MEMWB_rst <= MEMWB_rst_i;
    
    rg_rst    <= rg_rst_i;
    alu_rst   <= alu_rst_i;
    
    pending_wb_debug <= pending_wb;
end Behavioral;
