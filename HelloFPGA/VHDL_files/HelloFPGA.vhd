entity HelloFPGA is
	port (
		ledr : out bit_vector(0 to 9);
		sw : in bit_vector(0 to 9)
	);
end HelloFPGA;

architecture arch of HelloFPGA is
begin
	ledr <= sw;
end arch;
