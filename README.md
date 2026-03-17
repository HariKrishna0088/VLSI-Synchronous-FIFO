<p align="center">
  <img src="https://img.shields.io/badge/Language-Verilog-blue?style=for-the-badge" alt="Verilog"/>
  <img src="https://img.shields.io/badge/IP_Core-FIFO-ff6600?style=for-the-badge" alt="FIFO"/>
  <img src="https://img.shields.io/badge/Category-VLSI%20Design-green?style=for-the-badge" alt="VLSI"/>
  <img src="https://img.shields.io/badge/Parameterized-Yes-blueviolet?style=for-the-badge" alt="Parameterized"/>
</p>

# ðŸ—„ï¸ Synchronous FIFO â€” Verilog HDL

> A parameterized, synthesizable synchronous FIFO (First In, First Out) buffer with configurable depth/width, status flags, and error detection.

---

## ðŸ” Overview

FIFO buffers are **essential IP cores** used in every SoC design â€” from UART receive buffers to AXI interconnect data paths. This project implements a fully parameterized synchronous FIFO with comprehensive status and error reporting.

### Key Highlights
- ðŸ”§ **Fully Parameterized** â€” Configurable DATA_WIDTH and FIFO_DEPTH
- ðŸš© **6 Status Signals** â€” Full, Empty, Almost Full, Almost Empty, Overflow, Underflow
- ðŸ“Š **Data Count** â€” Real-time entry count output
- ðŸ”„ **Simultaneous R/W** â€” Handles concurrent read and write operations
- âœ… **Self-Checking TB** â€” 20+ automated test cases
- ðŸ”¬ **Synthesizable** â€” Ready for FPGA implementation

---

## ðŸ—ï¸ Architecture

```
              â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
  wr_en â”€â”€â”€â”€â”€â”€â”¤â–º  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”    â”œâ”€â”€â”€â”€â”€â”€ rd_data
  wr_data â”€â”€â”€â”€â”¤â–º  â”‚   Memory Array          â”‚    â”‚
              â”‚   â”‚   [DEPTH x WIDTH]       â”‚    â”œâ”€â”€â”€â”€â”€â”€ full
              â”‚   â”‚                         â”‚    â”œâ”€â”€â”€â”€â”€â”€ empty
              â”‚   â”‚  wr_ptr â”€â”€â–º  [  ][  ]   â”‚    â”œâ”€â”€â”€â”€â”€â”€ almost_full
              â”‚   â”‚              [  ][  ]   â”‚    â”œâ”€â”€â”€â”€â”€â”€ almost_empty
              â”‚   â”‚              [  ][  ]   â”‚    â”œâ”€â”€â”€â”€â”€â”€ data_count
              â”‚   â”‚  rd_ptr â”€â”€â–º  [  ][  ]   â”‚    â”œâ”€â”€â”€â”€â”€â”€ overflow
              â”‚   â”‚                         â”‚    â”œâ”€â”€â”€â”€â”€â”€ underflow
  rd_en â”€â”€â”€â”€â”€â”€â”¤â–º  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜    â”‚
  clk â”€â”€â”€â”€â”€â”€â”€â”€â”¤â–º                                 â”‚
  rst_n â”€â”€â”€â”€â”€â”€â”¤â–º                                 â”‚
              â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```

---

## âš™ï¸ Parameters

| Parameter | Default | Description |
|:---------:|:-------:|:------------|
| `DATA_WIDTH` | 8 | Width of data bus in bits |
| `FIFO_DEPTH` | 16 | Number of entries (must be power of 2) |

---

## ðŸ“ File Structure

```
VLSI-Synchronous-FIFO/
â”œâ”€â”€ src/
â”‚   â””â”€â”€ sync_fifo.v         # Parameterized FIFO module
â”œâ”€â”€ testbench/
â”‚   â””â”€â”€ fifo_tb.v           # Self-checking testbench
â”œâ”€â”€ docs/
â”œâ”€â”€ .gitignore
â”œâ”€â”€ LICENSE
â””â”€â”€ README.md
```

---

## ðŸš€ Simulation Guide

```bash
# Compile
iverilog -o fifo_sim src/sync_fifo.v testbench/fifo_tb.v

# Run
vvp fifo_sim

# View waveforms
gtkwave fifo_tb.vcd
```

---

## ðŸ’¡ Applications

- ðŸ“¡ **UART/SPI Buffers** â€” Data buffering between clock domains
- ðŸ”Œ **AXI Interconnect** â€” Transaction buffering in bus protocols
- ðŸ­ **DMA Controllers** â€” Data staging for bulk transfers
- ðŸ–¥ï¸ **Processor Pipelines** â€” Instruction/data queues

---

## ðŸ‘¨â€ðŸ’» Author

**Daggolu Hari Krishna** â€” B.Tech ECE | JNTUA College of Engineering, Kalikiri

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?style=flat-square&logo=linkedin)](https://www.linkedin.com/in/contacthari88/)
[![GitHub](https://img.shields.io/badge/GitHub-Harikrishna__08-black?style=flat-square&logo=github)](https://github.com/Harikrishna_08)

---

<p align="center">â­ Star this repo if you found it useful! â­</p>
