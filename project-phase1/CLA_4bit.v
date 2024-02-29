//4-bit carry lookahead adder
module CLA_4bit(A, B, cin, S, cout);

    input [3:0] A, B;
    input cin;
    output [3:0] S;
    output cout;

    wire [3:0] P, G;    // propagation and generation logic
    wire [4:0] C;       // carry logic

    // level 1
    assign P = A ^ B;
    assign G = A & B;

    // second level
    assign C[0] = cin;
    assign C[1] = G[0] | (P[0] & cin);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & cin);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & cin);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | 
            (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & cin);

    // third level
    assign S = P ^ C[3:0];
    assign cout = C[4];

    // IMPLEMENT SATURATION... SHOULD THIS BE MORE THAN 4 BITS?

endmodule