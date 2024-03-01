module PADDSB(rs, rt, rd);

    input [15:0] rs, rt;
    output [15:0] rd;

    wire [3:0] Sum_1, Sum_2, Sum_3, Sum_4;  // intermediate sum values
    wire [3:0] C;   // carry-out
    wire [3:0] overflow_pos, overflow_neg;

    ///////////////////////////////////////////////
    // Instantiate carry lookahead adder 4 times //
    ///////////////////////////////////////////////
    CLA add3_0(.A(rs[3:0]), .B(rt[3:0]), .Cin(1'b0), .S(Sum_1), .Cout(C[0]));
    CLA add7_4(.A(rs[7:4]), .B(rt[7:4]), .Cin(1'b0), .S(Sum_2), .Cout(C[1]));
    CLA add11_8(.A(rs[11:8]), .B(rt[11:8]), .Cin(1'b0), .S(Sum_3), .Cout(C[2]));
    CLA add15_12(.A(rs[15:12]), .B(rt[15:12]), .Cin(1'b0), .S(Sum_4), .Cout(C[3]));

    //////////////////////////////
    // Calculate overflow flags //
    //////////////////////////////
    assign overflow_pos[0] = (Sum_1[3] & C[0]);
    assign overflow_pos[1] = (Sum_2[3] & C[1]);
    assign overflow_pos[2] = (Sum_3[3] & C[2]);
    assign overflow_pos[3] = (Sum_4[3] & C[3]);
    assign overflow_neg[0] = (~Sum_1[3] & ~C[0]);
    assign overflow_neg[1] = (~Sum_2[3] & ~C[1]);
    assign overflow_neg[2] = (~Sum_3[3] & ~C[2]);
    assign overflow_neg[3] = (~Sum_4[3] & ~C[3]);

    //////////////////////
    // saturation logic //
    //////////////////////
    assign rd[3:0] = (Overflow_Pos[0]) ? 7 : 
                        (Overflow_Neg[0]) ? -8 : 
                        Sum_1[3:0];
    assign rd[7:4] = (Overflow_Pos[1]) ? 7 : 
                        (Overflow_Neg[1]) ? -8 :
                        Sum_2[3:0];
    assign rd[11:8] = (Overflow_Pos[2]) ? 7 : 
                        (Overflow_Neg[2]) ? -8 : 
                        Sum_3[3:0];
    assign rd[15:12] = (Overflow_Pos[3]) ? 7 : 
                            (Overflow_Neg[3]) ? -8 : 
                            Sum_4[3:0];


endmodule