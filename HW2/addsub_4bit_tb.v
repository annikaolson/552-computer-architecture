module addsub_4bit_tb();

	// inputs and outputs for the 4-bit adder/subtractor
	reg [3:0] a, b, sum, sum_test;
	reg ovfl, sub;

	// instantiate module
	addsub_4bit iDUT(.Sum(sum), .Ovfl(ovfl), .A(a), .B(b), .sub(sub));

	/////////////////////////////////////
	// test 4-bit adder on any number  //
	// 0-15 [max represented	   //
	// by a 4-bit binary number]       //
	/////////////////////////////////////
	initial begin
		for (int i = 0; i < 20; i++) begin
			assign sub = $random() % 2;
			assign a = $random() % 15;
			assign b = $random() % 15;
			assign sum_test = sub ? (a - b) : (a + b);	// expected
			#2
			if (sum!==sum_test) begin
				$display("Expected sum: %d | Actual sum: %d", sum, sum_test);
				$stop();	
			end
		end
		$display("All tests passed!");
		$stop();
	end

endmodule
