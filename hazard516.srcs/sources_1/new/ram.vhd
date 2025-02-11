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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

Library xpm;
use xpm.vcomponents.all;



entity ram is
port (
    douta : out STD_LOGIC_VECTOR(3 downto 0);
    doutb : out STD_LOGIC_VECTOR(3 downto 0);
    addra : in STD_LOGIC_VECTOR(3 downto 0);
    addrb : in STD_LOGIC_VECTOR(3 downto 0);
    clka : in STD_LOGIC;
    clkb : in STD_LOGIC;
    dina : in STD_LOGIC_VECTOR(3 downto 0);
    ena : in STD_LOGIC;
    enb : in STD_LOGIC;
    regcea : in STD_LOGIC;
    regceb : in STD_LOGIC;
    rsta : in STD_LOGIC;
    rstb : in STD_LOGIC;
    wea : in STD_LOGIC_VECTOR(3 downto 0)
   
);

end ram;


architecture Behavioral of ram is    

-- xpm_memory_dpdistram: Dual Port Distributed RAM
-- Xilinx Parameterized Macro, version 2024.2

xpm_memory_dpdistram_inst : xpm_memory_dpdistram
generic map (
   ADDR_WIDTH_A => 6,               -- DECIMAL
   ADDR_WIDTH_B => 6,               -- DECIMAL
   BYTE_WRITE_WIDTH_A => 32,        -- DECIMAL
   CLOCKING_MODE => "common_clock", -- String
   IGNORE_INIT_SYNTH => 0,          -- DECIMAL
   MEMORY_INIT_FILE => "none",      -- String
   MEMORY_INIT_PARAM => "0",        -- String
   MEMORY_OPTIMIZATION => "true",   -- String
   MEMORY_SIZE => 2048,             -- DECIMAL
   MESSAGE_CONTROL => 0,            -- DECIMAL
   READ_DATA_WIDTH_A => 32,         -- DECIMAL
   READ_DATA_WIDTH_B => 32,         -- DECIMAL
   READ_LATENCY_A => 2,             -- DECIMAL
   READ_LATENCY_B => 2,             -- DECIMAL
   READ_RESET_VALUE_A => "0",       -- String
   READ_RESET_VALUE_B => "0",       -- String
   RST_MODE_A => "SYNC",            -- String
   RST_MODE_B => "SYNC",            -- String
   SIM_ASSERT_CHK => 0,             -- DECIMAL; 0=disable simulation messages, 1=enable simulation messages
   USE_EMBEDDED_CONSTRAINT => 0,    -- DECIMAL
   USE_MEM_INIT => 1,               -- DECIMAL
   USE_MEM_INIT_MMI => 0,           -- DECIMAL
   WRITE_DATA_WIDTH_A => 32         -- DECIMAL
)
port map (
   douta => douta,   -- READ_DATA_WIDTH_A-bit output: Data output for port A read operations.
   doutb => doutb,   -- READ_DATA_WIDTH_B-bit output: Data output for port B read operations.
   addra => addra,   -- ADDR_WIDTH_A-bit input: Address for port A write and read operations.
   addrb => addrb,   -- ADDR_WIDTH_B-bit input: Address for port B write and read operations.
   clk => clka,     -- 1-bit input: Clock signal for port A. Also clocks port B when parameter
                     -- CLOCKING_MODE is "common_clock".

   clk => clkb,     -- 1-bit input: Clock signal for port B when parameter CLOCKING_MODE is
                     -- "independent_clock". Unused when parameter CLOCKING_MODE is "common_clock".

   dina => dina,     -- WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
   ena => ena,       -- 1-bit input: Memory enable signal for port A. Must be high on clock cycles when read
                     -- or write operations are initiated. Pipelined internally.

   enb => enb,       -- 1-bit input: Memory enable signal for port B. Must be high on clock cycles when read
                     -- or write operations are initiated. Pipelined internally.

   regcea => regcea, -- 1-bit input: Clock Enable for the last register stage on the output data path.
   regceb => regceb, -- 1-bit input: Do not change from the provided value.
   rsta => rsta,     -- 1-bit input: Reset signal for the final port A output register stage. Synchronously
                     -- resets output port douta to the value specified by parameter READ_RESET_VALUE_A.

   rstb => rstb,     -- 1-bit input: Reset signal for the final port B output register stage. Synchronously
                     -- resets output port doutb to the value specified by parameter READ_RESET_VALUE_B.

   wea => wea        -- WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A-bit input: Write enable vector for port A
                     -- input data port dina. 1 bit wide when word-wide writes are used. In byte-wide write
                     -- configurations, each bit controls the writing one byte of dina to address addra. For
                     -- example, to synchronously write only bits [15-8] of dina when WRITE_DATA_WIDTH_A is
                     -- 32, wea would be 4'b0010.

);


begin

--    addra(5 downto 4) <= "00";


-- End of xpm_memory_dpdistram_inst instantiation
end Behavioral;
