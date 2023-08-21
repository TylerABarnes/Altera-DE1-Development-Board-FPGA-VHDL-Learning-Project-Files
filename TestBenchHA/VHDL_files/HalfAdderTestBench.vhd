library ieee;
use ieee.std_logic_1164.all;

entity HalfAdderTestBench is --No inputs so no entity
end HalfAdderTestBench;

architecture tb of HalfAdderTestBench is

signal a, b, s, c : std_logic;

begin

ha: entity work.TestBenchHA(rtl) --UUT (Must be connected to entity of main file)
	port map
	(
	a => a,
	b => b,
	s => s,
	c => c
	);

all_tests: process
begin
	report "Starting A 0/0 Test" severity note;
	a <= '0';
	b <= '0';
	wait for 20 ns;
	assert s = '0' report "Sum Mismatch" severity error; --Gives error if s != 0
	assert c = '0' report "Carry Mismatch" severity error;
	
	wait;                                                --So it doesn't loop around
end process;
	
end architecture;