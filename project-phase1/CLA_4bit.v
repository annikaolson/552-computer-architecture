//4-bit carry lookahead adder
module CLA_4bit(A, B, Cin, S, Cout);

    input [3:0] A, B;
    input Cin;
    output [3:0] S;
    output Cout;

    wire [3:0] P, G;    // propagation and generation logic
    wire [4:0] C;       // carry logic

    // level 1
    assign P = A ^ B;
    assign G = A & B;

    // second level
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & Cin);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | 
            (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & Cin);

    // third level
    assign S = P ^ C[3:0];
    assign Cout = C[4];

endmodule