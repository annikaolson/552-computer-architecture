module Shifter(Shift_out, Shift_in, Shift_val, Mode);

	input [1:0] Mode;             // to indicate 0 = SLL or 1 = SRA
	input [15:0] Shift_in;  // input data to perform shift operation on
	input [3:0] Shift_val;        // shift amount
	output [15:0] Shift_out;      // shifted output data

	reg [15:0] shft_stg1_right;
	reg [15:0] shft_stg1_left;
	reg [15:0] ror_stg1;
	wire msb_sra;
	reg [15:0] sra_out, sll_out, ror_out;

	//////////////////////////////////////////////////////////////
	// if mode is 01, then arithmetic shift right is peformed.  //
	// the most significant bit must be replicated, so we must  //
	// keep track of the MSB to replicate when shifting.        //
	//////////////////////////////////////////////////////////////
	assign msb_sra = Shift_in[15];
	
	always@(*) begin
		case (Shift_val[1:0])
			2'b00 : assign shft_stg1_right = Shift_in; // shift 0
			2'b01 : assign shft_stg1_right = {msb_sra, Shift_in[15:1]}; // shift 1
			2'b10 : assign shft_stg1_right = {{2{msb_sra}}, Shift_in[15:2]}; // shift 2
			2'b11 : assign shft_stg1_right = {{3{msb_sra}}, Shift_in[15:3]}; // shift 3
		endcase
	end

	always@(*) begin
		case (Shift_val[3:2])
			2'b00 : assign sra_out = shft_stg1_right; // shift 0
			2'b01 : assign sra_out = {{4{msb_sra}}, shft_stg1_right[15:4]}; // shift 4
			2'b10 : assign sra_out = {{8{msb_sra}}, shft_stg1_right[15:8]}; // shift 8
			2'b11 : assign sra_out = {{12{msb_sra}}, shft_stg1_right[15:12]}; // shift 12
		endcase
	end

	/////////////////////////////////////////////
	// if mode is 00, then logical shift left. //
	/////////////////////////////////////////////
	always@(*) begin
		case (Shift_val[1:0])
			2'b00 : assign shft_stg1_left = Shift_in; // shift 0
			2'b01 : assign shft_stg1_left = Shift_in << 1; // shift 1
			2'b10 : assign shft_stg1_left = Shift_in << 2; // shift 2
			2'b11 : assign shft_stg1_left = Shift_in << 3; // shift 3
		endcase
	end 

	always@(*) begin
		case (Shift_val[3:2])
			2'b00 : assign sll_out = shft_stg1_left; // shift 0
			2'b01 : assign sll_out = shft_stg1_left << 4; // shift 4
			2'b10 : assign sll_out = shft_stg1_left << 8; // shift 8
			2'b11 : assign sll_out = shft_stg1_left << 12; // shift 12
		endcase
	end

	//////////////////////////////////////
	// if mode is 10, then right rotate //
	//////////////////////////////////////
	always@(*) begin
		case (Shift_val[1:0])
			2'b00 : assign ror_stg1 = Shift_in; // shift 0
			2'b01 : assign ror_stg1 = {Shift_in[0], Shift_in[15:1]}; // shift 1
			2'b10 : assign ror_stg1 = {Shift_in[1:0], Shift_in[15:2]}; // shift 2
			2'b11 : assign ror_stg1 = {Shift_in[2:0], Shift_in[15:3]}; // shift 3
		endcase
	end

	always@(*) begin
		case (Shift_val[3:2])
			2'b00 : assign ror_out = ror_stg1; // shift 0
			2'b01 : assign ror_out = {ror_stg1[3:0], ror_stg1[15:4]}; // shift 4
			2'b10 : assign ror_out = {ror_stg1[7:0], ror_stg1[15:8]}; // shift 8
			2'b11 : assign ror_out = {ror_stg1[11:0], ror_stg1[15:12]}; // shift 12
		endcase
	end

	// Choose SRA or SLL based on mode
	assign Shift_out = (Mode == 2'b00) ? sll_out :
						(Mode == 2'b01) ? sra_out : ror_out;

endmodule