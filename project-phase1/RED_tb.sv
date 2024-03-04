module red_tb();

	logic [15:0] rs, rt, rd;

	RED iDUT(.rs(rs), .rt(rt), .rd(rd));

	initial begin
		// should be 3fc, sign extended to FFFC
		assign rs = 16'hFFFF;
		assign rt = 16'hFFFF;
		#10
		// should be 48
		assign rs = 16'h0101;
		assign rt = 16'h1234;
		#10
		// should be 00FE
		assign rs = 16'h007F;
		assign rt = 16'h7F00;
		#10
		// should be FFC8
		assign rs = 16'hE300;
		assign rt = 16'h00E5;
		#10
		// should be FFF1
		assign rs = 16'hFF00;
		assign rt = 16'hF200;
		#10
		$stop();
	end

endmodule