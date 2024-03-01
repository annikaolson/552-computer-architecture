module ALU(A, B, rd, imm, ALU_Out, Z, N, V, Opcode);
	input  [15:0] A, B;
	input  [3:0] Opcode;
	input  [3:0] imm;					
	output reg [15:0] ALU_Out;
	output reg [15:0] rd;
	output reg Z, N, V;

	////////////////////////////
	// Intermediate Variables //
	////////////////////////////
	wire [15:0] ADDSUB_out;
	wire [15:0] RED_out;
	wire [15:0] SHIFT_out;
	wire [15:0] PADDSB_out;

	////////////////////////////////////
	// Instantiate compute components //
	////////////////////////////////////

	//////////////////////////////////////////////////////////
	// PADDSB: adds two 16-bit inputs in 4-bit sub-words,	//
	// saturating each subword and concatenating for the	//
	// final result.										//
	//////////////////////////////////////////////////////////
	PADDSB paddsb(.rs(A), .rt(B), .rd(PADDSB_out));

	////////////////////////
	// Add: Opcode[0] = 0 //
	// Sub: Opcode[0] = 1 //
	////////////////////////
	CLA_16bit cla(.A(A), .B(B ^ Opcode[0]), .Cin(1'b0), .S(ADDSUB_out), .Cout(), .Error(Error));

	/////////////////////////////////////////////////////
	// RED: performs reduction on 4 byte-size operands //
	/////////////////////////////////////////////////////
	RED red(.rs(A), .rt(B), .rd(RED_out));

	///////////////////////////
	// SLL: Opcode[1:0] = 00 //
	// SRA: Opcode[1:0] = 01 //
	// ROR: Opcode[1:0] = 10 //
	///////////////////////////
	Shifter shift(.Shift_out(SHIFT_out), .Shift_in(A), .Shift_val(imm), .Mode(Opcode[1:0]));

	/////////////////////////////////////////////////////////////////////////////
	// ALU : ALU_Out and flag calculations  								   //
	// All compute subcomponent connected to a MUX; opcode is selection signal //
	/////////////////////////////////////////////////////////////////////////////
	always@(*) begin
		case (Opcode[2:0])
			4'b000	: 	begin assign ALU_Out = ADDSUB_out; // ADD: N, Z, V
						assign N = ALU_Out[15]; assign Z = (ALU_Out == 0); V = Error; end	// set flags

			4'b001 : 	begin assign ALU_Out = ADDSUB_out; // SUB: N, Z, V
						assign N = ALU_Out[15]; assign Z = (ALU_Out == 0); V = Error; end	// set flags

			4'b010 : 	begin assign ALU_Out = (A ^ B); // XOR; Z
						assign Z = (ALU_Out == 0); end	// set flags

			4'b011 : 	assign ALU_Out = RED_out; // RED

			4'b100 : 	begin assign ALU_Out = SHIFT_out; // SLL; Z
						assign Z = (ALU_Out == 0); end

			4'b101 : 	begin assign ALU_Out = SHIFT_out; // SRA; Z
						assign Z = (ALU_Out == 0); end

			4'b110 : 	begin assign ALU_Out = SHIFT_out; // ROR; Z
						assign Z = (ALU_Out == 0); end

			4'b111 :	assign ALU_Out = PADDSB_out;	// PADDSB: no flags

			default : $error("Error: opcode invalid!");
		endcase
	end

endmodule