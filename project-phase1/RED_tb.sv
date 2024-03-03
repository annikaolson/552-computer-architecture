module red_tb();

	logic [15:0] rs, rt, rd;

	RED iDUT(.rs(rs), .rt(rt), .rd(rd));

	initial begin
		// should be 3fc, sign extended to FFFC
		assign rs = 16'hFFFF;
		assign rt = 16'hFFFF;
		#50
		// should be 48
		assign rs = 16'h0101;
		assign rt = 16'h1234;
		#50
		$stop();
	end

endmodule