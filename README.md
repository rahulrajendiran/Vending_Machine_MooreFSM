
# Vending Machine Controller – Moore FSM (One-Hot Encoding)

![Block Diagram](./docs/images/block_diagram.png)

![Badge Verilog](https://img.shields.io/badge/HDL-Verilog-blue)
![Badge Vivado](https://img.shields.io/badge/Tool-Xilinx%20Vivado-orange)
![Badge FSM](https://img.shields.io/badge/FSM-Moore%20Machine-green)
![Badge Encoding](https://img.shields.io/badge/Encoding-OneHot-blueviolet)
![Badge License](https://img.shields.io/badge/License-MIT-yellow)

---

## 📑 Table of Contents
- [Project Overview](#project-overview)
- [Key Features](#key-features)
- [Architecture Diagram](#architecture-diagram)
- [FSM State Encoding](#fsm-state-encoding)
- [Module Interface](#module-interface)
- [Simulation and Verification](#simulation-and-verification)
- [Waveform Expectations](#waveform-expectations)
- [Repository Structure](#repository-structure)
- [How to Run Simulation](#how-to-run-simulation)
- [Future Improvements](#future-improvements)
- [License](#license)
- [Author](#author)

---

## 🔍 Project Overview
This repository contains a feature-rich **Vending Machine Controller** implemented in **Verilog** using a **Moore Finite State Machine (FSM)** with **One-Hot Encoding**. 
The design simulates a realistic vending workflow including coin recognition, debouncing, invalid input detection, change dispensing, timeout reset, dynamic pricing, and glitch-free synchronous outputs.

The project is fully verified using **Vivado (XSIM)** with a custom **testbench**, waveform-driven debugging, and multiple edge-case simulations.

---

## ⚡ Key Features
- Moore FSM with **One-Hot State Encoding**
- Coin inputs: **10, 20, 50 rupees**
- **Debounce filtering** for stable input detection
- **Invalid coin detection**
- **Dynamic product price** (`product_price`)
- Automatic **change calculation**
- **Cancel/Refund** functionality
- **Timeout auto-reset**
- Fully synchronous, glitch-free outputs
- Comprehensive **testbench** included

---

## 🧩 Architecture Diagram
Below is the block diagram representing the overall system architecture:

![Diagram](./docs/images/block_diagram.png)

---

## 🔢 FSM State Encoding
| State | One-Hot | Balance |
|-------|---------|---------|
| Sin   | 000000001 | 0 |
| S10   | 000000010 | 10 |
| S20   | 000000100 | 20 |
| S30   | 000001000 | 30 |
| S40   | 000010000 | 40 |
| S50   | 000100000 | 50 |
| S60   | 001000000 | 60 |
| S70   | 010000000 | 70 |
| S80   | 100000000 | 80 |

---

## 🧪 Module Interface
```
input  wire clk
input  wire reset
input  wire [1:0] coin
input  wire [6:0] product_price
input  wire cancel

output reg Z
output reg change_given
output reg [6:0] change_amount
output reg [6:0] balance_out
output reg invalid_coin
```

---

## 🧉 Simulation and Verification
The testbench performs:
- Exact payment testing  
- Overpayment calculation  
- Invalid coin handling  
- Timeout reset  
- Debounce rejection tests  
- Cancel/Refund behavior  
- Multi-cycle transaction sequences  
- Custom waveform analysis  

---

## 📈 Waveform Expectations
- `Z` pulses exactly on dispense  
- `change_amount` and `change_given` valid when balance ≥ price  
- `invalid_coin` pulses only for illegal patterns  
- Debounce ensures coin accepted only after ≥3 stable cycles  
- `balance_out` increments by 10/20/50 and resets accordingly  

---

## 📂 Repository Structure
```
Vending_Machine_MooreFSM/
│── rtl/
│   └── vending_machine_moore_enhanced.v
│── tb/
│   └── tb_vending_machine_moore_enhanced.v
│── docs/
│   └── images/
│       └── block_diagram.png
│── README.md
```

---

## ▶️ How to Run Simulation

### Using Vivado
1. Open Vivado → Run Simulation → Run Behavioral Simulation  
2. Add all signals to waveform  
3. Run simulation  


---

## 🚀 Future Improvements
- Add Mealy FSM fast-response version  
- Add coin-return actuator output  
- Add 7-segment / LCD display driver  
- Port to physical FPGA board (Basys3, Nexys A7)  
- Add UART logging  
- Add formal verification  

---

## 📄 License
This project is licensed under the **MIT License**.

---

## 👤 Author
Your Name: Rahul Rajendiran 
LinkedIn: *https://www.linkedin.com/in/rahulrajendiran?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app*  
GitHub: *https://github.com/rahulrajendiran*
