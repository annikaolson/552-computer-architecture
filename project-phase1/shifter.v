module Shifter(Shift_out, Shift_in, Shift_val, Mode);

	input [0:1] Mode;             // to indicate 0 = SLL or 1 = SRA
	input [15:0] Shift_in;  // input data to perform shift operation on
	input [3:0] Shift_val;        // shift amount
	output [15:0] Shift_out;      // shifted output data

	wire [15:0] shft_stg1_right, shft_stg2_right, shft_stg3_right;
	wire [15:0] shft_stg1_left, shft_stg2_left, shft_stg3_left;
	wire [15:0] srl_stg1, srl_stg2, srl_stg3;
	wire msb_sra;
	wire [15:0] sra_out, sll_out, srl_out, ror_out;

	//////////////////////////////////////////////////////////////
	// if mode is 01, then arithmetic shift right is peformed.  //
	// the most significant bit must be replicated, so we must  //
	// keep track of the MSB to replicate when shifting.        //
	//////////////////////////////////////////////////////////////

	assign msb_sra = Mode && Shift_in[15];
	// shifts right 1, replicates MSB
	assign shft_stg1_right = Shift_val[0] ? {msb_sra, Shift_in[15:1]} : Shift_in;
	// shifts right 2
	assign shft_stg2_right = Shift_val[1] ? {{2{msb_sra}}, shft_stg1_right[15:2]} : shft_stg1_right;
	// shifts right 4
	assign shft_stg3_right = Shift_val[2] ? {{4{msb_sra}}, shft_stg2_right[15:4]} : shft_stg2_right;
	// shifts right 8
	assign sra_out = Shift_val[3] ? {{8{msb_sra}}, shft_stg3_right[15:8]} : shft_stg3_right;

	/////////////////////////////////////////////
	// if mode is 00, then logical shift left. //
	/////////////////////////////////////////////

	// shifts left by 1 if bit 0 indicates such, otherwise keeps original value
	assign shft_stg1_left = Shift_val[0] ? (Shift_in << 1) : Shift_in;
	// shifts left by 2
	assign shft_stg2_left = Shift_val[1] ? (shft_stg1_left << 2) : shft_stg1_left;
	// shifts left by 4
	assign shft_stg3_left = Shift_val[2] ? (shft_stg2_left << 4) : shft_stg2_left;
	// shifts left by 8
	assign sll_out = Shift_val[3] ? (shft_stg3_left << 8) : shft_stg3_left;

	//////////////////////////////////////
	// if mode is 10, then right rotate //
	//////////////////////////////////////
	assign srl_Shift_val = ~Shift_val;
	// shifts right by 1
	assign srl_stg1 = srl_Shift_val[0] ? (Shift_in >> 1) : Shift_in;
	// shifts right by 2
	assign srl_stg2 = srl_Shift_val[1] ? (srl_stg1 >> 2) : srl_stg1;
	// shifts right by 4
	assign srl_stg3 = srl_Shift_val[2] ? (srl_stg2 >> 4) : srl_stg2;
	// shifts right by 8
	assign srl_out = srl_right_val[3] ? (srl_stg3 >> 8) : srl_stg3;
	assign ror_out = sll_out | srl_out;

	// Choose SRA or SLL based on mode
	always@(*) begin
		case (Mode)
			2'b00: Shift_out = sra_out;
			2'b01: Shift_out = sll_out;
			2'b10: Shift_out = ror_out;
			2'b11: Shift_out = 16'h00; // don't want to trigger error here
			default: $error("Error: opcode invalid!");
		endcase
	end

endmodule