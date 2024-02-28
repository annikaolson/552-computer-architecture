module addsub_4bit(Sum, Ovfl, A, B, sub);

	input [3:0] A, B;	// input values
	input sub;		// add-sub indicator
	output [3:0] Sum;	// sum output
	output Ovfl;		// To indicate overflow
	
	// Cout for each 1-bit full adder result
	wire Cout1, Cout2, Cout3, Cout4;

	///////////////////////////////////////////////////////
	// RC adder/subtractor using 4 1-bit full adders. if //
	// sub is 1, then the operation A - B is performed,  //
	// so B is complemented and the carry-in is 1 [sub]. //
	///////////////////////////////////////////////////////
	full_adder_1bit FA1(.A(A[0]), .B((B[0] ^ sub)), .Cin(sub), .Sum(Sum[0]), .Cout(Cout1));
	full_adder_1bit FA2(.A(A[1]), .B((B[1] ^ sub)), .Cin(Cout1), .Sum(Sum[1]), .Cout(Cout2));
	full_adder_1bit FA3(.A(A[2]), .B((B[2] ^ sub)), .Cin(Cout2), .Sum(Sum[2]), .Cout(Cout3));
	full_adder_1bit FA4(.A(A[3]), .B((B[3] ^ sub)), .Cin(Cout3), .Sum(Sum[3]), .Cout(Cout4));

	xor (Ovfl, Cout3, Cout4);	// assign overflow

endmodule