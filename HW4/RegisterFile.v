module RegisterFile(clk, rst, SrcReg1, SrcReg2, DstReg, WriteReg, DstData, SrcData1, SrcData2);

	// INPUTS AND OUTPUTS
	input clk, rst;
	input [3:0] SrcReg1, SrcReg2, DstReg;
	input WriteReg;
	input [15:0] DstData;
	inout [15:0] SrcData1, SrcData2;

	// Intermediate variables
	wire [15:0] ReadEnable1, ReadEnable2, WriteEnable;

	// Read and write decoders
	ReadDecoder_4_16 readDecoder1(.RegId(DstReg), .Wordline(ReadEnable1));
	ReadDecoder_4_16 readDecoder2(.RegId(DstReg), .Wordline(ReadEnable2));
	WriteDecoder_4_16 writeDecoder(.RegId(DstReg), .WriteReg(WriteReg), .Wordline(WriteEnable));

	// Register instantiation
	Register Registers[15:0](.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteReg), .ReadEnable1(SrcReg1), .ReadEnable2(SrcReg2), .Bitline1(SrcData1), .Bitline2(SrcData2));

endmodule
