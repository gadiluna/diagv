`timescale 1ns / 1ps
`include "ALUOPS.vh"
`include "DIAGV.vh"


//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/17/2021 04:45:50 PM
// Design Name: 
// Module Name: alu
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


module alu(
        input [`AluCntrBusBits-1:0] op,
        input [`DataBusBits-1:0]data1,
        input [`DataBusBits-1:0]data2,
        output reg [`DataBusBits-1:0]out
        );
        
       
       wire signed   [`DataBusBits-1:0] signeds1; 
       wire ltu;
       wire lt;
       
       assign ltu= (data1 < data2);
       assign lt= (data1[31]^data2[31])? data1[31]: ltu;
       assign signeds1=data1;
       
       
       always @(*) begin 

        case(op)  
             `AluNop: 
                out=data2;
            `AluSum: 
                out= data1 + data2; 
            `AluMul: 
                out= data1 * data2; 
            `AluSub: 
                out = data1 - data2;
            `AluAnd: 
                out = data1 & data2;
            `AluOr: 
                out = data1 | data2;
            `AluXor: 
                out = data1 ^ data2;
              `AluLShift:
              out = data1 << data2[4:0];//32 max value of shift 
              `AluRLShift:
                out = data1 >> data2[4:0]; //32 max value of shift 
              `AluRRShift:
                out = signeds1 >>> data2[4:0]; //32 max value of shift 
               `AluLT:
                    out=lt;
               `AluLTU:
                    out=ltu;
            default: 
                out = 'b0;
        endcase 
            
        end
        
endmodule
