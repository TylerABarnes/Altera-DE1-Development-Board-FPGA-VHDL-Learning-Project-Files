library ieee;
use ieee.std_logic_1164.all;

entity TestBenchHA is
	port(
		a, b : in  std_logic;
		s, c : out std_logic
	);
end;

architecture rlt of TestBenchHA is
begin
	s <= a xor b;
	--c <= a and b;
end architecture;