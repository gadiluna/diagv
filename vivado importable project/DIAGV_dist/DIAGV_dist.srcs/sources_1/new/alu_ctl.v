`timescale 1ns / 1ps
`include "ALUOPS.vh"
`include "DIAGV.vh"

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/19/2021 09:27:09 PM
// Design Name: 
// Module Name: alu_ctl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu_ctl(
    input  wire [`DataBusBits-1:0] instruction,
    output reg [`AluCntrBusBits-1:0] alu_op,
    output wire alu_imm
    );
    
    wire [6:0] funct7;
    wire [2:0] funct3;
    wire [6:0] opcode;
    
    assign funct7=instruction[31:25];
    assign funct3=instruction[14:12];
    assign opcode=instruction[6:0];
    assign alu_imm = (opcode==`ARITIMM | opcode==`UTYPE1 |  opcode==`ITYPE2 |
     opcode== `STYPE1 | opcode == `BTYPE1)?1'b1:1'b0;
    
    always@(*) begin
        case({funct3,opcode})
             `ADD: begin
                  if(funct7==`funct7nack) 
                        alu_op=`AluSum;
                    else
                        alu_op=`AluSub; 
                  end
              `ADDI,`LW,`LB,`LH,`SW,`SB,`SH,`LBU,`LHU:
                    alu_op=`AluSum; 
              `SLL,`SLLI:
                    alu_op=`AluLShift;
              `XOR,`XORI:
                   alu_op=`AluXor;
              `ANDI,`AND: 
                   alu_op=`AluAnd;
              `ORI,`OR: 
                   alu_op=`AluOr;
              `SRLI,`SRL:
                   alu_op=`AluRLShift;
              `SRAI,`SRA:
                   alu_op=`AluRRShift;
              `SLTI,`SLT:
                    alu_op=`AluLT;
              `SLTIU,`SLTU:
                    alu_op=`AluLTU;
              `AUIPC:
                    alu_op=`AluSum;
              `LUI:
                    alu_op=`AluNop;
               default: 
                    alu_op=`AluNop;
        endcase
    end
    
endmodule
