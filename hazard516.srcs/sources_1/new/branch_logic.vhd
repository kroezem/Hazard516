----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/14/2025 11:21:44 AM
-- Design Name: 
-- Module Name: branch_logic - Behavioral
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

entity branch_logic is
    Port ( 
        rst_ex,rst_ld,stall : in STD_LOGIC;
        
        PC_in,PC_EX,in1_in,in2_in : in STD_LOGIC_VECTOR(15 downto 0);
        opcode_in : in STD_LOGIC_VECTOR(6 downto 0);
        
        n_flag_in,z_flag_in : in STD_LOGIC;
        
        PC_out,wb_out : out STD_LOGIC_VECTOR(15 downto 0);
        branched_out : out STD_LOGIC
    );
end branch_logic;

architecture Behavioral of branch_logic is

signal PC : std_logic_vector(15 downto 0) := (others => '0');
signal branched : std_logic := '0';
signal prev_stall : std_logic := '0';

begin

    
    process(PC_in,PC_EX,in1_in,in2_in,opcode_in,n_flag_in,z_flag_in,rst_ld,rst_ex,stall) 
    begin
        
        if rst_ex = '1' then
            PC <= x"0000";
            branched <= '1';
            
        elsif rst_ld = '1' then
            PC <= x"0002";
            branched <= '1';
            
            
            elsif stall = '1' then
    
                PC <= PC_in;
                branched <= '0';
                            
        else
            case to_integer(unsigned(opcode_in)) is      
                 
                when 64 =>
                    -- BRR
                    
                        PC <= std_logic_vector(signed(PC_EX) + shift_left(resize(signed(in2_in(14 downto 0)), 16), 1));
                        branched <= '1';
    
                when 65 =>
                    -- BRR.N
                    if n_flag_in = '1' then
                        PC <= std_logic_vector(signed(PC_EX) + shift_left(resize(signed(in2_in(14 downto 0)), 16), 1));
                        branched <= '1';
                    else
                        PC <= STD_LOGIC_VECTOR(signed(PC_in) + 2);
                        branched <= '0';
                    end if;
    
                when 66 =>
                    -- BRR.Z
                    if z_flag_in = '1' then
                        PC <= std_logic_vector(signed(PC_EX) + shift_left(resize(signed(in2_in(14 downto 0)), 16), 1));
                        branched <= '1';
                    else
                        PC <= STD_LOGIC_VECTOR(signed(PC_in) + 2);
                        branched <= '0';
                    end if; 
            
                when 67 =>
                    -- BR
                        PC <= STD_LOGIC_VECTOR(signed(in1_in) + shift_left(resize(signed(in2_in(14 downto 0)), 16), 1));
                    branched <= '1';
                        
                when 68 =>
                    -- BR.N
                    if n_flag_in = '1' then
                        PC <= STD_LOGIC_VECTOR(signed(in1_in) + shift_left(resize(signed(in2_in(14 downto 0)), 16), 1));
                        branched <= '1';
                    else
                        PC <= STD_LOGIC_VECTOR(signed(PC_in) + 2);
                        branched <= '0';
                    end if;    
                when 69 =>
                    -- BR.Z
                    if z_flag_in = '1' then
                        PC <= STD_LOGIC_VECTOR(signed(in1_in) + shift_left(resize(signed(in2_in(14 downto 0)), 16), 1));
                        branched <= '1';
                    else
                        PC <= STD_LOGIC_VECTOR(signed(PC_in) + 2);
                        branched <= '0';
                    end if;    
                    
                when 70 =>
                    -- BR.SUB (WB needs to be enabled from controller)
                    PC <= STD_LOGIC_VECTOR(signed(in1_in) + shift_left(resize(signed(in2_in(14 downto 0)), 16), 1));
                    branched <= '1';
    
                when 71 =>
                    -- RETURN
                    PC <= STD_LOGIC_VECTOR(signed(in1_in));
                    branched <= '1';
    
                when others =>
                    -- NO BRANCH OP
                    PC <= STD_LOGIC_VECTOR(signed(PC_in) + 2);
                    branched <= '0';        
                end case;
            end if;
    end process;
    
    PC_out <= PC;
    branched_out <= branched;
    wb_out <= STD_LOGIC_VECTOR(signed(PC_EX) + 2);

end Behavioral;
