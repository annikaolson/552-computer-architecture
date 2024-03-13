module flag_reg (input clk, input rst, input [3:0] opcode, input Z, input N, input V, output [2:0] flag);

////////////////////////////
// Intermediate variables //
////////////////////////////
wire Z_en, ZVN_en;

//////////////////
// Enable logic //
//////////////////
assign ZVN_en = (opcode == 4'b0000) | (opcode == 4'b0001);

assign Z_en = ZVN_en | (opcode == 4'b0010) | (opcode[3:1] == 3'b010) | (opcode == 4'b0110);


//////////////////
// D-Flip flops //
//////////////////
dff DFF_Z(.q(flag[2]), .d(Z), .wen(Z_en), .clk(clk), .rst(rst));
dff DFF_V(.q(flag[1]), .d(V), .wen(ZVN_en), .clk(clk), .rst(rst));
dff DFF_N(.q(flag[0]), .d(N), .wen(ZVN_en), .clk(clk), .rst(rst));

endmodule
