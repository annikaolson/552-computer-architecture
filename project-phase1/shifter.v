module Shifter(Shift_out, Shift_in, Shift_val, Mode);

	input Mode;             // to indicate 0 = SLL or 1 = SRA
	input [15:0] Shift_in;  // input data to perform shift operation on
	input [3:0] Shift_val;        // shift amount
	output [15:0] Shift_out;      // shifted output data

	wire [15:0] shft_stg1_right, shft_stg2_right, shft_stg3_right;
	wire [15:0] shft_stg1_left, shft_stg2_left, shft_stg3_left;
	wire msb_sra;
	wire [15:0] sra_out, sll_out;

	/////////////////////////////////////////////////////////////
	// if mode is 1, then arithmetic shift right is peformed.  //
	// the most significant bit must be replicated, so we must //
	// keep track of the MSB to replicate when shifting.       //
	/////////////////////////////////////////////////////////////

	assign msb_sra = Mode && Shift_in[15];
	// shifts right 1, replicates MSB
	assign shft_stg1_right = Shift_val[0] ? {msb_sra, Shift_in[15:1]} : Shift_in;
	// shifts right 2
	assign shft_stg2_right = Shift_val[1] ? {{2{msb_sra}}, shft_stg1_right[15:2]} : shft_stg1_right;
	// shifts right 4
	assign shft_stg3_right = Shift_val[2] ? {{4{msb_sra}}, shft_stg2_right[15:4]} : shft_stg2_right;
	// shifts right 8
	assign sra_out = Shift_val[3] ? {{8{msb_sra}}, shft_stg3_right[15:8]} : shft_stg3_right;

	////////////////////////////////////////////
	// if mode is 0, then logical shift left. //
	////////////////////////////////////////////

	// shifts left by 1 if bit 0 indicates such, otherwise keeps original value
	assign shft_stg1_left = Shift_val[0] ? (Shift_in << 1) : Shift_in;
	// shifts left by 2
	assign shft_stg2_left = Shift_val[1] ? (shft_stg1_left << 2) : shft_stg1_left;
	// shifts left by 4
	assign shft_stg3_left = Shift_val[2] ? (shft_stg2_left << 4) : shft_stg2_left;
	// shifts left by 8
	assign sll_out = Shift_val[3] ? (shft_stg3_left << 8) : shft_stg3_left;


	// Choose SRA or SLL based on mode
	assign Shift_out = Mode ? sra_out : sll_out;

endmodule