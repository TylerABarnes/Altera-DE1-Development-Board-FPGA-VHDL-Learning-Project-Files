
--This is a package--

library ieee;
use ieee.std_logic_1164.all;

package hex_conv is                       --Defining package
	function hex_digit(
		x : integer;
		hide_zero : boolean := false
		) return std_logic_vector;
end package;

package body hex_conv is 

function hex_digit(x:integer; hide_zero:boolean := false)
return std_logic_vector is
begin	
	case x is
		when 0 =>
			if hide_zero then	
				return "1111111";
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

end package body;