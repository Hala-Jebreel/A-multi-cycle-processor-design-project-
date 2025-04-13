# A-multi-cycle-processor-design-project-
A multi-cycle processor design project implemented and tested in ARC with simulation files, binary memory, control unit tables, and documentation. 


 Multi-Cycle Processor Design | ENCS4370

This repository contains the full implementation of a **Simple Multi-Cycle Processor**, including datapath and control unit design, binary memory initialization, simulation results, and comprehensive documentation.

---

 About the Project

This project was developed as part of the Computer Architecture .

It aims to deepen understanding of processor architecture by designing a modular multi-cycle processor capable of executing arithmetic, logic, memory access, and control flow instructions.

---



Repository Contents

| File / Folder                      | Description |
|-----------------------------------|-------------|
| `binary.txt`                      | Memory initialization and register binary values |
| `Code.v`                          | Verilog design file for the processor |
| `Simulation_SaraandHala.awc`      | ARC simulation configuration |
| `Simulation_SaraandHala.asdb`     | ARC simulation database file |
| `PROJECT2_ARC_REPORT.docx/.pdf`   | Full project report including datapath design, control unit equations, truth tables, simulation results, and teamwork description |
| `ControlUnitstables_SaraAndHala.docx/.pdf` | Detailed control unit tables and descriptions |

---

Processor Design Features

- **Multi-stage architecture**: IF, ID, EX, MEM, WB
- **Instructions Supported**: `ADD`, `SUB`, `AND`, `ANDI`, `ADDI`, `LW`, `SW`, `LBU`, `LBS`, `BEQ`, `BNE`, `BGT`, `BLT`, `JUMP`, `CALL`, `RET`, `SV`
- **Components**: 
  - Program Counter
  - Register File
  - ALU
  - Control Units (Main, ALU, PC)
  - Instruction & Data Memory
  - Extender
  - Multiplexers

---
 Simulation

The design was simulated and tested using ARC tools. All instructions executed correctly, validating the processor's ability to handle arithmetic, logic, memory, and control operations.

 See simulation snapshots and verification details in:
- `PROJECT2_ARC_REPORT.pdf`
- `Figure 10`, `11`, and `12` in the report

---

 How to Run

To test the design:
1. Load `Code.v` into ARC.
2. Initialize memory using `binary.txt`.
3. Use `Simulation_SaraandHala.awc` and `.asdb` to simulate execution.
4. View outputs and confirm correctness using the flags and memory/register values.


References

- [Program Counter – Techopedia](https://www.techopedia.com/definition/13114/program-counter-pc)
- [Multiplexer – Wikipedia](https://en.wikipedia.org/wiki/Multiplexer)
- [Instruction Memory – ScienceDirect](https://www.sciencedirect.com/topics/computer-science/instruction-memory)
- [Register File – Wikipedia](https://en.wikipedia.org/wiki/Register_file)
- [ALU – Wikipedia](https://en.wikipedia.org/wiki/Arithmetic_logic_unit)

