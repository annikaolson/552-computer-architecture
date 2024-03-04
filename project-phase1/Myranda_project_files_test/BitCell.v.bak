module BitCell(clk, rst, D, WriteEnable, ReadEnable1, ReadEnable2, Bitline1, Bitline2);

	// INPUTS AND OUTPUTS
	input clk, rst;
	input D;
	input WriteEnable, ReadEnable1, ReadEnable2;
	inout Bitline1, Bitline2;

	// Intermediate variables
	wire Q;

	/////////////////////////////////////////////
	// Each bit cell consists of a D-Flip Flop //
	// and two tri-state buffer		   //
	/////////////////////////////////////////////
	
	// D-Flip Flop
	dff DFF(.q(Q), .d(D), .wen(WriteEnable), .clk(clk), .rst(rst));

	// Tri-states
	assign Bitline1 = (ReadEnable1) ? Q : 16'bZ;
	assign Bitline2 = (ReadEnable2) ? Q : 16'bZ;

endmodule
