module RegisterFile(input clk, input rst, input [3:0] SrcReg1, input [3:0] SrcReg2, input [3:0]
DstReg, input WriteReg, input [15:0] DstData, inout [15:0] SrcData1, inout [15:0] SrcData2);

////////////////////////////
// Intermediate Variables //
////////////////////////////
wire [15:0] ReadEnable1;
wire [15:0] ReadEnable2;
wire [15:0] WriteEnable;
wire [15:0] out_SrcData1, out_SrcData2;

/////////////////////////////////////////
// Instantiate Read and Write Decoders //
/////////////////////////////////////////
ReadDecoder_4_16 readDecoder1(.RegId(SrcReg1), .Wordline(ReadEnable1));
ReadDecoder_4_16 readDecoder2(.RegId(SrcReg2), .Wordline(ReadEnable2));
WriteDecoder_4_16 writeDecoder(.RegId(DstReg), .WriteReg(WriteReg), .Wordline(WriteEnable));

///////////////////////////
// Instantiate Registers //
///////////////////////////
Register register_0(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[0]), .ReadEnable1(ReadEnable1[0]),
		    .ReadEnable2(ReadEnable2[0]), .Bitline1(out_SrcData1), .Bitline2(out_SrcData2));

Register register_1(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[1]), .ReadEnable1(ReadEnable1[1]),
		    .ReadEnable2(ReadEnable2[1]), .Bitline1(out_SrcData1), .Bitline2(out_SrcData2));

Register register_2(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[2]), .ReadEnable1(ReadEnable1[2]),
		    .ReadEnable2(ReadEnable2[2]), .Bitline1(out_SrcData1), .Bitline2(out_SrcData2));

Register register_3(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[3]), .ReadEnable1(ReadEnable1[3]),
		    .ReadEnable2(ReadEnable2[3]), .Bitline1(out_SrcData1), .Bitline2(out_SrcData2));

Register register_4(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[4]), .ReadEnable1(ReadEnable1[4]),
		    .ReadEnable2(ReadEnable2[4]), .Bitline1(out_SrcData1), .Bitline2(out_SrcData2));

Register register_5(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[5]), .ReadEnable1(ReadEnable1[5]),
		    .ReadEnable2(ReadEnable2[5]), .Bitline1(out_SrcData1), .Bitline2(out_SrcData2));

Register register_6(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[6]), .ReadEnable1(ReadEnable1[6]),
		    .ReadEnable2(ReadEnable2[6]), .Bitline1(out_SrcData1), .Bitline2(out_SrcData2));

Register register_7(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[7]), .ReadEnable1(ReadEnable1[7]),
		    .ReadEnable2(ReadEnable2[7]), .Bitline1(out_SrcData1), .Bitline2(out_SrcData2));

Register register_8(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[8]), .ReadEnable1(ReadEnable1[8]),
		    .ReadEnable2(ReadEnable2[8]), .Bitline1(out_SrcData1), .Bitline2(out_SrcData2));

Register register_9(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[9]), .ReadEnable1(ReadEnable1[9]),
		    .ReadEnable2(ReadEnable2[9]), .Bitline1(out_SrcData1), .Bitline2(out_SrcData2));

Register register_10(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[10]), .ReadEnable1(ReadEnable1[10]),
		    .ReadEnable2(ReadEnable2[10]), .Bitline1(out_SrcData1), .Bitline2(out_SrcData2));

Register register_11(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[11]), .ReadEnable1(ReadEnable1[11]),
		    .ReadEnable2(ReadEnable2[11]), .Bitline1(out_SrcData1), .Bitline2(out_SrcData2));

Register register_12(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[12]), .ReadEnable1(ReadEnable1[12]),
		    .ReadEnable2(ReadEnable2[12]), .Bitline1(out_SrcData1), .Bitline2(out_SrcData2));

Register register_13(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[13]), .ReadEnable1(ReadEnable1[13]),
		    .ReadEnable2(ReadEnable2[13]), .Bitline1(out_SrcData1), .Bitline2(out_SrcData2));

Register register_14(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[14]), .ReadEnable1(ReadEnable1[14]),
		    .ReadEnable2(ReadEnable2[14]), .Bitline1(out_SrcData1), .Bitline2(out_SrcData2));

Register register_15(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[15]), .ReadEnable1(ReadEnable1[15]),
		    .ReadEnable2(ReadEnable2[15]), .Bitline1(out_SrcData1), .Bitline2(out_SrcData2));

/////////////////////////////////////////////////////////////////////////////
// Bypassing Logic: Connect written data directly to SrcData1 and SrcData2 //
/////////////////////////////////////////////////////////////////////////////
assign SrcData1 = WriteReg ? DstData : out_SrcData1;
assign SrcData2 = WriteReg ? DstData : out_SrcData2;

endmodule
