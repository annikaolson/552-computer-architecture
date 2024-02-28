module RegisterFile(clk, rst, SrcReg1, SrcReg2, DstReg, WriteReg, DstData, SrcData1, SrcData2);

	// INPUTS AND OUTPUTS
	input clk, rst;
	input [3:0] SrcReg1, SrcReg2, DstReg;
	input WriteReg;
	input [15:0] DstData;
	inout [15:0] SrcData1, SrcData2;

	// Intermediate variables
	wire [15:0] ReadWordline1, ReadWordline2, WriteWordline;

	// Read and write decoders
	ReadDecoder_4_16 readDecoder1(.RegId(SrcReg1), .Wordline(ReadWordline1));
	ReadDecoder_4_16 readDecoder2(.RegId(SrcReg2), .Wordline(ReadWordline2));
	WriteDecoder_4_16 writeDecoder(.RegId(DstReg), .WriteReg(WriteReg), .Wordline(WriteWordline));

	// Register instantiation
	Register Register0(.clk(clk), .rst(rst), .D(DstData[0]), .WriteReg(WriteReg), .ReadEnable1(ReadWordline1[0]), .ReadEnable2(ReadWordline2[0]), .Bitline1(SrcData1), .Bitline2(SrcData2));
	Register Register1(.clk(clk), .rst(rst), .D(DstData[1]), .WriteReg(WriteReg), .ReadEnable1(ReadWordline1[1]), .ReadEnable2(ReadWordline2[1]), .Bitline1(SrcData1), .Bitline2(SrcData2));
	Register Register2(.clk(clk), .rst(rst), .D(DstData[2]), .WriteReg(WriteReg), .ReadEnable1(ReadWordline1[2]), .ReadEnable2(ReadWordline2[2]), .Bitline1(SrcData1), .Bitline2(SrcData2));
	Register Register3(.clk(clk), .rst(rst), .D(DstData[3]), .WriteReg(WriteReg), .ReadEnable1(ReadWordline1[3]), .ReadEnable2(ReadWordline2[3]), .Bitline1(SrcData1), .Bitline2(SrcData2));
	Register Register4(.clk(clk), .rst(rst), .D(DstData[4]), .WriteReg(WriteReg), .ReadEnable1(ReadWordline1[4]), .ReadEnable2(ReadWordline2[4]), .Bitline1(SrcData1), .Bitline2(SrcData2));
	Register Register5(.clk(clk), .rst(rst), .D(DstData[5]), .WriteReg(WriteReg), .ReadEnable1(ReadWordline1[5]), .ReadEnable2(ReadWordline2[5]), .Bitline1(SrcData1), .Bitline2(SrcData2));
	Register Register6(.clk(clk), .rst(rst), .D(DstData[6]), .WriteReg(WriteReg), .ReadEnable1(ReadWordline1[6]), .ReadEnable2(ReadWordline2[6]), .Bitline1(SrcData1), .Bitline2(SrcData2));
	Register Register7(.clk(clk), .rst(rst), .D(DstData[7]), .WriteReg(WriteReg), .ReadEnable1(ReadWordline1[7]), .ReadEnable2(ReadWordline2[7]), .Bitline1(SrcData1), .Bitline2(SrcData2));
	Register Register8(.clk(clk), .rst(rst), .D(DstData[8]), .WriteReg(WriteReg), .ReadEnable1(ReadWordline1[8]), .ReadEnable2(ReadWordline2[8]), .Bitline1(SrcData1), .Bitline2(SrcData2));
	Register Register9(.clk(clk), .rst(rst), .D(DstData[9]), .WriteReg(WriteReg), .ReadEnable1(ReadWordline1[9]), .ReadEnable2(ReadWordline2[9]), .Bitline1(SrcData1), .Bitline2(SrcData2));
	Register Register10(.clk(clk), .rst(rst), .D(DstData[10]), .WriteReg(WriteReg), .ReadEnable1(ReadWordline1[10]), .ReadEnable2(ReadWordline2[10]), .Bitline1(SrcData1), .Bitline2(SrcData2));
	Register Register11(.clk(clk), .rst(rst), .D(DstData[11]), .WriteReg(WriteReg), .ReadEnable1(ReadWordline1[11]), .ReadEnable2(ReadWordline2[11]), .Bitline1(SrcData1), .Bitline2(SrcData2));
	Register Register12(.clk(clk), .rst(rst), .D(DstData[12]), .WriteReg(WriteReg), .ReadEnable1(ReadWordline1[12]), .ReadEnable2(ReadWordline2[12]), .Bitline1(SrcData1), .Bitline2(SrcData2));
	Register Register13(.clk(clk), .rst(rst), .D(DstData[13]), .WriteReg(WriteReg), .ReadEnable1(ReadWordline1[13]), .ReadEnable2(ReadWordline2[13]), .Bitline1(SrcData1), .Bitline2(SrcData2));
	Register Register14(.clk(clk), .rst(rst), .D(DstData[14]), .WriteReg(WriteReg), .ReadEnable1(ReadWordline1[14]), .ReadEnable2(ReadWordline2[14]), .Bitline1(SrcData1), .Bitline2(SrcData2));
	Register Register15(.clk(clk), .rst(rst), .D(DstData[15]), .WriteReg(WriteReg), .ReadEnable1(ReadWordline1[15]), .ReadEnable2(ReadWordline2[15]), .Bitline1(SrcData1), .Bitline2(SrcData2));

	// RF bypassing by connecting the written-to data to the source data
	assign SrcData1 = WriteReg ? DstData : SrcData1;
	assign SrcData2 = WriteReg ? DstData : SrcData2;


endmodule
