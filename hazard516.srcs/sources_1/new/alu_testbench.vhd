----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/10/2025 05:02:04 PM
-- Design Name: 
-- Module Name: alu_testbench - Behavioral
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

entity alu_testbench is
-- Don't need anything here for a testbench
end alu_testbench;

architecture Behavioral of alu_testbench is
component alu
port (
	in1,in2 : in STD_LOGIC_VECTOR(15 downto 0);
	alu_mode : in STD_LOGIC_VECTOR(2 downto 0);
	clk : in STD_LOGIC;
    rst : in STD_LOGIC;
    
	result   : out STD_LOGIC_VECTOR(15 downto 0);
	z_flag   : out STD_LOGIC;
	n_flag   : out STD_LOGIC
	);

end component;
signal rst, clk, z_flag, n_flag : STD_LOGIC;
signal in1,in2, result : STD_LOGIC_VECTOR(15 downto 0);
signal alu_mode : STD_LOGIC_VECTOR(2 downto 0);

begin

-- alu0: entity work.alu(behavioral) port map(
-- in1 => in1,
-- in2 => in2,
-- alu_mode => alu_mode,
-- clk => clk,
-- rst => rst,
-- result => result,
-- z_flag => z_flag,
-- n_flag => n_flag
-- );

DUT: alu port map(in1,in2 ,alu_mode,clk,rst,result,z_flag,n_flag);



process begin
    rst <= '0';
    clk <= '0';
    
    
	-- Test ADD
    alu_mode <= "001";
    in1 <= "0000000000000101";
    in2 <= "0000000000000010";
    
    clk <= '1';
    wait for 10 ns;
    clk <= '0';
    wait for 10 ns;
    -- Test SUB
    alu_mode <= "010";
    in1 <= "0000000000000101";
    in2 <= "0000000000000010";
    
    clk <= '1';
    wait for 10 ns;
    clk <= '0';
    wait for 10 ns;

-- Test MULT
    alu_mode <= "011";
    in1 <= "0000000000000101";
    in2 <= "0000000000000010";
        
    clk <= '1';
    wait for 10 ns;
    clk <= '0';
    wait for 10 ns;
    
    -- Test NAND

    alu_mode <= "100";

    in1 <= "0000000000000100";
    in2 <= "0000000000001000";
    
    
    clk <= '1';
    wait for 10 ns;
    clk <= '0';
    wait for 10 ns;
    
    --Test Shift Left
    
    alu_mode <= "101";
    in1 <= "0000000000000001";
    in2 <= "0000000000000011";
    
    clk <= '1';
    wait for 10 ns;
    clk <= '0';
    wait for 10 ns;
    
    
    -- Test Shift Right
    alu_mode <= "110";
    in1 <= "0000000000000001";
    in2 <= "0000000000000011";    
    
    clk <= '1';
    wait for 10 ns;
    clk <= '0';
    wait for 10 ns;
    
    -- Test TEST

    alu_mode <= "111";
    in1 <= "0000000000000001";
    in2 <= "0000000000000010";    
    
    clk <= '1';
    wait for 10 ns;
    clk <= '0';
    wait for 10 ns;
    
    
-- Test SUB
-- Test MUL
-- Test NAND
-- Test SHL
-- Test SHR
-- Test TEST
	wait;
end process;


end Behavioral;
