`ifndef _Def
`define _Def

`define DataBusBits	 	32
`define RegAddrBits	5



//risc  standard definition
`define ZEROREG 5'b00000
`define OPCODEWIDTH 6:0

`define ITYPE1  7'b0010011   //arithmetic imm
`define ITYPE2  7'b0000011  //loads
`define RTYPE   7'b0110011 // arith no imm
`define ITYPE4  7'b1100111 // JALR


`define UTYPE1  7'b0110111
`define UTYPE2  7'b0010111


`define JTYPE1  7'b1101111
`define JTYPE2  7'b1100111

`define LTYPE1  7'b0000011 

`define STYPE1  7'b0100011

`define BTYPE1  7'b1100011


 
   //
 //opcodes standard funct7|funct3|opcode
`define JAL     7'b1101111
`define JALR    10'b0001100111
`define AUIPC   7'b0010111
`define LUI     7'b___0110111

 //arithmetic  
`define SUB     10'b0000110011
`define ADD     10'b0000110011
`define SLL     10'b0010110011
`define SLT     10'b0100110011
`define SLTU    10'b0110110011
`define XOR     10'b1000110011
`define SRL     10'b1010110011
`define SRA     10'b1010110011
`define OR      10'b1100110011
`define AND     10'b1110110011
//arithmetic immediate
//`define SRAI    10'b1010010011
`define ADDI    10'b0000010011
`define SLTI    10'b0100010011
`define SLTIU   10'b0110010011
`define XORI    10'b1000010011
`define ORI     10'b1100010011
`define ANDI    10'b1110010011
`define SLLI    10'b0010010011  // TODO
`define SRLI    10'b1010010011  /// TODO
`define SRAI    10'b1010010011  /// TODO

//f7
`define funct7ack   7'b0100000
`define funct7nack  7'b0000000
`define ARITIMM     7'b0010011




//branches
`define BEQ     10'b0001100011
`define BNE     10'b0011100011
`define BLT     10'b1001100011
`define BGE     10'b1011100011
`define BLTU    10'b1101100011
`define BGEU    10'b1111100011


//loads 
`define LB  10'b0000000011
`define LH  10'b0010000011
`define LW  10'b0100000011
`define LBU 10'b1000000011
`define LHU 10'b1010000011

//stores 
`define SB  10'b0000100011
`define SH  10'b0010100011
`define SW  10'b0100100011

`endif