# VHDL-VIVADO Logic-Nets

*This project was developed between February and March 2022, at Politecnico of Milan.*

*More details about the Requirments and the report are uploaded*

The project was assigned as final prove of the course: RETI LOGICHE 2022
- language: VHDL
- software: Xilinx Vivado
- use: FPGA
 
 
 
## Requirments

- The aim of the project was to develop a HW module that could interface with a memory, read data from it and after some computions using a FS automata 
rewrite results on the memory.

- The memory used is a RAM with byte addressing.
 - The computation required is the application of a convolutional code 1/2 represented by the following FSA


<p align="center"> <img height="300" src="https://user-images.githubusercontent.com/101199598/195575826-b26899bb-9277-4b01-a8cb-91184c7f6235.png">
 </p>


- The component must be able to elaborate several stream of bytes one after the other when a signal called
START is high and emits a signal called STOP when the elaboration is ended, if the START signal returns high
the elaboration restarts using an other memory as input of data.

- The component works syncronously with the CLOCK signal. The last input signal is the RESET needded for the reset
of the component.

## Architecture and design

Used 2 main components: 
  - **convolutor:** The first component is a large FSA that handles all the operations and is drived by the second component
  - **operations:** The second component is the responsible of all the combinational logic required
  
*See more details in the Report*



