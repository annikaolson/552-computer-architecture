module PADDSB(rs, rt, rd);
    input [15:0] rs, rt;
    output [15:0] rd;

    wire [3:0] Sum_1, Sum_2, Sum_3, Sum_4;  // intermediate sum values
    wire [3:0] C;   // carry-out
    wire [3:0] overflow_pos, overflow_neg;

    ///////////////////////////////////////////////
    // Instantiate carry lookahead adder 4 times //
    ///////////////////////////////////////////////
    CLA_4bit add3_0(.A(rs[3:0]), .B(rt[3:0]), .Cin(1'b0), .S(Sum_1), .Cout(C[0]));
    CLA_4bit add7_4(.A(rs[7:4]), .B(rt[7:4]), .Cin(1'b0), .S(Sum_2), .Cout(C[1]));
    CLA_4bit add11_8(.A(rs[11:8]), .B(rt[11:8]), .Cin(1'b0), .S(Sum_3), .Cout(C[2]));
    CLA_4bit add15_12(.A(rs[15:12]), .B(rt[15:12]), .Cin(1'b0), .S(Sum_4), .Cout(C[3]));

    //////////////////////////////
    // Calculate overflow flags //
    //////////////////////////////
    assign overflow_pos[0] = (Sum_1[3] & ~rs[3] & ~rt[3]);
    assign overflow_pos[1] = (Sum_2[3] & ~rs[7] & ~rt[7]);
    assign overflow_pos[2] = (Sum_3[3] & ~rs[11] & ~rt[11]);
    assign overflow_pos[3] = (Sum_4[3] & ~rs[15] & ~rt[15]);

    assign overflow_neg[0] = (~Sum_1[3] & rs[3] & rt[3]);
    assign overflow_neg[1] = (~Sum_2[3] & rs[7] & rt[7]);
    assign overflow_neg[2] = (~Sum_3[3] & rs[11] & rt[11]);
    assign overflow_neg[3] = (~Sum_4[3] & rs[15] & rt[15]);

    //////////////////////
    // saturation logic //
    //////////////////////
    assign rd[3:0] = (overflow_pos[0]) ? 4'b0111 : 
                        (overflow_neg[0]) ? 4'b1000 : 
                        Sum_1[3:0];
    assign rd[7:4] = (overflow_pos[1]) ? 4'b0111 : 
                        (overflow_neg[1]) ? 4'b1000 :
                        Sum_2[3:0];
    assign rd[11:8] = (overflow_pos[2]) ? 4'b0111 : 
                        (overflow_neg[2]) ? 4'b1000 : 
                        Sum_3[3:0];
    assign rd[15:12] = (overflow_pos[3]) ? 4'b0111 : 
                            (overflow_neg[3]) ? 4'b1000 : 
                            Sum_4[3:0];

endmodule