entity Resolution is
	port(
		key: in bit_vector(3 downto 0);
		sw: in bit_vector(9 downto 0)
		);
end entity;

architecture rtl of Resolution is 

type level is (error, warning, okay);
type level_vector is array(natural range <>) of level;
type level_table is array(level,level) of level; --three dimensional array

constant resolution_table : level_table := (
--  error   warning   okay
	(error,  error,   error),   --e
	(error,  warning, warning), --w
	(error,  warning, okay)     --o
);

function resolved(v: level_vector) return level is
	variable result : level := okay;
begin

if v'length = 1 then 
	result := v(v'low);
else
	--Gonna go through each of the elements in the vector and see what the table tells us and assign it to result
	for i in v'range loop
		result := resolution_table(result, v(i));
	end loop;
end if;
return result;

end resolved;

subtype rlevel is resolved level; --Program will look for function to preform resolution

signal s1, s2, s3: rlevel;

begin

	s1 <= error when key(2) = '0' else	
		warning when key(1) = '0' else
		okay;
	
	s2 <= error when sw(2) = '1' else	
		warning when sw(1) = '1' else
		okay;
--Going to assign our own rules for our signal 1 and 2 can play into this one  
	--This wouldn't normally work if we didn't use the resolution table
	s3 <= s1;
	s3 <= s2;
end rtl;