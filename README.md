# 32-bit RISC-V (RV32I) Single-Cycle Processor Core
In this project, I designed and verified a single-cycle RV32I RISC-V processor supporting essential instruction formats (R-type, I-type, Load/Store, and Branch instructions), followed by synthesis on the Gowin GW1NR-9 FPGA.

## FPGA Implementation Report 
## Target Hardware & Tools Specifications
Synthesis & P&R Tool: Gowin EDA (Version V1.9.12.03)
Target FPGA Device: Gowin LittleBee GW1NR-9 (GW1NR-LV9QN88PC6/I5)
Development Board: Tang Nano 9K
HDL Language: Verilog HDL
 Top-Level Schematic
![RTL Schematic](./schematic.png)
## Resource Utilization
<img width="1372" height="558" alt="image" src="https://github.com/user-attachments/assets/47cd44e8-dd04-4b8b-85ed-bd2562a97ede" />
## RTL Hardware Architecture & Diagram 
Clock Input: clk_50mhz
Reset Input: Active-Low Reset (rst_n)
Hardware Outputs: Status LEDs mapped via leds[5:0] to indicate processor execution state / internal registers.
## Memory Initialization 
The Instruction Memory was initialized onto FPGA Block RAMs (BSRAM) at synthesis time using Verilog $readmemh reading the compiled instructions from instructions.txt
