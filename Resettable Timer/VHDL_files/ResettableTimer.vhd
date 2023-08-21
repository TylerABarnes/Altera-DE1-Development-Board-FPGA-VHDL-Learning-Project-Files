entity ResettableTimer is
	port(
	clock_50 : in bit;
	ledr : out bit_vector(0 to 9);
	ledg : out bit_vector(0 to 7);
	hex0 : out bit_vector(0 to 6);
	hex1 : out bit_vector(0 to 6);
	hex2 : out bit_vector(0 to 6);
	hex3 : out bit_vector(0 to 6);
	
	key : in bit_vector(0 to 3);
	sw : in bit_vector(0 to 9)
	);
end ResettableTimer;

architecture arch of ResettableTimer is
signal count : integer := 1;
signal myclock : bit := '0';
signal mins, secs : integer range 0 to 59 := 0;

                   --First + Second argument
function hex_digit(x:integer; hide_zero:boolean := false) return bit_vector is
begin --Outside the begin and end of the architecture construct
	case x is  --Use return for a function
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

begin
--ALL THESE PROCESSES ARE HAPPENING CONCURRENTLY BC ALL IN ARCHITECTURE
process(clock_50) --Sensitive to clock (Takes 50 MHz clock and makes a 1 Hz clock called m"yclock")
begin
	if (clock_50'event and clock_50 = '1') then         --Rising edge
		count <= count + 1;
		if count = 25000000 then                         --Happens once a second
			myclock <= not myclock;                       --Inverting
			count <= 1;
		end if;
	end if;
end process;

process(myclock, key) --(Checks if we have generated an event on clock and if so, it checks key                 
begin	                -- to then reset the seconds and minutes, otherwise, it updates them
	if(myclock'event and myclock = '1') then
		if key(0) = '0' then
			secs <= 0;
			mins <= 0;
			else
				if (secs = 59) then 
				mins <= (mins + 1) rem 60;
			end if;
			secs <= (secs + 1) rem 60;
		end if;
	end if;
end process;

process(myclock) --(Updates the display based off the clock we made)
begin
	hex0 <= hex_digit(secs rem 10);                --Remainder
	hex1 <= hex_digit(secs / 10, true);            --Throws remainder away
	hex2 <= hex_digit(mins rem 10, mins = 0);
	hex3 <= hex_digit(mins / 10, true);
end process;

end arch;