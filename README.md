# VHDL-VIVADO-logic-nets
* This project was made between February and March 2022, at Politecnico University of Milan.
* More details about the Requirments and the report have been uploaded 

The ptoject was assigned as final prove of the course: RETI LOGICHE 2022
- language: VHDL
- software: Xilinx Vivado
- use: FPGA

## Requirments

The aim of the project was to develop a HW module that could interface with a memory, read data from it and after some computions using a FS automata 
rewrite results on the memory.

The memory used is a RAM with byte addressing.
The computation required is the application of a convolutional code 1/2 described by the following FSA

// vevee immagine

The component must be able to elaborate several stream of bytes one after the other when a signal called
START is high and emits a signal called STOP when the elaboration is ended, if the START signal returns high
the elaboration restarts using an other memory as input of data.

The component works syncronously with the CLOCK signal. The last input signal is the RESET needded for the reset
of the component.

## Architecture and design

- used 2 main components: 
  - **convolutor:** The first component is a large FSA that handles all the operations and is drived by the second component
  - **operations:** The second component is the responsible of all the combinational logic required



