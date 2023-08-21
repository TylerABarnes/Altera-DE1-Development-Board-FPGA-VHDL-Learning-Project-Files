library ieee;                              --Using IEEE library
use ieee.std_logic_1164.all;
library ps;                                --Library I made(must be included in project)
use ps.hex_conv.all;                       --ALL - takign everyhting out of the library
--Already referred the library, so we don't need to add anything else to use the full adder
entity PackagesComponents is
	port(
	clock_50 : in std_logic;
	ledr : out std_logic_vector(0 to 9);
	ledg : out std_logic_vector(0 to 7);
	hex0 : out std_logic_vector(0 to 6);
	hex1 : out std_logic_vector(0 to 6);
	hex2 : out std_logic_vector(0 to 6);
	hex3 : out std_logic_vector(0 to 6);
	
	key : in std_logic_vector(0 to 3);
	sw : in std_logic_vector(0 to 9)
	);
end PackagesComponents;

architecture arch of PackagesComponents is

function count_ones(s : std_logic_vector) return integer is
	variable temp : integer := 0;
begin
	for i in s'range loop
		if s(i) = '1' then temp := temp + 1;
		end if;
	end loop;
	
	return temp;
end function count_ones;

begin
--Mapping the 10 switches to the inputs of 5 half adders
gen: for i in 0 to 4 generate                           --5 total entities
	ha: entity ps.half_adder_entity port map(           
		sw(i*2), sw(i*2 + 1), ledr(i*2), ledr(i*2 + 1)
	);
end generate gen;
--The left LED of each of the 5 pairs is the carry, the right of each pair is the sum
process(sw)
begin

hex0 <= hex_digit(count_ones(sw));
hex1 <= hex_digit(0, true);
hex2 <= hex_digit(0, true);
hex3 <= hex_digit(0, true);

end process;

end arch;