module CLA_16bit(A, B, S, Cout, Sub);
    input [15:0] A, B;
    input Sub;
    output [15:0] S;
    output Cout;

    wire [4:0] C;
    wire overflow_pos, overflow_neg;
    wire [15:0] new_B;

    assign new_B = Sub ? ~B : B;

    CLA_4bit add3_0(.A(A[3:0]), .B(new_B[3:0]), .Cin(Sub), .S(S[3:0]), .Cout(C[1]));
    CLA_4bit add7_4(.A(A[7:4]), .B(new_B[7:4]), .Cin(C[1]), .S(S[7:4]), .Cout(C[2]));
    CLA_4bit add11_8(.A(A[11:8]), .B(new_B[11:8]), .Cin(C[2]), .S(S[11:8]), .Cout(C[3]));
    CLA_4bit add15_12(.A(A[15:12]), .B(new_B[15:12]), .Cin(C[3]), .S(S[15:12]), .Cout(Cout));

    //////////////////////////////////////////////////////////////////
    // saturation: if there is overflow, then the sum should be     //
    // saturated - if the result is more positive than the most     //
    // positive number (2^15 - 1), then the result should be        //
    // saturated to (2^15 - 1); if the result is smaller than the   //
    // most negative number (-2^15), then the result should be      //
    // saturated to (-2^15).                                        //
    // this should be done on 16 bits, so the logic will not be in  //
    // the CLA_4bit.v. it should be done once we get the 16-bit     //
    // result.                                                      //
    //////////////////////////////////////////////////////////////////
    assign overflow_pos = (Cout & S[15]) | (~Cout & ~S[15] & (A[15] ^ B[15] ^ S[15]));
    assign overflow_neg = (Cout & ~S[15]) | (~Cout & S[15] & (A[15] ^ B[15] ^ S[15]));

    assign S = overflow_pos ? 16'h7FFF :
                overflow_neg ? 16'h8000 :
                S;

endmodule