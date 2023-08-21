entity full_adder is
	port(
	a, b, cin : in bit;
	s, cout : out bit
	);
end full_adder;

architecture rtl of full_adder is
begin	
	s <= a xor b xor cin;
	cout <= (a and b) or (cin and a) or (cin and b);
end rtl;

entity generic_adder is
    generic (size: integer); -- Going to define how big the adder is
    port(
        a, b : in bit_vector(size-1 downto 0);
        s : out bit_vector(size-1 downto 0);
        cin : in bit;
        cout : out bit
    );
end generic_adder;

architecture rtl of generic_adder is
    -- These all need to be connected to carry outputs so we make a signal
    signal carry: bit_vector(size downto 0);
begin
    foo: for n in 0 to size-1 generate 
        bar: entity work.full_adder(rtl) -- Specifying architecture (work is the default library name)
            port map (
                a => a(n),
                b => b(n),
                s => s(n),
                cin => carry(n),
                cout => carry(n+1) -- Connecting one full adder to another (this whole thing is port mapping)
            );
    end generate;
    carry(0) <= cin;
    cout <= carry(size);
end rtl;


--First full switches to A, second 4 switches to B
entity Generics is
	port(
		sw : in bit_vector(9 downto 0);
		ledr : out bit_vector(9 downto 0)
		);
end Generics;

architecture rtl of Generics is
begin 
--Specialize the generic_adder with a size
	adder: entity work.generic_adder(rtl)
		generic map(size => 4)  --Instead of assigning port connections we are assigning generic arguments
		port map(
			a => sw(3 downto 0),
			b => sw(7 downto 4),
			cin => '0',
			s => ledr(3 downto 0),
			cout => ledr(4)
			);
end rtl;