module RED(A, B, Sum);

    //////////////////////////////////////////////////////////////////
    // reduction unit (RED): performs reduction on 4 byte-size      //
    // operands (i.e. 2 bytes each from 2 registers)                //
    // e.g. rs = aaaaaaaa_bbbbbbbb; rt = cccccccc_dddddddd          //
    // (signext) ((aaaaaaaa + cccccccc) + (bbbbbbbb + ddddddddd))   //
    // will be in rd after the RED operation.                       //
    //////////////////////////////////////////////////////////////////

    input [15:0] A, B;
    output reg [15:0] Sum;

    wire [7:0] A_lower, A_upper, B_lower, B_upper;
    wire [7:0] SumAB, SumCD;

    //////////////////////////////////////////////
    // get lower and upper bits of each operand //
    //////////////////////////////////////////////
    assign A_lower = A[7:0];
    assign A_upper = A[15:8];
    assign B_lower = A[7:0];
    assign B_upper = A[15:8];

    //////////////////////////////////////////////////////////////////
    // instantiate CLAs to add the lower and upper bits separately  //
    //////////////////////////////////////////////////////////////////

    /////////////////////////////////////////////////////////////////////
    // instantiate CLAs to add the sum of the lower and upper bit sums //
    /////////////////////////////////////////////////////////////////////

    


endmodule