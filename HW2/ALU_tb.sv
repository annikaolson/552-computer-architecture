module ALU_tb();

	// inputs and outputs for the ALU

	logic  [3:0] ALU_In1, ALU_In2;
	logic  [1:0] Opcode;
	logic [3:0] ALU_Out;
	logic Error;	// to show overflow

	logic [3:0] expected_output;

	// instantiate module
	ALU iDUT(.ALU_Out(ALU_Out), .Error(Error), .ALU_In1(ALU_In1), .ALU_In2(ALU_In2), .Opcode(Opcode));

	/////////////////////////////////
	// test ALU on four different  //
	// operations: add, subtract,  //
	// nand, and xor - add and sub //
	// use previous modules.       //
	/////////////////////////////////
	initial begin
		// Case 1: Opcode = 00, simple addition operation
		Opcode = 00;
		ALU_In1 = 2;
		ALU_In2 = 2;
		expected_output = ALU_In1 + ALU_In2;
		#2
		if (ALU_Out !== expected_output) begin
			$display("Error: with opcode %d, the output was %d, but should be $d.", Opcode, ALU_Out, expected_output);
			$stop();
		end

		// Case 2: Opcode = 01, simple subtraction operation
		Opcode = 01;
		ALU_In1 = 6;
		ALU_In2 = 2;
		expected_output = ALU_In1 - ALU_In2;
		#2
		if (ALU_Out !== expected_output) begin
			$display("Error: with opcode %d, the output was %d, but should be $d.", Opcode, ALU_Out, expected_output);
			$stop();
		end

		// Case 3: Opcode = 10, nand operation
		Opcode = 10;
		ALU_In1 = 4'b0110;
		ALU_In2 = 4'b0011;
		expected_output = 4'b1101;
		#2
		if (ALU_Out !== expected_output) begin
			$display("Error: with opcode %d, the output was %d, but should be $d.", Opcode, ALU_Out, expected_output);
			$stop();
		end
		
		// Case 4: Opcode = 11, xor operation
		Opcode = 11;
		ALU_In1 = 4'b1010;
		ALU_In2 = 4'b1100;
		expected_output = 4'b0110;
		#2
		if (ALU_Out !== expected_output) begin
			$display("Error: with opcode %d, the output was %d, but should be $d.", Opcode, ALU_Out, expected_output);
			$stop();
		end

		// Case 5: Opcode = 00, addition with overflow
		Opcode = 00;
		ALU_In1 = 4;
		ALU_In2 = 5;
		expected_output = ALU_In1 + ALU_In2;
		#2
		if ((ALU_Out !== expected_output) || !Error) begin
			$display("Error: with opcode %d, the output was %d, but should be $d. The error should be 1, but was %d", Opcode, ALU_Out, expected_output, Error);
			$stop();
		end

		$display("All tests passed!");
		$stop();
	end

endmodule
