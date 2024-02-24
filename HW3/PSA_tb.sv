module PSA_tb();

	logic [15:0] A, B;
	logic [15:0] Sum;
	logic Error;
	logic [15:0] int_sum;

	// Instantiate PSA module
	PSA iDUT(.Sum(Sum), .Error(Error), .A(A), .B(B));

	initial begin
		$monitor("A=%b B=%b Sum=%b Error=%b", A, B, Sum, Error);

        	// Test cases
        	A = 16'h1242; B = 16'h0010; // No overflow
		int_sum = A + B;
		#5
		if (int_sum !== Sum) begin
			$display("Sum should be %d, but was %d; error was %d", int_sum, Sum, Error);
			$stop();
		end

        	A = 16'h0007; B = 16'h0008; // no overflow lowest 4 bits ([3:0])
		int_sum = A + B;
		#5
		if (Sum != int_sum || Error != 0) begin
			$display("Sum should be %d, but was %d; error was %d", int_sum, Sum, Error);
			$stop();
		end

        	A = 16'h0060; B = 16'h0010; // no overflow bits [7:4]
		int_sum = A + B;
		#5
		if (Sum != int_sum || Error != 0) begin
			$display("Sum should be %d, but was %d; error was %d", int_sum, Sum, Error);
			$stop();
		end

        	A = 16'h0600; B = 16'h0100; // no overflow in bits [11:8]
		int_sum = A + B;
		#5
		if (Sum != int_sum || Error != 0) begin
			$display("Sum should be %d, but was %d; error was %d", int_sum, Sum, Error);
			$stop();
		end

		A = 16'h6000; B = 16'h1000; // no overflow in bits [15:11]
		int_sum = A + B;
		#2
		if (Sum != int_sum || Error != 0) begin
			$display("Sum should be %d, but was %d; error was %d", int_sum, Sum, Error);
			$stop();
		end

		A = 16'h0004; B = 16'h0004; // overflow lowest 4 bits ([3:0])
		int_sum = A + B;
		#5
		if (Sum != int_sum || Error != 1) begin
			$display("Sum should be %d, but was %d; error was %d", int_sum, Sum, Error);
			$stop();
		end

        	A = 16'h0040; B = 16'h0040; // overflow bits [7:4]
		int_sum = A + B;
		#5
		if (Sum != int_sum || Error != 1) begin
			$display("Sum should be %d, but was %d; error was %d", int_sum, Sum, Error);
			$stop();
		end

        	A = 16'h0400; B = 16'h0400; // overflow in bits [11:8]
		int_sum = A + B;
		#5
		if (Sum != int_sum || Error != 1) begin
			$display("Sum should be %d, but was %d; error was %d", int_sum, Sum, Error);
			$stop();
		end

		A = 16'h4000; B = 16'h4000; // overflow in bits [15:11]
		int_sum = A + B;
		#2
		if (Sum != int_sum || Error != 1) begin
			$display("Sum should be %d, but was %d; error was %d", int_sum, Sum, Error);
			$stop();
		end

		$display("All tests passed!");
        	$stop();
	end


endmodule