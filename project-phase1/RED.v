module RED(rs, rt, rd);

    //////////////////////////////////////////////////////////////////
    // reduction unit (RED): performs reduction on 4 byte-size      //
    // operands (i.e. 2 bytes each from 2 registers)                //
    // e.g. rs = aaaaaaaa_bbbbbbbb; rt = cccccccc_dddddddd          //
    // (signext) ((aaaaaaaa + cccccccc) + (bbbbbbbb + ddddddddd))   //
    // will be in rd after the RED operation.                       //
    // use a tree of 4-bit carry lookahead adders.                  //
    //////////////////////////////////////////////////////////////////

    input [15:0] rs, rt;
    output reg [15:0] rd;

    wire [7:0] rs_lower, rs_upper, rt_lower, rt_upper;
    reg [8:0] SumAB, SumCD;
    wire cout1, cout2, cout3, cout4, cout5;

    //////////////////////////////////////////////
    // get lower and upper bits of each operand //
    //////////////////////////////////////////////
    assign rs_lower = rs[7:0];
    assign rs_upper = rs[15:8];
    assign rt_lower = rt[7:0];
    assign rt_upper = rt[15:8];

    //////////////////////////////////////////////////////////////////
    // instantiate CLAs to add the lower and upper bits separately  //
    //////////////////////////////////////////////////////////////////
    CLA_4bit cla_ab1(.A(rs_lower[3:0]), .B(rs_upper[3:0]), .Cin(1'b0), .S(SumAB[3:0]), .Cout(cout1));
    CLA_4bit cla_ab2(.A(rs_lower[7:4]), .B(rs_upper[7:4]), .Cin(cout1), .S(SumAB[7:4]), .Cout(SumAB[8]));

    CLA_4bit cla_cd1(.A(rt_lower[3:0]), .B(rt_upper[3:0]), .Cin(1'b0), .S(SumCD[3:0]), .Cout(cout2));
    CLA_4bit cla_cd2(.A(rt_lower[7:4]), .B(rt_upper[7:4]), .Cin(cout2), .S(SumCD[7:4]), .Cout(SumCD[8]));

    /////////////////////////////////////////////////////////////////////
    // instantiate CLAs to add the sum of the lower and upper bit sums //
    /////////////////////////////////////////////////////////////////////
    CLA_4bit cla_sum1(.A(SumAB[3:0]), .B(SumCD[3:0]), .Cin(1'b0), .S(rd[3:0]), .Cout(cout3));
    CLA_4bit cla_sum2(.A(SumAB[7:4]), .B(SumCD[7:4]), .Cin(cout3), .S(rd[7:4]), .Cout(cout4));
    CLA_4bit cla_sum3(.A(SumAB[8]), .B(SumCD[8]), .Cin(cout4), .S(rd[11:8]), .Cout(cout5));

    //////////////////////////////////////////////////////////////////
    // sign extend the sum to a 16-bit number to be placed in rd    //
    //////////////////////////////////////////////////////////////////
    assign rd = {{6{rd[9]}}, rd[9:0]};



endmodule