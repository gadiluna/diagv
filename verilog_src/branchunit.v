`timescale 1ns / 1ps
`include "DIAGV.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/18/2021 05:49:30 PM
// Design Name: 
// Module Name: branchunit
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


module branchunit(
          input [`DataBusBits-1:0] reg1,
          input [`DataBusBits-1:0] reg2,
          input [`DataBusBits-1:0] instruction,
          output reg  takebranch
    );
    
    wire [2:0] funct3;
    wire [6:0]opcode;
    wire samesign;
    wire eq;
    wire r1lr2;
    wire debug;
    
    assign samesign=~(reg1[31]^reg2[31]);
    assign eq=(reg1==reg2);
    assign r1lr2=(reg1 < reg2);
    
    assign funct3=instruction[14:12];
    assign opcode=instruction[6:0]; 

    always @(*) begin
        if(opcode ==`JAL | opcode ==`JALR)
                takebranch=1;
        else begin
            case({funct3,opcode}) 
             `BEQ:  
                takebranch= eq;
             `BNE: 
                takebranch=~eq;
             `BLT: 
                //if they are different sign the positive wins - 2 comp the last bit sign
                takebranch=(samesign)? r1lr2: reg1[31];
             `BGE: 
                takebranch=~((samesign)? r1lr2: reg1[31]) ;
             `BLTU: 
                //if they are different sign the positive wins - 2 comp the last bit sign
                takebranch=r1lr2;
             `BGEU: 
                takebranch= ~r1lr2;
            default: takebranch=0;
            endcase
        end
    end
    
    
endmodule
