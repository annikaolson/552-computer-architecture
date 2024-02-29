module ALU(rd, rs, rt, imm, ALU_Out, Z, N, V);
	input  [15:0] rs, rt;
	input  [3:0] Opcode;
	input  [3:0] imm;					// NOTE: imm might not need to be an input, we may be able to get it in here
	output reg [15:0] ALU_out;
	output reg [15:0] rd;
	output Z, N, V;

	////////////////////////////
	// Intermediate Variables //
	////////////////////////////
	wire [15:0] ADDSUB_out;
	wire [15:0] RED_out;
	wire [15:0] SHIFT_out;

	////////////////////////////////////
	// Instantiate compute components //
	////////////////////////////////////

	////////////////////////
	// Add: Opcode[0] = 0 //
	// Sub: Opcode[0] = 1 //
	////////////////////////
	// ADDSUB(.Sum(ADDSUB_out), .Ovfl(Error), .A(rs), .B(rt), .sub(Opcode[0]));
	// Have CLA do add and sub w/ saturation?

	/////////////////////////////////////////////////////
	// RED: performs reduction on 4 byte-size operands //
	/////////////////////////////////////////////////////
	RED red(.rs(rs), .rt(rt), .rd(RED_out));

	///////////////////////////
	// SLL: Opcode[1:0] = 00 //
	// SRA: Opcode[1:0] = 01 //
	// ROR: Opcode[1:0] = 10 //
	///////////////////////////
	Shifter shift(.Shift_out(SHIFT_out), .Shift_in(rs), .Shift_val(imm), .Mode(Opcode[1:0]));

	/////////////////////////////////////////////////////////////////////////////
	// ALU : ALU_Out and flag calculations  								   //
	// All compute subcomponent connected to a MUX; opcode is selection signal //
	/////////////////////////////////////////////////////////////////////////////
	always@(*) begin
		case (Opcode)
			4'b0000	: 	begin assign ALU_Out = ADDSUB_out; // ADD: N, Z, V
						assign N = ALU_Out[15]; assign Z = (ALU_Out == 0); V = Error; end	// set flags

			4'b0001 : 	begin assign ALU_Out = ADDSUB_sum; // SUB: N, Z, V
						assign N = ALU_Out[15]; assign Z = (ALU_Out == 0); V = Error; end	// set flags

			4'b0010 : 	begin assign ALU_Out = (ALU_In1 ^ ALU_In2); // XOR; Z
						assign Z = (ALU_Out == 0); end	// set flags

			4'b0011 : 	assign ALU_Out = RED_out; // RED

			4'b0100 : 	begin ALU_Out = SHIFT_out; // SLL; Z
						Z = (ALU_Out == 0); end

			4'b0101 : 	begin ALU_Out = SHIFT_out; // SRA; Z
						Z = (ALU_Out == 0); end

			4'b0110 : 	begin ALU_Out = SHIFT_out; // ROR; Z
						Z = (ALU_Out == 0); end

			4'b0111 : ; // PADDSB

			4'b1000 : ; // LW

			4'b1001 : ; // SW

			4'b1010 : ; // LLB

			4'b1011 : ; // LHB

			4'b1100 : ; // B

			4'b1101 : ; // BR

			4'b1110 : ; // PCS

			4'b1111 : ; // HLT

			default : $error("Error: opcode invalid!");
		endcase
	end

endmodule
