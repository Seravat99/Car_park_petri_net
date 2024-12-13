# Car_park_petri_net
Controller for opening and closing gates of a park and checking how many are inside.


INTRODUCTION

A brief description of the parking lot we used as a basis for modeling the controller will be necessary:

- The car park consists of 3 levels, each level with a capacity of 50 spaces.
- The car park can be accessed via two entrances and two exits: one entrance and one exit on level 1, and one entrance and one exit on level 2.
- Access between floors, from floor 1 to floor 2 is via two ramps (unidirectional 1->2, and unidirectional 2->1) and from floor 3 to floor 2 is via a single bidirectional ramp.

IMPLEMENTATION IN VHDL

VHDL code is implemented by joining several modules together.
One of the main modules is made up of 3 modules:
- The first module, 'Park_Main', is generated automatically by the tool used to develop the Petri Net (IOPT Tools).
- The second module, 'Conv_Displays', is the converter for the FPGA display created specifically for the parking lot, and is different from the converter used for the clock.
- The third module, 'Main', is the module that comes from the previous work and is the module that is responsible for bringing the clock component to the parking lot.

We call this module 'Multiplexer' because it deals with how we interact and choose inputs and modes within our car park.

The second main module is the 'Car_Park_Implementation' module, which contains the code responsible for communicating with the FPGA.
The code for each module can be found in the appendices to this report, as this section was only used to explain the structure of the project's implementation in VHDL.

For interaction with the FPGA, see the table below.

![image](https://github.com/user-attachments/assets/79e26632-c1d0-4a08-915c-7cf50ba7d947)


#
Last time the code was tested -> 12/01/2022
