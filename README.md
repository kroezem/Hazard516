# Hazard516 — 16-bit pipelined CPU (HPU)

A 5-stage, MIPS-style 16-bit CPU in VHDL. Focus is on clean hazard handling and a simple BIOS flow to load a program over I/O.

Read Full Report [HERE](https://docs.google.com/document/d/1JHfcCbQ5ML1nyT0WS9xGxy7pL-Q2V41Iti1adD3cf58/edit?usp=sharing)

---

## TL;DR

- 5 stages: IF, ID, EX, MEM, WB
- ISA formats: A (ALU), B (branches), L (memory + immediates)
- Hazard controller: RAW stalls with a pending-writeback bitmap, single bubble insert, flush on taken branch
- Memory: ROM for BIOS (0x0000–0x03FF), RAM for program/data (0x0400–0x07FF)
- I/O: `IN` and `OUT` ports, STM32 companion used to load RAM via BIOS

Status:
- Bootloader works on hardware and exercises I/O.
- Executing programs from RAM exposes a known address translation bug on LOAD/STORE.

---

## What this is

A compact RISC-style core that runs the course ISA and demonstrates:
- Correct pipeline latching and control
- RAW hazard detection without programmer-inserted NOPs
- Simple branch handling with pipeline flush on taken branches
- Minimal BIOS that loads a user program from an external board, then jumps to RAM

Not included:
- Stack instructions (push/pop)
- Branch prediction
- Timing closure numbers

---

## Architecture

Pipeline latches: `IFID`, `IDEX`, `EXMEM`, `MEMWB` (sync reset + enable).

- IF: PC drives ROM and RAM through `mem_sel`. Asynchronous read. Output and PC latched to `IFID`.
- ID: Decode opcode and format. Read regfile. Immediate mux. `IN` sources `in_port`. `OUT` flagged for EX.
- EX: ALU ops and flagging (Z, N). For memory ops, ALU just forwards address. Branch Logic computes next PC:
  - Relative: `PC_next = PC_IDEX + 2 * imm`
  - Absolute: `PC_next = RA + 2 * imm`
  - `BR.SUB` writes return PC to r7. `RETURN` jumps via r7.
- MEM: `mem_rd_en` selects RAM read data into WB path. `mem_wr_en` writes `din_MEM` to RAM at `result_MEM`.
- WB: On falling edge, regfile writes `wb_data_WB` to `wb_idx_WB` when `wb_en_WB` is set.

Hazard control:
- `pending_wb[7:0]` tracks in-flight writes. Set when an instruction passes `IDEX` with `wb_en_EX`. Clear on writeback.
- If ID wants a source reg with `pending_wb` set, assert stall, hold `IFID`, inject one bubble by resetting `IDEX`.
- On taken branch, flush `IFID` and `IDEX`.

Memory map:
```

0x0000 - 0x03FF  ROM  (BIOS)
0x0400 - 0x07FF  RAM  (program + data)

````

```
