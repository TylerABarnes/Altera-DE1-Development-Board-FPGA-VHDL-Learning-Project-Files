library ieee;
use ieee.std_logic_1164.all;

--THIS IS AN EXAMPLE OF A MOORE STATE MACHINE IN ACTION
entity TrafficLights is
	port(
		hex3, hex2, hex1, hex0 : out std_logic_vector(0 to 6);
		key : in std_logic_vector(3 downto 0);
		clock_50 : in std_logic;
		ledr : out std_logic_vector(9 downto 0)
		);
end entity;

architecture rtl of TrafficLights is

type light_type is (red, red_yellow, green, yellow, green_blinking);
type messages is array(light_type, 3 downto 0) of std_logic_vector(0 to 6); --Two dimensional array

constant light_messages : messages :=
(
	( "1111111", "1111010", "0110000", "1000010" ), --Red
	( "1111010", "0110000", "1000100", "0110000" ), --RedYellow
	( "0100001", "1111010", "0110000", "0110000" ), --Green
	( "1000100", "0110000", "1110001", "1110001" ), --Yellow
	( "0100001", "1111010", "1100000", "1110001" )  --GreenBlinking
);

signal light : light_type := red; --Starting with red type
signal clock_2 : std_logic := '0';

begin
--This part is essentially setting the map of where to go in the matrix
hex3 <= light_messages(light, 3);
hex2 <= light_messages(light, 2);
hex1 <= light_messages(light, 1);
hex0 <= light_messages(light, 0);

ledr(9) <= clock_2;

process(clock_2) is 
variable elapsed : integer := 0;
begin

if rising_edge(clock_2) then
	elapsed := elapsed + 1;
	
--Here is the actual state machine
	if light = red and elapsed > 5 then  --If light is current red and 5 seconds pass then do...
		light <= red_yellow;
		elapsed := 0;
	elsif light = red_yellow and elapsed > 2 then
		light <= green;
		elapsed := 0;
	elsif light = green and elapsed > 3 then
		light <= green_blinking;
		elapsed := 0;
	elsif light = green_blinking and elapsed > 2 then
		light <= yellow;
		elapsed := 0;
	elsif light = yellow and elapsed > 1 then
		light <= red;
		elapsed := 0;
	end if;
end if;
end process;

process(clock_50) is
variable count : integer := 0;
begin
	if rising_edge(clock_50) then
		if count > 25000000 then
			clock_2 <= not clock_2;
			count := 0;
		else
			count := count + 1;
		end if;
	end if;
end process;

end architecture;