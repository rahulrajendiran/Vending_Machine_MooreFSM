#Overview

This project implements a hardware-accurate vending machine controller in Verilog suitable for FPGA implementation. It models realistic system requirements (debouncing, invalid-coin detection, change calculation, cancel/refund, timeout reset) and is verified using a comprehensive testbench in Vivado (XSIM) or ModelSim.

#Key goals

Accurate finite-state modeling using a Moore FSM with one-hot state encoding (good for FPGA timing and clarity).

Realistic input handling (debounce + stable sampling).

Clean, synchronous outputs (glitch-free behavior).

Easy configuration via product_price.

Comprehensive verification (waveforms + stimulus vectors).

#Features

One-Hot Moore FSM states: Sin, S10, S20, S30, S40, S50, S60, S70, S80.

Accepts coins: 10, 20, 50 (encoded as 2'b00, 2'b01, 2'b10). 2'b11 used as idle/invalid.

Debounce logic — coin accepted only after N stable cycles (configurable).

Invalid coin detection (invalid_coin pulse).

Dynamic product_price input (7-bit).

Z (dispense) pulse and change_given with change_amount output.

Cancel/refund button returns current balance.

Timeout auto-reset clears balance after inactivity.

Testbench exercises edge cases: bounce/noise, invalid coins, timeout, cancel, overpayment.

#Debounce & Stability

A small counter requires the coin input to remain stable for STABLE_THRESHOLD cycles before it is latched and processed. This prevents bounces and transient misreads.

Idle/invalid is represented by 2'b11. The design differentiates between idle and invalid via the invalid_coin pulse when a truly invalid code is latched.

#How to Simulate
Using Vivado GUI (recommended)

Create a project and add rtl/ and tb/ files.

Open Flow → Run Simulation → Run Behavioral Simulation.

Add signals to waveform (clk, reset, coin, product_price, cancel, Z, change_given, change_amount, balance_out, invalid_coin, state).

#Example sequences

Exact pay: 10 → 20 → 10 → expect Z=1, change_given=0

Overpay single: 50 → expect Z=1, change_amount=10

Overpay multi: 50 → 10 → expect Z=1, change_amount=20

Cancel: 10 → 20 → cancel → expect change_amount=30 and balance cleared

Invalid coin: 11 for ≥ stable cycles → invalid_coin=1, no balance change

#Waveform Checks (what to inspect)

Z must be a single-cycle pulse aligned to clk (dispense).

change_given and change_amount valid when Z occurs or immediately after (synchronous).

balance_out increments by 10/20/50 only after the debounce window and then clears after dispense or cancel.

invalid_coin must pulse only on invalid encoding.

No combinational glitches on outputs (all outputs change on clk edges).

#Verification Coverage

The provided testbench exercises:

Exact payment, overpayment, multi-coin payments

Invalid coin detection

Debounce rejection (short pulses)

Cancel/refund

Timeout reset

Variable product_price scenarios

Add more directed randomized stimuli for extended coverage (recommended for formal verification).

#Porting to FPGA / Synthesis Notes

One-hot encoding is FPGA-friendly but consumes more flip-flops (tradeoff: simpler logic & timing).

All outputs are synchronous — safe for synthesis.

If implementing on board: add a hardware debouncer for coin sensor or tune STABLE_THRESHOLD for the board clock and sensor characteristics.

For real coin-return mechanisms, integrate with actuator drivers and coin dispensing hardware with safety interlocks.

#Future Work / Extensions

Support more denominations (include coin return mechanism control).

Add an MCP3008/ADC or sensor interface to read coin sensor analog signals directly.

Add secure payment gateway integration (NFC/RFID) alongside coin acceptor.

Replace Moore with Mealy where lower latency is needed.

Add hardware-in-loop testing on an FPGA board with real sensors and actuators.
