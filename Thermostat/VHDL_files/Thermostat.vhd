library ieee;
use ieee.std_logic_1164.all;

entity thermostat is
	port (
		clock_50 : in std_logic;
		hex3, hex2, hex1, hex0 : out std_logic_vector(0 to 6);
		key : in std_logic_vector(0 to 3);
		sw : in std_logic_vector(0 to 9);
		ledr : buffer std_logic_vector(0 to 9);
		ledg : buffer std_logic_vector(0 to 7)
		);
end thermostat;

architecture rtl of thermostat is
	--Define subtype for seven segment LED
		subtype hex_digit is std_logic_vector(0 to 6);
		type hex_digit_array is array(natural range <>) of hex_digit; --User can pick as long as in scope
		CONSTANT digits : hex_digit_array :=
		(
		"0000001", "1001111", "0010010", "0000110", "1001100",
		"0100100", "0100000", "0001111", "0000000", "0000100"
		);
		
		subtype digit is integer range 0 to 9; --Doesnt use full 32 bits of integer type
		--So we don't have to type out the digits by hand 
		function get_hex_digit(d:digit) return hex_digit is 
		begin
			return digits(d);
		end function;
		
		type temp_unit is (Celsius, Fahrenheit);
		type hex_temp_array is array(temp_unit range <>) of hex_digit;
		constant temp_char_array : hex_temp_array(Celsius to Fahrenheit) :=
			("0110001", "0111000");
			--C and F
		type temp_setting is record
			temp: integer range 0 to 99;
			unit: temp_unit;
		end record;
		
		signal setting : temp_setting:= (0, Celsius);
		signal up, down : integer := 0; --Doing this so two clocks doesn't drive one signal
begin
	hex3 <= get_hex_digit(setting.temp / 10);
	hex2 <= get_hex_digit(setting.temp rem 10);
	hex1 <= "0011100";
	hex0 <= temp_char_array(setting.unit);
	
	setting.temp <= up - down; --Doing this for the same reasons
	
	process(key)
	begin
		if (key(0)'event and key(0) = '0') then
			up <= up + 1;
		end if;
		if (key(1)'event and key(1) = '0') then
			down <= down + 1;
		end if;
	end process;
--Could make it so it actually converts from one unit to another
	process(sw)
	begin
		if sw(0) = '0' then
			setting.unit <= Celsius;
		else
			setting.unit <= Fahrenheit;
		end if;
	end process;
end architecture;