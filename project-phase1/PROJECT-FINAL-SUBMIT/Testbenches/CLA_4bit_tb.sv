module cla_4bit_tb();

	// inputs and outputs for the 4-bit adder/subtractor
	logic [3:0] A, B, sum;
	logic cout, cin;

	// instantiate module
	CLA_4bit iDUT(.S(sum), .Cout(cout), .A(A), .B(B), .Cin(cin));

	initial begin
		assign A = 4'b1111;
		assign B = 4'b1111;
		assign cin = 0;
		#2
		$stop();
	end

endmodule
