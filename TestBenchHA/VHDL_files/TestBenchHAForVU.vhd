library vunit_lib;
context vunit_lib.vunit_context;
library ieee;
use ieee.std_logic_1164.all;

entity TetsBenchHAForVU is --No inputs so no entity
	generic (runner_cfg : string); --How VUnit knows what to test
end TetsBenchHAForVU;

architecture tbvu of TetsBenchHAForVU is

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

main: process
begin

	test_runner_setup(runner, runner_cfg)
	--Where tests are actually defined
	while test_suite loop
		if run("zero test") then
			a <= '0';
			b <= '0';
			wait for 20 ns;
			check_equal(s, '0', "unexpected sum");
			check_equal(c, '0', "unexpected carry");
		end if;
	end loop;
	
	test_runner_cleanup(runner);
end process;
	
end architecture;