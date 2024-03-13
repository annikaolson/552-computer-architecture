module WriteDecoder_4_16(RegId, WriteReg, Wordline);

	// INPUTS AND OUTPUTS
	input [3:0] RegId;
	input WriteReg;
	output [15:0] Wordline;

	///////////////////////////////////////////
	// Wordline = 16'h000{WriteReg} << RegId //
	///////////////////////////////////////////
	Shifter write_shift(.Shift_out(Wordline), .Shift_in({{15{1'b0}},WriteReg}), .Shift_val(RegId), .Mode(1'b0));

endmodule
