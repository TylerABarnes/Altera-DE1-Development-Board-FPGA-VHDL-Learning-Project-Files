entity TestingIO is
	port(
		ledr : out bit_vector(0 to 9); --Assigning all red LEDs
		ledg : out bit_vector(0 to 7); --Assigning all green LEDs
		hex0 : out bit_vector(0 to 6); --Assigning right most display
		hex1 : out bit_vector(0 to 6);
		hex2 : out bit_vector(0 to 6);
		hex3 : out bit_vector(0 to 6); --Assigning left most display
		
		key : in bit_vector(0 to 3);   --Assigning buttons
		sw : in bit_vector(0 to 9)     --Assinging switches
		);
end TestingIO;

architecture arch of TestingIO is
begin	
	ledr <= sw; --Switch to red LED
	
	ledg(0) <= '1'; --Right most green LED lights up
	
	--Remember with buttons 0 = down and 1 = up
	ledg(7) <= not key(0); --When button is pressed, least most LED lights up
	
	ledg(4) <= not key(2) and not key(3); --If both buttons are pressed
	
	--Writing "Smeg", Remember you start with 1(top) and go clockwise
	hex3 <= "0100100"; --S
	hex2 <= "0000110"; --Shitty M
	hex1 <= "0110000"; --E
	hex0 <= "0100000"; --Decent G
end arch;