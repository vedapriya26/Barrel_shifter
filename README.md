# Parameterized Barrel Shifter in Verilog

A parameterized Verilog RTL design of an **N-bit Barrel Shifter** supporting logical left/right shifts and rotate left/right operations. The project includes a **self-checking testbench** that calculates expected outputs and compares them with the actual DUT output to report PASS/FAIL results.

### Features
- Parameterized data width
- Logical Left Shift (LSL)
- Logical Right Shift (LSR)
- Rotate Left (ROL)
- Rotate Right (ROR)
- Variable shift amount
- Self-checking Verilog testbench
- Expected-value calculation and output verification
- Simulation-ready for Vivado

### Files
- `barrel_shifter.v` – Barrel shifter RTL design
- `barrel_tb.v` – Self-checking testbench

**Tools:** Verilog HDL, Xilinx Vivado
