<p align="center">
  <img src="https://img.shields.io/badge/Language-Verilog-blue?style=for-the-badge" alt="Verilog"/>
  <img src="https://img.shields.io/badge/IP_Core-FIFO-ff6600?style=for-the-badge" alt="FIFO"/>
  <img src="https://img.shields.io/badge/Category-VLSI%20Design-green?style=for-the-badge" alt="VLSI"/>
  <img src="https://img.shields.io/badge/Parameterized-Yes-blueviolet?style=for-the-badge" alt="Parameterized"/>
</p>

# 🗄️ Synchronous FIFO — Verilog HDL

> A parameterized, synthesizable synchronous FIFO (First In, First Out) buffer with configurable depth/width, status flags, and error detection.

---

## 🔍 Overview

FIFO buffers are **essential IP cores** used in every SoC design — from UART receive buffers to AXI interconnect data paths. This project implements a fully parameterized synchronous FIFO with comprehensive status and error reporting.

### Key Highlights
- 🔧 **Fully Parameterized** — Configurable DATA_WIDTH and FIFO_DEPTH
- 🚩 **6 Status Signals** — Full, Empty, Almost Full, Almost Empty, Overflow, Underflow
- 📊 **Data Count** — Real-time entry count output
- 🔄 **Simultaneous R/W** — Handles concurrent read and write operations
- ✅ **Self-Checking TB** — 20+ automated test cases
- 🔬 **Synthesizable** — Ready for FPGA implementation

---

## 🏗️ Architecture

```
              ┌──────────────────────────────────┐
  wr_en ──────┤►  ┌─────────────────────────┐    ├────── rd_data
  wr_data ────┤►  │   Memory Array          │    │
              │   │   [DEPTH x WIDTH]       │    ├────── full
              │   │                         │    ├────── empty
              │   │  wr_ptr ──►  [  ][  ]   │    ├────── almost_full
              │   │              [  ][  ]   │    ├────── almost_empty
              │   │              [  ][  ]   │    ├────── data_count
              │   │  rd_ptr ──►  [  ][  ]   │    ├────── overflow
              │   │                         │    ├────── underflow
  rd_en ──────┤►  └─────────────────────────┘    │
  clk ────────┤►                                 │
  rst_n ──────┤►                                 │
              └──────────────────────────────────┘
```

---

## ⚙️ Parameters

| Parameter | Default | Description |
|:---------:|:-------:|:------------|
| `DATA_WIDTH` | 8 | Width of data bus in bits |
| `FIFO_DEPTH` | 16 | Number of entries (must be power of 2) |

---

## 📁 File Structure

```
VLSI-Synchronous-FIFO/
├── src/
│   └── sync_fifo.v         # Parameterized FIFO module
├── testbench/
│   └── fifo_tb.v           # Self-checking testbench
├── docs/
├── .gitignore
├── LICENSE
└── README.md
```

---

## 🚀 Simulation Guide

```bash
# Compile
iverilog -o fifo_sim src/sync_fifo.v testbench/fifo_tb.v

# Run
vvp fifo_sim

# View waveforms
gtkwave fifo_tb.vcd
```

---

## 💡 Applications

- 📡 **UART/SPI Buffers** — Data buffering between clock domains
- 🔌 **AXI Interconnect** — Transaction buffering in bus protocols
- 🏭 **DMA Controllers** — Data staging for bulk transfers
- 🖥️ **Processor Pipelines** — Instruction/data queues

---

## 👨‍💻 Author

**Daggolu Hari Krishna** — B.Tech ECE | JNTUA College of Engineering, Kalikiri

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?style=flat-square&logo=linkedin)](https://linkedin.com/in/harikrishnadaggolu)
[![GitHub](https://img.shields.io/badge/GitHub-Harikrishna__08-black?style=flat-square&logo=github)](https://github.com/Harikrishna_08)

---

<p align="center">⭐ Star this repo if you found it useful! ⭐</p>
