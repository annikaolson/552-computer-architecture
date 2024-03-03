module cpu(clk, rst_n, hlt, pc);

    input clk, rst_n;
    output reg hlt; // when processor encounters HLT instruction it will assert this signal once it is finished processing the instrucitno prior to the HLT
    output [15:0] pc;   // PC value over the course of the program execution

    //////////////////////////////////////////////////////////////////
    // intermediate variables used throughout CPU                   //
    //////////////////////////////////////////////////////////////////
    wire [15:0] sign_ext_branch_imm; // sign-extended immediate value
    wire [15:0] branch_imm_shl_1;  // value of immediate shifted left by one
    wire [15:0] ALU_A, ALU_B; // inputs to the ALU read from registers
    wire [3:0] opcode;  // opcode of the instruction
    wire [15:0] instruction;
    wire [15:0] ALU_Out;    // output of ALU
    wire Z, N, V;   // flags: zero, sign, and overflow
    wire [3:0] read_reg_1, read_reg_2, write_reg;   // registers to write to
    wire [15:0] read_data_1, read_data_2, write_data;   // the data read from the selected registers
    reg [3:0] rd, rs, rt;  // register numbers from instruction
    wire [3:0] imm_offset;     // immediate for shifter operations, offset for LW and SW
    wire [15:0] imm_offset_sign_ext;
    wire [7:0] imm_8bit;    // 8-bit immediate for LLB and LHB
    reg [8:0] branch_offset;   // label to jump to for B instruction
    reg [2:0] branch_cond; // branch condition for B and BR
    wire [15:0] new_branch_addr;    // b_pc or br_pc
    wire [15:0] new_pc; // pc + 2
    wire [15:0] b_pc; // imm << 1 + pc + 2
    wire [15:0] br_pc; // pc + rs
    wire cout;
    wire [15:0] mem_read_data;
    wire [15:0] reg_write_data; // data to write to register
    wire [15:0] LLB_data; // LLB data
    wire [15:0] LHB_data; // LHB_data

    //////////////////////////////////////////////////////////////////
    // control signals: used as select signal for mux outputs       //
    //////////////////////////////////////////////////////////////////
    wire RegDst;    // determines the write register
    reg Branch;    // branch address is used when asserted
    wire ALUSrc;    // select the second ALU input: read data 2 or immediate
    wire RegWrite;  // whether a register is being written to or not
    wire MemWrite, MemRead; // see if memory should be read from or written to
    wire MemtoReg;  // 1 indicates a load word, in which memory access is written to a register


    //////////////////////////////////////////////////////////////////
    // reset logic: when reset is high, instructions are executed.  //
    // if reset goes low for one clock cycle, the pc is set back    //
    // to 0 to start execution at the beginning.                    //
    //////////////////////////////////////////////////////////////////
    dff pc_dff(.q(pc), .d(next_pc), .wen(!hlt), .clk(clk), .rst(rst_n));

    //////////////////////////////////////////////////////////////////
    // inst. memory: using addr, find the 16-bit inst. to decode.   //
    //                                                              //
    // decode the instruction: get the opcode, instruction type,    //
    // source, and destination registers to use for operation.      //
    //////////////////////////////////////////////////////////////////
    memory_inst instr_mem(.data_out(instruction), .data_in(16'b0), .addr(pc), .enable(1'b1), .wr(1'b0), .clk(clk), .rst(rst_n));
    assign opcode = instruction[15:12];

    //////////////////////////////////////////////////////////////////
    // register file - decode registers to write to or read from    //
    //////////////////////////////////////////////////////////////////
    assign imm_offset = instruction[3:0];

    always@(*) begin
		case (opcode)
            // ALU Operations Assignments //
            4'b0XXX :   begin assign rd = instruction[11:8]; assign rs = instruction[7:3]; assign rt = instruction[3:0]; end

            // LW and SW Assignments //
            4'b100X :   begin assign rt = instruction[11:8]; assign rs = instruction[7:3]; end

            // LLB and LHB Assignment //
            4'b101X :   assign rd = instruction[11:8];

            // B (B) Assignment //
            4'b1100 :   begin assign branch_cond = instruction[11:9]; assign branch_offset = instruction[8:0]; end

            // BR (branch register) Assignments //
            4'b1101 :   begin  assign branch_cond = instruction[11:9]; assign rs = instruction[7:3]; end

            // PCS Assignment //
            4'b1110 :   assign rd = instruction[11:8];

            // HLT Assignment //
            4'b1111 : assign hlt = 1'b1;
        endcase
    end

    //////////////////////////////////////////////////////////////////
    // sign-extend the 8-bit immediate value to 16 bits             //
    //////////////////////////////////////////////////////////////////
    assign sign_ext_branch_imm = {{7{branch_offset[8]}}, branch_offset};
    assign imm_offset_sign_ext = {{12{imm_offset[3]}}, imm_offset};

    // **NOTE:** NOT SURE IF THIS IS RIGHT.. CHECK OVER
    assign RegDst = (opcode[3:1] != 3'b100); // 0 if I-format, 1 otherwise
    assign read_reg_1 = rs; // any instruction that uses a register in the ALU uses rs
    assign read_reg_2 = rt;
    assign write_reg = RegDst ? rd : rt;    // if ALU op, choose rd, otherwise (if memory) choose rt as destination
    assign RegWrite = ~opcode[0] | (opcode == 4'b1000) | (opcode == 4'b1010) | (opcode == 4'b1011); // will need to re-write 

    // **NOTE:** if we are not writing anything this time around, should reg write be 0? then it can be used at the end when we are ready to write?
    RegisterFile rf(.clk(clk), .rst(rst_n), .SrcReg1(read_reg_1), .SrcReg2(read_reg_2), .DstReg(write_reg), .WriteReg(1'b0), .DstData(16'h0000), .SrcData1(read_data_1), .SrcData2(read_data_2));

    //////////////////////////////////////////////////////////////////
    // control instructions: B, BR, PCS, and HLT. the condition is  //
    // what notifies of what type of branch it is (i.e. bne, beq,   //
    // bgt, etc.). use the flags to determine whether the branch is //
    // taken or not taken (e.g. condition is satisfied)             //
    //                                                              //
    // 'B' conditionally jumps to the address obtained by adding    //
    // the 9-bit imm. offset (signed) to the contents of the PC + 2 //
    // target = PC + 2 + (imm. << 1)                                //
    // assembly format: B ccc, Label                                //
    // machine level: Opcode cci iiii iiii                          //
    //                                                              //
    // 'BR' conditionally jumps to address specified by rs          //
    // assembly format: BR ccc, rs                                  //
    // machine level: Opcode cccx ssss xxxx                         //
    //                                                              //
    // 'PCS' saves the contents of next PC (PCS instr. + 2) to      //
    // the register rd and increments the PC                        //
    // assembly format: PCS rd                                      //
    // machine level: Opcode dddd xxxx xxxx (where dddd is rd)      //
    //                                                              //
    // 'HLT' freezes whole machine by stopping advancement of PC    //
    // machine level: Opcode xxxx xxxx xxxx                         //
    //////////////////////////////////////////////////////////////////

    //////////////////////////////////////////////////////////////////
    // next instruction calculation: involves a shift of the        //
    // immediate value to get the branch address to add to the PC,  //
    // then a mux to select the PC + 4 or PC + branch address       //
    // (PCsrc control signal)                                       //
    //////////////////////////////////////////////////////////////////
    assign branch_imm_shl_1 = sign_ext_branch_imm << 1; // allowed to use shift w/ constants
    assign imm_offset_sign_ext = imm_offset_sign_ext << 1;

    CLA_16bit cla_b_pc(.A(pc), .B(16'h0002), .S(new_pc), .Cout(cout), .Sub(1'b0)); // calculate new pc (pc + 2)
    CLA_16bit cla_branch(.A(new_pc), .B(imm_shl_1), .S(b_pc), .Cout(cout), .Sub(1'b0));  // calculate new branch addr (imm << 1 + pc + 2)
    
    // rs data + pc //
    CLA_16bit cla_br_pc(.A(pc), .B(read_data_1), .S(br_pc), .Cout(cout), .Sub(1'b0));

    always@(*) begin
		case (branch_cond)
            3'b000 : assign Branch = (Z == 0); // Not equal, Z = 0
            3'b001 : assign Branch = (Z == 1); // Equal, Z = 1
            3'b010 : assign Branch = !(Z|N); // Greater than, Z = N = 0
            3'b011 : assign Branch = N; // Less than, N = 1
            3'b100 : assign Branch = (Z|(!(Z|N))); // Greater than or equal, Z = 1 or Z = N = 0
            3'b101 : assign Branch = N|Z; // Less than or equal, N = 1 or Z = 1
            3'b110 : assign Branch = V; // Overflow, V = 1
            3'b111 : assign Branch = 1'b1; // Unconditional
        endcase
    end

    assign next_pc = (Branch & opcode == 1100) ? b_pc :
                     (Branch & opcode == 1101) ? br_pc : new_pc;

    //////////////////////////////////////////////////////////////////
    // ALU Adder: carry lookahead adder (CLA) logic for adding.     //
    // input 1 will always be read data 1, input 2 will be chosen   //
    // via ALUSrc control signal mux that will select either read   //
    // data 2 or sign-extended immediate. can set zero flag (z),    //
    // overflow (V), or sign flag (N).                              //
    //////////////////////////////////////////////////////////////////
    assign ALUSrc = (opcode[3] == 1'b0)     ? 1'b0 :
                    (opcode[3:1] == 3'b110) ? 1'b0 : 1'b1; // 0 if R-format or branch, 1 otherwise
    assign ALU_B = ALUSrc ? imm_offset_sign_ext : read_data_2;             
    assign ALU_A = read_data_1;                                         

    ALU alu(.A(ALU_A), .B(ALU_B), .imm(imm_offset), .ALU_Out(ALU_Out), .Z(Z), .N(N), .V(V), .Opcode(opcode));

    //////////////////////////////////////////////////////////////////
    // data memory: provide a 16-bit address and 16-bit data input  //
    // (write data) and a write enable signal; if the write signal  //
    // is asserted, the memory will write the data input bits to    //
    // the location specified by the input address.                 //
    //////////////////////////////////////////////////////////////////
    assign MemRead = (opcode == 4'b1000); // 1 if load, 0 otherwise
                      
    assign MemtoReg = (opcode == 4'b1000); // 1 if load, 0 otherwise

    assign MemWrite = (opcode == 4'b1001); // 1 if store, 0 otherwise

    memory_data data_mem(.data_out(mem_read_data), .data_in(read_data_2), .addr(ALU_Out), .enable(MemRead), .wr(MemWrite), .clk(clk), .rst(rst_n));

    assign write_data = (MemtoReg) ? mem_read_data : ALU_Out;

    assign LLB_data = {write_data[15:8], imm_8bit[7:0]};

    assign LHB_data = {imm_8bit[15:8], write_data[7:0]};

    // Set register write data to either LLB data, LHB data, or ALU output based on opcode //
    assign reg_write_data = (opcode == 4'b1010) ? LLB_data :
                            (opcode == 4'b1011) ? LHB_data : ALU_Out;

    ////////////////////
    // Register Write //
    ////////////////////
    RegisterFile rf_2(.clk(clk), .rst(rst_n), .SrcReg1(read_reg_1), .SrcReg2(read_reg_2), .DstReg(write_reg), .WriteReg(1'b1), .DstData(reg_write_data), .SrcData1(read_data_1), .SrcData2(read_data_2));

endmodule