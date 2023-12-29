# About Vaaman
Vaaman is a high-performance edge computing board, featuring a six-core ARM CPU and an FPGA with 112,128 logic cells. Its unique design makes it ideal for addressing many challenges unmet by current products. With a 300-MBps link between FPGA and CPU, Vaaman is optimized for hardware acceleration and excels at parallel computing. Vaaman’s versatility extends to its comprehensive range of interfaces, including PCI, HDMI, USB, MIPI, audio, Ethernet, Wi-Fi, Bluetooth, BLE, LVDS, and GPIOs.

Vaaman accelerates your most demanding edge-computing scenarios.

# APB BUS Exmple

This example shows you how to design and develop APB bus on VAAMAN's FPGA. It explains you a process of adding UART->APB->UART.


# Project README: UART-APB_UART

## Overview

This project implements a UART (Universal Asynchronous Receiver/Transmitter) communication system with an additional APB (Advanced Peripheral Bus) interface. The data flow involves a UART receiver, a connection receiver master, an APB master, a demux, slave module (Slave 1 and Slave 2), connection_slave_transmitter, and transmitter module (Transmitter for Slave 1 and Transmitter for Slave 2), a mux module and a top module.

## Modules

### 1. UART Receiver

The UART receiver module is responsible for receiving serial data and forwarding it to the connection receiver master.

### 2. Connection Receiver Master

This module accumulates 8 bits at a time from the UART receiver, organizes them (psel[2 bits], read/write enable[1 bit], data bits[32 bits], address bits[32 bits]), and sends the processed data to the APB master.

### 3. APB Master

The APB master module samples the data received from the connection receiver master and gives output.

### 4. Demux

The demux module receives data, address, and select line signals and routes them to the appropriate slave module based on the select line value[psel].

### 5. Slave Module (Slave 1 and Slave 2)

These modules receive data and address from the demux and process them using a state machine. The processed data is then sent to the connection slave transmitters.

### 6. Connection Slave Transmitter

These modules collect 32 bits of data, break them into chunks of 8 bits, and send them to the transmitter modules. They also handle the 32-bit address(note: only data bit moves forward from this block and the address bit is connected to the output bit of the top module).

### 7. Transmitter Modules (Transmitter for Slave 1 and Transmitter for Slave 2)

These UART transmitter modules receive 8 bits of data at a time and follow a state machine comprising start bit, data bit, and stop bit states to give the data out serially.

### 8. Mux

The mux module selects the pready signal from either the controller of Slave, depending on which slave is selected. This selected pready signal is connected to the input of the APB master block's pready signal.

## Data Flow

1. Data is received by the UART receiver.
2. The connection receiver master organizes the data and sends it to the APB master.
3. APB master assigns the data to its output signals.
4. Demux routes data, address, and select line signals to the appropriate slave module.
5. Slave modules process data and send it to connection slave transmitters.
6. Connection slave transmitters break down the data and send it to transmitter modules.
7. Transmitter modules display data on the screen.
8. Mux selects the pready signal based on the selected slave and connects it to APB master's pready signal.

## Note

The result has been checked through an analyzer.
