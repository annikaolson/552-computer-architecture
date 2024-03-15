module ALU(A, B, imm, ALU_Out, Z, N, V, Opcode);
	input  [15:0] A, B;
	input  [3:0] Opcode;
	input  [3:0] imm;				
	output reg [15:0] ALU_Out;
	output Z, N, V;

	////////////////////////////sub
	// Intermediate Variables //
	////////////////////////////
	wire [15:0] ADDSUB_out;
	wire [15:0] RED_out;
	wire [15:0] SHIFT_out;
	wire [15:0] PADDSB_out;
	wire [15:0] MEM_Addr;
	wire Error, cout;
	reg Z_temp, N_temp, V_temp;

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
	CLA_16bit cla_addsub(.A(A), .B(B), .S(ADDSUB_out), .Cout(cout), .Sub(Opcode[0]), .Ovfl(Error));
	

	//////////////////////////////////////////////////////
	// CLA for calculating the memory address to access	//
	//////////////////////////////////////////////////////
	CLA_16bit cla_memaddr(.A(A & 16'hFFFE), .B(B), .S(MEM_Addr), .Cout(cout), .Sub(1'b0), .Ovfl(Error));

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
		case (Opcode[3:0])
			4'b0000	: 	begin assign ALU_Out = ADDSUB_out; // ADD: N, Z, V
						assign N_temp = ALU_Out[15]; assign Z_temp = (ALU_Out == 0); assign V_temp = Error; end	// set flags

			4'b0001 : 	begin assign ALU_Out = ADDSUB_out; // SUB: N, Z, V
						assign N_temp = ALU_Out[15]; assign Z_temp = (ALU_Out == 0); assign V_temp = Error; end	// set flags

			4'b0010 : 	begin assign ALU_Out = (A ^ B); // XOR; Z
						assign Z_temp = (ALU_Out == 0); end	// set flags

			4'b0011 : 	begin assign ALU_Out = RED_out; end	// RED

			4'b0100 : 	begin assign ALU_Out = SHIFT_out; // SLL; Z
						assign Z_temp = (ALU_Out == 0); end

			4'b0101 : 	begin assign ALU_Out = SHIFT_out; // SRA; Z
						assign Z_temp = (ALU_Out == 0); end

			4'b0111 :	begin assign ALU_Out = PADDSB_out; end	// PADDSB

			4'b1000 : 	begin assign ALU_Out = MEM_Addr; end	// LW

			4'b1001 : 	begin assign ALU_Out = MEM_Addr; end	// SW

			default : 	$error("Opcode not used in ALU");
		endcase
	end

	assign N = N_temp;
	assign Z = Z_temp; 
	assign V = V_temp;
endmodule