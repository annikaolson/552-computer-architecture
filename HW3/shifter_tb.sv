module shifter_tb();

	logic [15:0] Shift_in;
	logic Mode;
	logic [3:0] Shift_val;
	logic [15:0] Shift_out;
	logic [15:0] expected;

	Shifter iDUT(.Shift_out(Shift_out), .Shift_in(Shift_in), .Shift_val(Shift_val), .Mode(Mode));

	initial begin

		// negative Shift_in, arith shift right 0
		Shift_in = 16'hB84C;
		Mode = 1'b1;
		Shift_val = 4'b0000;
		expected = 16'hB84C;
		#10;
		if (expected !== Shift_out) begin
			$display("Result was %d, but should have been %d", Shift_out, expected);
			$stop();
		end

		// negative Shift_in, arith shift right 2
		Shift_in = 16'hB84C;
		Mode = 1'b1;
		Shift_val = 4'b0010;
		expected = 16'hEE13;
		#5;
		if (expected !== Shift_out) begin
			$display("Result was %d, but should have been %d", Shift_out, expected);
			$stop();
		end

		// negative Shift_in, arith shift right 5
		Shift_in = 16'hB84C;
		Mode = 1'b1;
		Shift_val = 4'b0101;
		expected = 16'hFDC2;
		#5;
		if (expected !== Shift_out) begin
			$display("Result was %d, but should have been %d", Shift_out, expected);
			$stop();
		end

		// negative Shift_in, arith shift right 8
		Shift_in = 16'hB84C;
		Mode = 1'b1;
		Shift_val = 4'b1000;
		expected = 16'hFFB8;
		#5;
		if (expected !== Shift_out) begin
			$display("Result was %d, but should have been %d", Shift_out, expected);
			$stop();
		end

		// negative Shift_in, arith shift right 15
		Shift_in = 16'hB84C;
		Mode = 1'b1;
		Shift_val = 4'b1111;
		expected = 16'hFFFF;
		#5;
		if (expected !== Shift_out) begin
			$display("Result was %d, but should have been %d", Shift_out, expected);
			$stop();
		end

		// positive Shift_in, arith shift right 7
		Shift_in = 16'h184C;
		Mode = 1'b1;
		Shift_val = 4'b0111;
		expected = 16'h0030;
		#5;
		if (expected !== Shift_out) begin
			$display("Result was %d, but should have been %d", Shift_out, expected);
			$stop();
		end

		// positive Shift_in, arith shift right 15
		Shift_in = 16'h1B4C;
		Mode = 1'b1;
		Shift_val = 4'b1111;
		expected = 16'h0000;
		#5;
		if (expected !== Shift_out) begin
			$display("Result was %d, but should have been %d", Shift_out, expected);
			$stop();
		end

		// negative Shift_in, logical shift left 0
		Shift_in = 16'hB82A;
		Mode = 1'b0;
		Shift_val = 4'b0000;
		expected = 16'hB82A;
		#5;
		if (expected !== Shift_out) begin
			$display("Result was %d, but should have been %d", Shift_out, expected);
			$stop();
		end

		// negative Shift_in, logical shift left 2
		Shift_in = 16'hBD10;
		Mode = 1'b0;
		Shift_val = 4'b0010;
		expected = 16'hBD10 << 2;
		#5;
		if (expected !== Shift_out) begin
			$display("Result was %d, but should have been %d", Shift_out, expected);
			$stop();
		end

		// negative Shift_in, logical shift left 5
		Shift_in = 16'hB84C;
		Mode = 1'b0;
		Shift_val = 4'b0101;
		expected = 16'hB84C << 5;
		#5;
		if (expected !== Shift_out) begin
			$display("Result was %d, but should have been %d", Shift_out, expected);
			$stop();
		end

		// negative Shift_in, logical shift left 8
		Shift_in = 16'hB84C;
		Mode = 1'b0;
		Shift_val = 4'b1000;
		expected = 16'hB84C << 8;
		#5;
		if (expected !== Shift_out) begin
			$display("Result was %d, but should have been %d", Shift_out, expected);
			$stop();
		end

		// negative Shift_in, logical shift left 15
		Shift_in = 16'hB84C;
		Mode = 1'b0;
		Shift_val = 4'b1111;
		expected = 16'hB84C << 15;
		#5;
		if (expected !== Shift_out) begin
			$display("Result was %d, but should have been %d", Shift_out, expected);
			$stop();
		end

		// positive Shift_in, logical shift left 9
		Shift_in = 16'h184C;
		Mode = 1'b0;
		Shift_val = 4'b1001;
		expected = 16'h184C << 9;
		#5;
		if (expected !== Shift_out) begin
			$display("Result was %d, but should have been %d", Shift_out, expected);
			$stop();
		end

		// positive Shift_in, logical shift left 15
		Shift_in = 16'h1832;
		Mode = 1'b0;
		Shift_val = 4'b1111;
		expected = 16'h1832 << 15;
		#5;
		if (expected !== Shift_out) begin
			$display("Result was %d, but should have been %d", Shift_out, expected);
			$stop();
		end

		$display("All tests passed!");
		$stop();
	end

endmodule