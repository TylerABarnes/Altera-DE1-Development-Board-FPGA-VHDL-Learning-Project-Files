library ieee;
use ieee.std_logic_1164.all;

--Defining entitity and associated architecture

entity half_adder_entity is
	port (
	a,b : in std_logic;
	s,c: out std_logic
	);
end;

architecture half_adder_arch of half_adder_entity is
begin

s <= a xor b;
c <= a and b;

end architecture; 