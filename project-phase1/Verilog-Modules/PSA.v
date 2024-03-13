module PSA(Sum, Error, A, B);

	input [15:0] A, B;	// input data values
	output [15:0] Sum;	// sum output
	output Error;		// to indicate overflow

	wire [3:0] Ovfl;	// carry out for checking overflow

	// instantiate 4-bit adders
	addsub_4bit stage1(.Sum(Sum[3:0]), .Ovfl(Ovfl[0]), .A(A[3:0]), .B(B[3:0]), .sub(1'b0));
	addsub_4bit stage2(.Sum(Sum[7:4]), .Ovfl(Ovfl[1]), .A(A[7:4]), .B(B[7:4]), .sub(1'b0));
	addsub_4bit stage3(.Sum(Sum[11:8]), .Ovfl(Ovfl[2]), .A(A[11:8]), .B(B[11:8]), .sub(1'b0));
	addsub_4bit stage4(.Sum(Sum[15:12]), .Ovfl(Ovfl[3]), .A(A[15:12]), .B(B[15:12]), .sub(1'b0));

	// assign error flag
	assign Error = (Ovfl[0] | Ovfl[1] | Ovfl[2] | Ovfl[3]); // Set error flag if any adder produced carry-out

endmodule
