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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


-- DESCRIPTION
-- Takes an instruction from the fetch register (+ CLK_in and EN)
-- Outputs an ALU mode code (3 bits), 3 3-bit register addresses







entity instr_decoder_old is
port (
    -- INPUTS
	instr : in STD_LOGIC_VECTOR(15 downto 0);
	clk : in STD_LOGIC;
    en : in STD_LOGIC;
    
    op_code : out STD_LOGIC_VECTOR(6 downto 0);

    -- A FORMAT OUTPUTS
    ra,rb,rc : out STD_LOGIC_VECTOR(2 downto 0);
    c1 : out STD_LOGIC_VECTOR(3 downto 0);
    
    -- B FORMAT OUTPUTS
    displ : out STD_LOGIC_VECTOR(8 downto 0);
    disps : out STD_LOGIC_VECTOR(5 downto 0)
    
	);
end instr_decoder_old;

architecture Behavioral of instr_decoder_old is

begin
process(clk)


if (rising_edge(clk) and en = '1') then
    
    op_code <= instr(15 downto 9)

    ra <= (others => '0')
    rb <= (others => '0')
    rc <= (others => '0')

    c1 <= (others => '0')
    displ <= (others => '0')
    disps <= (others => '0')
    
    
    -- CHANGE IF STATEMENTS TO FORMAT FUNCTIONS IN THE FUTURE?
    
    -- ********** A FORMAT **********
    
    if (to_integer(op_code) = 0) then
        -- NO OP
    
    elsif (to_integer(op_code) = 1) then
        -- ADD
        ra <= instr(8 downto 6)
        rb <= instr(5 downto 3)
        rc <= instr(2 downto 0)
    
    elsif (to_integer(op_code) = 2) then
        -- SUB
        ra <= instr(8 downto 6)
        rb <= instr(5 downto 3)
        rc <= instr(2 downto 0)
              
    elsif (to_integer(op_code) = 3) then
        -- MULT
        ra <= instr(8 downto 6)
        rb <= instr(5 downto 3)
        rc <= instr(2 downto 0)
               
    elsif (to_integer(op_code) = 4) then
        -- NAND
        ra <= instr(8 downto 6)
        rb <= instr(5 downto 3)
        rc <= instr(2 downto 0)
    
    elsif (to_integer(op_code) = 5) then
        -- SHIFT LEFT
        ra <= instr(8 downto 6)
        c1 <= instr(3 downto 0)
    
    elsif (to_integer(op_code) = 6) then
        -- SHIFT RIGHT
        ra <= instr(8 downto 6)
        c1 <= instr(3 downto 0)
    
    elsif (to_integer(op_code) = 7) then
        -- SHIFT RIGHT
        ra <= instr(8 downto 6)
    
    elsif (to_integer(op_code) = 32) then 
        -- OUT
        ra <= instr(8 downto 6)
        c1 <= instr(3 downto 0)
    
    elsif (to_integer(op_code) = 33) then
        -- IN
        ra <= instr(8 downto 6)
        c1 <= instr(3 downto 0)

    --********** B FORMAT **********
    
    elsif (to_integer(op_code) = 64) then
        -- BRANCH RELATIVE UNCONDITIONAL
        displ = instr(8 downto 0)
        
    elsif (to_integer(op_code) = 65) then
        -- BRANCH RELATIVE IF NEGATIVE
        displ = instr(8 downto 0)
        
    elsif (to_integer(op_code) = 66) then
        -- BRANCH RELATIVE IF ZERO
        displ = instr(8 downto 0)
        
    elsif (to_integer(op_code) = 67) then
        -- BRANCH
        ra <= instr(8 downto 6)
        disps = instr(5 downto 0)
        
    elsif (to_integer(op_code) = 68) then
        -- BRANCH IF NEGATIVE
        ra <= instr(8 downto 6)
        disps = instr(5 downto 0)     
                   
    elsif (to_integer(op_code) = 69) then
        -- BRANCH IF ZERO
        ra <= instr(8 downto 6)
        disps = instr(5 downto 0)     
                           
    elsif (to_integer(op_code) = 70) then
        -- BRANCH SUBROUTINE
        ra <= instr(8 downto 6)
        disps = instr(5 downto 0)         
                               
    elsif (to_integer(op_code) = 71) then
        -- RETURN
    
    --********** IMPLEMENT L FORMAT **********

    else
    end if
else
-- DO NOTHING
end if

end process;

end Behavioral;
