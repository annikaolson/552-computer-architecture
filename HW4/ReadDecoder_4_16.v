module ReadDecoder_4_16(RegId, Wordline);

	// INPUTS AND OUTPUTS
	input [3:0] RegId;
	output [15:0] Wordline;

	////////////////////////////////////
	// Wordline = 16'h001 << RegId    //
	// this effectively sets a bit	  //
	// of Wordline based on RegId     //
	// e.g. if RegId = 4, Wordline[4] //
	// is asserted.			 		  //
	////////////////////////////////////
	Shifter read_shift(.Shift_out(Wordline), .Shift_in(16'h0001), .Shift_val(RegId), .Mode(1'b0));

endmodule
