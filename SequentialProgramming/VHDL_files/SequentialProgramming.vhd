entity SequentialProgramming is
	port(
		ledr : out bit_vector(0 to 9);
		ledg : out bit_vector(0 to 7);
		hex0 : out bit_vector(0 to 6);
		hex1 : out bit_vector(0 to 6);
		hex2 : out bit_vector(0 to 6);
		hex3 : out bit_vector(0 to 6);
		key : in bit_vector(0 to 3);
		sw : in bit_vector(0 to 9)
	);
end SequentialProgramming;

architecture arch of SequentialProgramming is
	-- First + Second argument
	function hex_digit(x: integer; hide_zero: boolean := false) return bit_vector is
	begin
		case x is
			when 0 =>
				if hide_zero then        
					return "1111111"; -- Hide the zero if hide_zero is true
				else
					return "0000001";
				end if;
			when 1 => return "1001111";
			when 2 => return "0010010";
			when 3 => return "0000110";
			when 4 => return "1001100";
			when 5 => return "0100100";
			when 6 => return "0100000";
			when 7 => return "0001111";
			when 8 => return "0000000";
			when 9 => return "0000100";
			when others => return "1111111";
		end case;
	end function;

begin

	process(key)
		variable count: integer := 0;
		variable hide_zero: boolean := false; -- Variable to control hiding zero
	begin
		if (key(0)'event and key(0) = '0') then -- If key generated an event and is 0 (button pressed)
			count := count + 1;
			if count = 10000 then -- Reset count to 0 when it reaches 10000
				count := 0;
			end if;
		end if;
		
		hide_zero := (count mod 100) = 0; -- Set hide_zero to true if middle zero is part of the number
		
		hex0 <= hex_digit(count mod 10);  --"Mod" operator is used to obtain the remainder
		hex1 <= hex_digit(count mod 100 / 10, hide_zero);
		hex2 <= hex_digit(count mod 1000 / 100, true);
		hex3 <= hex_digit(count / 1000, true);
		--Doesn't work perfectly but it's good enough IG
	end process;

end arch;
