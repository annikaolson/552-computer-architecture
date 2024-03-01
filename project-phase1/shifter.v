module Shifter(Shift_out, Shift_in, Shift_val, Mode);

	input [0:1] Mode;             // to indicate 0 = SLL or 1 = SRA
	input [15:0] Shift_in;  // input data to perform shift operation on
	input [3:0] Shift_val;        // shift amount
	output reg [15:0] Shift_out;      // shifted output data

	wire [15:0] shft_stg1_right, shft_stg2_right, shft_stg3_right;
	wire [15:0] shft_stg1_left, shft_stg2_left, shft_stg3_left;
	wire [15:0] srl_stg1, srl_stg2, srl_stg3;
	wire msb_sra;
	wire [15:0] sra_out, sll_out, srl_out, ror_out;
	wire [3:0] srl_Shift_val;

	//////////////////////////////////////////////////////////////
	// if mode is 01, then arithmetic shift right is peformed.  //
	// the most significant bit must be replicated, so we must  //
	// keep track of the MSB to replicate when shifting.        //
	//////////////////////////////////////////////////////////////
	always@(*) begin
		case (Shift_val[1:0])
			2'b00 : assign shft_stg1_right = Shift_in; // shift 0
			2'b01 : assign shft_stg1_right = {msb_sra, Shift_in[15:1]}; // shift 1
			2'b10 : assign shft_stg1_right = {{2{msb_sra}}, Shift_in[15:2]}; // shift 2
			2'b11 : assign shft_stg1_right = {{3{msb_sra}}, Shift_in[15:2]}; // shift 3
		endcase
	end

	always@(*) begin
		case (Shift_val[3:2])
			2'b00 : assign shft_stg2_right = shift_stg1_right; // shift 0
			2'b01 : assign shft_stg2_right = {{4{msb_sra}}, shift_stg1_right[15:1]}; // shift 1 more
			2'b10 : assign shft_stg2_right = {{8{msb_sra}}, shft_stg1_right[15:2]}; // shift 2 more
			2'b11 : assign sra_out = {{12{msb_sra}}, shft_stg1_right[15:2]}; // shift 3 more
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
			2'b00 : assign shft_stg2_left = shft_stg1_left; // shift 0
			2'b01 : assign shft_stg2_left = shft_stg1_left << 4; // shift 1
			2'b10 : assign shft_stg2_left = shft_stg1_left << 8; // shift 2
			2'b11 : assign sll_out = shft_stg1_left << 12; // shift 3
		endcase
	end

	//////////////////////////////////////
	// if mode is 10, then right rotate //
	//////////////////////////////////////
	assign srl_Shift_val = ~Shift_val; // srl shift val = max value - shift val = !shift val

	always@(*) begin
		case (srl_Shift_val[1:0])
			2'b00 : assign srl_stg1 = Shift_in; // shift 0
			2'b01 : assign srl_stg1 = Shift_in >> 1; // shift 1
			2'b10 : assign srl_stg1 = Shift_in >> 2; // shift 2
			2'b11 : assign srl_stg1 = Shift_in >> 3; // shift 3
		endcase
	end 

	always@(*) begin
		case (srl_Shift_val[3:2])
			2'b00 : assign srl_stg2 = srl_stg1; // shift 0
			2'b01 : assign srl_stg2 = srl_stg1 >> 4; // shift 1
			2'b10 : assign srl_stg2 = srl_stg1 >> 8; // shift 2
			2'b11 : assign srl_out = srl_stg1 >> 12; // shift 3
		endcase
	end

	assign ror_out = sll_out | srl_out;

	// Choose SRA or SLL based on mode
	always@(*) begin
		case (Mode)
			2'b00: assign Shift_out = sra_out;
			2'b01: assign Shift_out = sll_out;
			2'b10: assign Shift_out = ror_out;
			2'b11: assign Shift_out = 16'h00; // don't want to trigger error here
			default: $error("Error: opcode invalid!");
		endcase
	end

endmodule