----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/10/2025 03:01:21 PM
-- Design Name: 
-- Module Name: ram - Behavioral
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library xpm;
use xpm.vcomponents.all;

entity ram is
    port (
        clk   : in std_logic;
        
        addra,addrb  : in std_logic_vector(15 downto 0);

        ena,enb,wea    : in std_logic;
        dina   : in std_logic_vector(15 downto 0); 
        
        douta  : out std_logic_vector(15 downto 0);
        doutb  : out std_logic_vector(15 downto 0)
    );
    
    
end entity ram;

architecture behavioral of ram is

signal wea_vec : std_logic_vector(1 downto 0);

begin

    ram_inst : xpm_memory_dpdistram
    generic map (
        ADDR_WIDTH_A => 16,  -- 512 words (2^9)
        ADDR_WIDTH_B => 16,  -- Same address width for Port B
        BYTE_WRITE_WIDTH_A => 16,  -- 16-bit words
        WRITE_DATA_WIDTH_A => 16,
        READ_DATA_WIDTH_A  => 16,  -- 16-bit output
        READ_DATA_WIDTH_B  => 16,  -- 16-bit output
        MEMORY_SIZE => 2048,
        CLOCKING_MODE => "common_clock"
    )
    
    port map (
        clka  => clk, clkb  => clk,
        regcea => '1',regceb => '1',
        rsta => '0',rstb => '0',
        
        ena => ena,
        enb   => enb,
        wea   => wea_vec,
        
        addra => addra,
        addrb => addrb,
        
        dina  => dina,
        
        douta => douta,
        doutb => doutb
    );
    
    wea_vec := (others => wea);
end architecture behavioral;
