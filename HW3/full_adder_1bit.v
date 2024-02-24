module full_adder_1bit(A, B, Cin, Sum, Cout);

	input A, B;	// one-bit numbers to add
	input Cin;	// carry-in value
	output Sum;	// 1-bit sum
	output Cout;	// carry-out value

	// intermediate results
	wire xor_ab, and_cin, and_ab;
	
	// full adder circuit
	xor (xor_ab, A, B);
	xor (Sum, Cin, xor_ab);		// Sum result
	and (and_cin, Cin, xor_ab);
	and (and_ab, A, B);
	or (Cout, and_cin, and_ab);	// Cout result

endmodule