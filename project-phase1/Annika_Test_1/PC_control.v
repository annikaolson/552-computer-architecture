module PC_control(input [2:0] C, input [8:0] I, input [2:0] F, input [15:0] PC_in, input [15:0] rs_data, input [3:0] opcode, output [15:0] PC_out);
    ////////////////////////////
    // Intermediate Variables //
    ////////////////////////////
    wire [15:0] branch_imm_sign_ext;
    wire [15:0] branch_imm;
    wire [15:0] new_pc, b_pc, br_pc;
    wire Z_flag, V_flag, N_flag;
    reg Branch;

    wire error;

    // C: 3-bit condition
    // I: 9-bit signed offset in 2's complement, right shifted by one
    // Target = PC + 2 _ ('I' << 1)
    // F: flag register, {Z, V, N}
    assign branch_imm_sign_ext = {{7{I[8]}}, I}; // sign extend immediate
    assign branch_imm = branch_imm_sign_ext << 1; // shift sign extended immediate left by one

    CLA_16bit cla_b_pc(.A(PC_in), .B(16'h0002), .S(new_pc), .Cout(cout), .Sub(1'b0), .Ovfl(error)); // calculate new pc (pc + 2)
    CLA_16bit cla_branch(.A(new_pc), .B(branch_imm), .S(b_pc), .Cout(cout), .Sub(1'b0), .Ovfl(error));  // calculate new branch addr (imm << 1 + pc + 2)

    assign Z_flag = F[2]; // done for readability
    assign V_flag = F[1];
    assign N_flag = F[0];

    always@(*) begin
		case (C)
            3'b000 : assign Branch = !Z_flag; // Not equal, Z = 0
            3'b001 : assign Branch = Z_flag; // Equal, Z = 1
            3'b010 : assign Branch = !(Z_flag|N_flag); // Greater than, Z = N = 0
            3'b011 : assign Branch = N_flag; // Less than, N = 1
            3'b100 : assign Branch = (Z_flag|(!(Z_flag|N_flag))); // Greater than or equal, Z = 1 or Z = N = 0
            3'b101 : assign Branch = N_flag|Z_flag; // Less than or equal, N = 1 or Z = 1
            3'b110 : assign Branch = V_flag; // Overflow, V = 1
            3'b111 : assign Branch = 1'b1; // Unconditional
            default: ; // to do, will need to add to any other case statements
        endcase
    end

    assign PC_out = (Branch & opcode == 4'b1100) ? b_pc :
                     (Branch & opcode == 4'b1101) ? rs_data : new_pc;

endmodule