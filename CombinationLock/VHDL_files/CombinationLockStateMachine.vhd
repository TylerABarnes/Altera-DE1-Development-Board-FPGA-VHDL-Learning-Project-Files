library ieee;
use ieee.std_logic_1164.all;

--THIS IS AN EXAMPLE OF A MEALY STATE MACHINE IN ACTION --NEEDS TO BE FIXED
entity CombinationLock is
	port(
		key : in std_logic_vector(3 downto 0);
		hex3, hex2, hex1, hex0 : out std_logic_vector(0 to 6);
		clock_50: in std_logic
		);
end entity;

architecture rtl of CombinationLock is

--Takes integer and converts to 7-segment LED
function hex_digit(x:integer; hide_zero:boolean := true)
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

type state is (ready, ok1, ok2, ok3, yes, err1, err2, err3, fail);
signal current_state, next_state : state := ready;

signal last_key : std_logic_vector(3 downto 0) := "1111";   --Remember 1's == not pressed

subtype door_digit is integer range 0 to 4; 
type door_code_type is array(0 to 3) of door_digit;

constant unlock_code : door_code_type := (4, 3, 2, 1);       --Correct combination
signal entered_digits : door_code_type := (0, 0, 0, 0); 

--Remember we can't have a process which is sensitive to each of the four buttons, so we made digit_entered which combines them all
signal digit_entered : integer := -1; --Assigned User hasn't pressed any digit at all yet
signal entry_position, next_entry_position : integer := 0;

begin
		  --Different options depending on the state
hex3 <= "1111110" when current_state = ready
			else "1111111" when current_state =  yes
			else "0111000" when current_state = fail -- F
			else hex_digit(entered_digits(0));
hex2 <= "1111110" when current_state = ready
			else "1000100" when current_state = yes  --Y
			else "0001000" when current_state = fail -- A
			else hex_digit(entered_digits(1));
hex1 <= "1111110" when current_state = ready
			else "0110000" when current_state = yes --E
			else "1001111" when current_state = fail -- I
			else hex_digit(entered_digits(2));
hex0 <= "1111110" when current_state = ready
			else "0100100" when current_state = yes --S
			else "1110001" when current_state = fail -- L
			else hex_digit(entered_digits(3));

--Process to detect that some digit has been entered
-- State Transition Logic
process(clock_50) is
begin
    if rising_edge(clock_50) then
        if digit_entered /= -1 then --If someone actually entered a valid digit
            --Write the entered digit
            entered_digits(entry_position) <= digit_entered;
            
            --Error states propagate always (can't escape the error state)
            if current_state = err1 then    
                next_state <= err2;
            elsif current_state = err2 then
                next_state <= err3;
            elsif current_state = err3 then
                next_state <= fail;
                entered_digits <= (0, 0, 0, 0);
            else --If not in error state, then check 
                if digit_entered = unlock_code(entry_position) then
                    if current_state = ready or current_state = fail or current_state = yes then
                        next_state <= ok1;
                    elsif current_state = ok1 then
                        next_state <= ok2;
                    elsif current_state = ok2 then
                        next_state <= ok3;
                    elsif current_state = ok3 then
                        next_state <= yes;
                        entered_digits <= (0, 0, 0, 0);
                    end if;
                else 
                    if current_state = ready or current_state = fail or current_state = yes then
                        next_state <= err1;
                    elsif current_state = ok1 then
                        next_state <= err2;
                    elsif current_state = ok2 then
                        next_state <= err3;
                    elsif current_state = ok3 then
                        next_state <= fail;
                        entered_digits <= (0, 0, 0, 0);
                    end if;
                end if;
            end if;

            next_entry_position <= (entry_position + 1) rem 4; --A counter that tells you which position to write the number into
            entry_position <= next_entry_position; -- update entry position
            
            -- Update current state
            current_state <= next_state;
        end if;
    end if;
end process;

-- Button Input Handling
process(clock_50) is 
begin
    if rising_edge(clock_50) then 
        -- existing logic for button input handling goes here...
        
        if key(3) = '1' and last_key(3) = '0' then	
            digit_entered <= 1;
        elsif key(2) = '1' and last_key(2) = '0' then
            digit_entered <= 2;
        elsif key(1) = '1' and last_key(1) = '0' then
            digit_entered <= 3;
        elsif key(0) = '1' and last_key(0) = '0' then
            digit_entered <= 4;
        else
            digit_entered <= -1;
        end if;

        last_key <= key;  --A snapshot of the keys that have been pressed last time round
    end if;
end process;

end architecture;