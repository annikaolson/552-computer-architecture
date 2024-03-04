module paddsb_tb();

	logic [15:0] rs, rt, rd;
	PADDSB iDUT(.rs(rs), .rt(rt), .rd(rd));

	initial begin
		// sat, should be 6777
		assign rs = 16'h2456;
		assign rt = 16'h4731;
		#10
		// no sat, should be 6667
		assign rs = 16'h2456;
		assign rt = 16'h4211;
		#10
		// neg saturation on lowest 4, should be 2228
		assign rs = 16'h1118;
		assign rt = 16'h1118;
		#10
		// neg saturation on lower 2 bytes, should be 2288
		assign rs = 16'h1188;
		assign rt = 16'h1188;
		#10
		// neg saturation on lowest 3, should be 2888
		assign rs = 16'h1888;
		assign rt = 16'h1888;
		#10
		// neg saturation on all, should be 8888
		assign rs = 16'h8888;
		assign rt = 16'h8888;
		#10
		// pos saturation on lowest 4, should be 2227
		assign rs = 16'h1117;
		assign rt = 16'h1116;
		#10
		// pos saturation on lowest 2, should be 2277
		assign rs = 16'h1176;
		assign rt = 16'h1157;
		#10
		// pos saturation on lowest 3, should be 2777
		assign rs = 16'h1676;
		assign rt = 16'h1657;
		#10
		// pos saturation on all, should be 7777
		assign rs = 16'h7776;
		assign rt = 16'h7757;
		#10
		$stop();
	end

endmodule