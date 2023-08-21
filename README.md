# Altera-DE1-Development-Board-FPGA-VHDL-Learning-Project-Files
A collection of all my major VHDL experiments and learning code demonstrations for the Altera DE1 Development Board.

Each folder provides the Quartus II project file, Quartus II Output Files, VHDL files to be included in the project, and the pin assignments needed to run the code properly on the board.

Included Is;

-"CombinationLock" : A simulated combination lock where the user uses the onboard push buttons to enter a combination --> Good example of a mealy state machine.

-"FullerAdderWithGenerics" : A simulated full adder where the user uses the onboard switches to control the inputs   --> Good example of using generics.

-"HelloFPGA" : An extremely basic program that just shows how to set up a few sections of the board and get your first program going.

-"PackagesAndComponents" : A simulated full adder now utilizing multiple seperate files that interact with one another --> Good example of how to set up packages and components within a project.

-"Resettable Timer" : A simulated timer that increments every second and counts off the seconds, minutes, and hours --> Good example of how to manipulate the avaiable onboard clock signals.

-"ErrorReportingWithResolutions" : A program to show how to set up and use three dimensional arrays and resolution tables to streamline designs.

-"SequentialProgramming" : A simple program that outputs to onboard 7-segment hex displays and which intentionally only uses sequential principles to get comfortable with the software before trying concurrent programming.

-"TestBenchHA" : Another simulated half adder specifically designed to show off and demonstrate how to set up test benches within a design --> Good example of how to start learning how to troubleshoot code.

-"TestingIO" : A slightly less extremely basic program that just shows how to set up multiple sections of the board and get your first program going, this time also including the onboard hex displays.

-"Thermostat" : A simulated thermostat where the user can increment and decrement the temperature displayed --> Good introduction to arrays, subtypes, and signals.

-"TrafficLights" : A simulated traffic light where the user uses the onboard push buttons to enter a traffic condition   --> Good example of a moore state machine.
