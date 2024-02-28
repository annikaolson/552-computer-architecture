module ALU(ALU_Out, Error, ALU_In1, ALU_In2, Opcode);

	input  [3:0] ALU_In1, ALU_In2;
	input  [1:0] Opcode;
	output reg [3:0] ALU_Out;
	output Error;	// to show overflow

	// instantiate compute components
	wire [3:0] ADDSUB_sum;
	addsub_4bit ADDSUB(.Sum(ADDSUB_sum), .Ovfl(Error), .A(ALU_In1), .B(ALU_In2), .sub(Opcode[0]));

	// all compute subcomponent connected to a MUX; opcode is selection signal
	always@(*) begin
		case (Opcode)
			2'h0: ALU_Out = ADDSUB_sum;
			2'h1: ALU_Out = ADDSUB_sum;
			2'h2: ALU_Out = ~(ALU_In1 & ALU_In2);
			2'h3: ALU_Out = (ALU_In1 ^ ALU_In2);
			default : $display("Error: opcode invalid!");
		endcase
	end


endmodule
