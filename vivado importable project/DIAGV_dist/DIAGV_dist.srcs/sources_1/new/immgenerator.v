`timescale 1ns / 1ps
`include "ALUOPS.vh"
`include "DIAGV.vh"


//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/17/2021 11:03:21 PM
// Design Name: 
// Module Name: immgenarator
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


module immgenerator(input [`DataBusBits-1:0] inst,
                    output [`DataBusBits-1:0] imm
    );
    reg [`DataBusBits-1:0] result;
    assign imm=result;
    
    always @(*) begin
        if(inst[6:0]==`ITYPE1 | inst[6:0]==`ITYPE2) 
            result= {{30{inst[31]}},inst[31:20]};  
        else if(inst[6:0]==`STYPE1) 
            result= {{30{inst[31]}},{inst[31:25],inst[11:7]}};          
        else if(inst[6:0]==`JTYPE1)  //JAL
            result={{12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0};  
        else if(inst[6:0]==`JTYPE2)  //JALR I-type encoding - JALR instruction does not treat the 12-bit immediate as multiples of 2 bytes, unlike the conditional branch instructions. - RISC V spec.pdf 
               result= {{30{inst[31]}},inst[31:12]};
        else if(inst[6:0]==`STYPE1) //The effective address is obtained by adding register rs1 to the sign-extended 12-bit offset
                result={{20{inst[31]}},inst[31:25], inst[11:7]};
        else if(inst[6:0]==`BTYPE1) //signed offsets in multiples of 2 bytes
                result={{19{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
        else if(inst[6:0]==`UTYPE1 | inst[6:0]==`UTYPE2) 
                result={inst[31:12],{12{1'b0}}};  
    end
    
endmodule
