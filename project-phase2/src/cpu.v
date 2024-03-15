module cpu(clk, rst_n, hlt, pc);

    input clk, rst_n;
    output hlt; // when processor encounters HLT instruction it will assert this signal once it is finished processing the instrucitno prior to the HLT
    output [15:0] pc;   // PC value over the course of the program execution

    //////////////////////////////////////////////////////////////////
    // intermediate variables used throughout CPU                   //
    //////////////////////////////////////////////////////////////////
    wire [15:0] ALU_A, ALU_B; // inputs to the ALU read from registers
    wire [3:0] opcode;  // opcode of the instruction
    wire [15:0] instruction;
    wire [15:0] ALU_Out;    // output of ALU
    wire [3:0] read_reg_1, read_reg_2, write_reg;   // registers to write to
    wire [15:0] read_data_1, read_data_2;   // the data read from the selected registers
    wire [3:0] imm_offset;     // immediate for shifter operations, offset for LW and SW
    wire [15:0] imm_offset_sign_ext;
    wire [15:0] imm_offset_sign_ext_shl;
    wire [7:0] imm_8bit;    // 8-bit immediate for LLB and LHB
    wire [8:0] branch_offset;   // label to jump to for B instruction
    wire [2:0] branch_cond; // branch condition for B and BR
    wire [15:0] next_pc;
    wire [15:0] mem_read_data;
    wire [15:0] reg_write_data; // data to write to register
    wire [15:0] LLB_data; // LLB data
    wire [15:0] LHB_data; // LHB_data
    wire [2:0] flag;    // {Z, V, N}
    wire Z, V, N;

    //////////////////////////////////////////////////////////////////
    // control signals: used as select signal for mux outputs       //
    //////////////////////////////////////////////////////////////////
    wire ALUSrc;    // select the second ALU input: read data 2 or immediate
    wire RegWrite;  // whether a register is being written to or not
    wire MemWrite, MemRead, MemEnable; // see if memory should be read from or written to
    wire MemtoReg;  // 1 indicates a load word, in which memory access is written to a register


    //////////////////////////////////////////////////////////////////
    // reset logic: when reset is high, instructions are executed.  //
    // if reset goes low for one clock cycle, the pc is set back    //
    // to 0 to start execution at the beginning.                    //
    //////////////////////////////////////////////////////////////////
    dff pc_dff[15:0](.q(pc), .d(next_pc), .wen(1'b1), .clk(clk), .rst(~rst_n));

    //////////////////////////////////////////////////////////////
    // get the flag signals: they should hold their value until //
    // they are changed.                                        //
    //////////////////////////////////////////////////////////////
    flag_reg flagReg(.clk(clk), .rst(~rst_n), .opcode(opcode), .Z(Z), .N(N), .V(V), .flag(flag));

    //////////////////////////////////////////////////////////////////
    // inst. memory: using addr, find the 16-bit inst. to decode.   //
    //                                                              //
    // decode the instruction: get the opcode, instruction type,    //
    // source, and destination registers to use for operation.      //
    //////////////////////////////////////////////////////////////////
    memory_inst instr_mem(.data_out(instruction), .data_in(16'b0), .addr(pc), .enable(1'b1), .wr(1'b0), .clk(clk), .rst(~rst_n));
    assign opcode = instruction[15:12];
    assign hlt = (opcode == 4'b1111);

    //////////////////////////////////////////////////////////////////
    // register file - decode registers to write to or read from    //
    //////////////////////////////////////////////////////////////////
    assign read_reg_1 = (opcode[3:1] == 3'b101) ? instruction[11:8] : instruction[7:4]; // any instruction that uses a register in the ALU uses rs
    assign read_reg_2 = (opcode[3:1] == 3'b100) ? instruction[11:8] : instruction[3:0];
    assign write_reg = instruction[11:8];    // if ALU op, choose rd, otherwise (if memory) choose rt as destination
    assign imm_8bit = instruction[7:0];
    assign imm_offset = instruction[3:0];
    assign branch_cond = instruction[11:9];
    assign branch_offset = instruction[8:0];
    assign RegWrite = ~opcode[3] | (opcode == 4'b1000) | (opcode == 4'b1010) | (opcode == 4'b1011) | (opcode == 4'b1110);

    //////////////////////////////////////////////////////////////////
    // immediate for shift and lw and sw instructions               //
    //////////////////////////////////////////////////////////////////
    assign imm_offset_sign_ext = {{12{imm_offset[3]}}, imm_offset};
    assign imm_offset_sign_ext_shl = imm_offset_sign_ext << 1;

    
    RegisterFile rf(.clk(clk), .rst(~rst_n), .SrcReg1(read_reg_1), .SrcReg2(read_reg_2), .DstReg(write_reg), .WriteReg(RegWrite), .DstData(reg_write_data), .SrcData1(read_data_1), .SrcData2(read_data_2));

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
    // calculate the next PC: PC + 2 if not a branch instruction    //
    // or PC + 2 + offset if a branch; this offset can either be an //
    // immediate (B) or a value in a register (BR). next_pc hold    //
    // this next pc calculation for the next instruction.           //
    // read_data_1 holds the data read from the rs register.        //
    //////////////////////////////////////////////////////////////////
    PC_control pc_control(.hlt(hlt), .C(branch_cond), .I(branch_offset), .F(flag), .PC_in(pc), .rs_data(read_data_1), .opcode(opcode), .PC_out(next_pc));

    // Add PCS instruction

    //////////////////////////////////////////////////////////////////
    // ALU Adder: carry lookahead adder (CLA) logic for adding.     //
    // input 1 will always be read data 1, input 2 will be chosen   //
    // via ALUSrc control signal mux that will select either read   //
    // data 2 or sign-extended immediate. can set zero flag (z),    //
    // overflow (V), or sign flag (N).                              //
    //////////////////////////////////////////////////////////////////
    assign ALUSrc = (opcode[3] == 1'b0)     ? 1'b0 :
                    (opcode[3:1] == 3'b110) ? 1'b0 : 1'b1; // 0 if R-format or branch, 1 otherwise
    assign ALU_B = ALUSrc ? imm_offset_sign_ext_shl : read_data_2;             
    assign ALU_A = read_data_1;    

    // WILL NEED TO CHANGE SUCH THAT THE IMM IS NOT A PORT
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

    assign MemEnable = MemRead | MemWrite;

    memory_data data_mem(.data_out(mem_read_data), .data_in(read_data_2), .addr(ALU_Out), .enable(MemEnable), .wr(MemWrite), .clk(clk), .rst(~rst_n));

    //assign write_data = (MemtoReg) ? mem_read_data : ALU_Out;

    assign LLB_data = (read_data_1 & 16'hFF00) | (imm_8bit);

    assign LHB_data = (read_data_1 & 16'h00FF) | (imm_8bit << 8);

    // Set register write data to either LLB data, LHB data, next pc (PCS), or ALU output based on opcode //
    assign reg_write_data = (opcode == 4'b1010) ? LLB_data :
                            (opcode == 4'b1011) ? LHB_data :
                            (opcode == 4'b1110) ? next_pc :
			    (MemtoReg) ? mem_read_data : ALU_Out;

endmodule