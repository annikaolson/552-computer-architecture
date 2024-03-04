module addsub_16bit_tb();

	// inputs and outputs for the 4-bit adder/subtractor
	reg [15:0] A, B;
	reg sub;
	wire [15:0] sum;
	wire ovfl;

	// instantiate module
	CLA_16bit iDUT(.S(sum), .Cout(ovfl), .A(A), .B(B), .Sub(sub));

	/////////////////////////////////////
	// test 4-bit adder on any number  //
	// 0-15 [max represented	       //
	// by a 4-bit binary number]       //
	/////////////////////////////////////
	initial begin
		// positive saturation
		assign A = 32767;
		assign B = 32767;
		assign sub = 0;
		#5
		if (sum !== 16'h7FFF) begin
			$display("Sum was %d but should be 7FFF", sum);
			$stop();
		end

		#2
		// negative saturation
		assign A = -32767;
		assign B = -32767;
		assign sub = 0;
		#2
		if (sum !== 16'h8000) begin
			$display("Sum was %d but should be FFFF", sum);
			$stop();
		end

		#2
		// adding
		assign A = 15;
		assign B = 4;
		assign sub = 0;
		#2
		if (sum !== 19) begin
			$display("Sum was %d but should be 19", sum);
			$stop();
		end


		#2
		// adding negative
		assign A = 15;
		assign B = -8;
		assign sub = 0;
		#2
		if (sum !== 7) begin
			$display("Sum was %d but should be 7", sum);
			$stop();
		end

		#2
		// sub
		assign A = 15;
		assign B = 8;
		assign sub = 1;
		#2
		if (sum !== 7) begin
			$display("Sum was %d but should be 7", sum);
			$stop();
		end

		#2
		// sub again
		assign A = 8;
		assign B = -8;
		assign sub = 1;
		#2
		if (sum !== 16) begin
			$display("Sum was %d but should be 16", sum);
			$stop();
		end

		$display("all tests passed");
		$stop();
	end

endmodule