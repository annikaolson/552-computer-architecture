module cpu(clk, rst_n, hlt, pc);

input clk, rst_n;
output hlt; // when processor encounters HLT instruction it will assert this signal once it is finished processing the instrucitno prior to the HLT
output [15:0] pc;   // PC value over the course of the program execution

//////////////////////////////////////////////////////////////////
// reset logic: when reset is high, instructions are executed.  //
// if reset goes low for one clock cycle, the pc is set back    //
// to 0 to start execution at the beginning.                    //
//////////////////////////////////////////////////////////////////

// sample logic
// always @(posedge clk, negedge rst_n) begin
//      if (!rst_n) pc <= 16'b0
//      else pc <= ...
//end

// instantiate instruction and data memories

//////////////////////////////////////////////////////////////////
// inst. memory: using addr, find the 16-bit inst. to decode.   //
//                                                              //
// decode the instruction: get the opcode, instruction type,    //
// source, and destination registers to use for operation.      //
//////////////////////////////////////////////////////////////////

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
// register file - decode registers to write to or read from    //
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
// next instruction calculation: involves a shift of the        //
// immediate value to get the branch address to add to the PC,  //
// then a mux to select the PC + 4 or PC + branch address       //
// (PCsrc control signal)                                       //
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
// ALU Adder: carry lookahead adder (CLA) logic for adding.     //
// input 1 will always be read data 1, input 2 will be chosen   //
// via ALUSrc control signal mux that will select either read   //
// data 2 or sign-extended immediate. can set zero flag (z),    //
// overflow (V), or sign flag (N).                              //
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
// reduction unit (RED): performs reduction on 4 byte-size      //
// operands (i.e. 2 bytes each from 2 registers)                //
// e.g. rs = aaaaaaaa_bbbbbbbb; rt = cccccccc_dddddddd          //
// (signext) ((aaaaaaaa + cccccccc) + (bbbbbbbb + ddddddddd))   //
// will be in rd after the RED operation.                       //
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
// data memory: provide a 16-bit address and 16-bit data input  //
// (write data) and a write enable signal; if the write signal  //
// is asserted, the memory will write the data input bits to    //
// the location specified by the input address.                 //
//////////////////////////////////////////////////////////////////



endmodule