`timescale 1ns / 1ps
`include "DIAGV.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/19/2021 03:47:18 PM
// Design Name: 
// Module Name: store_unit
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


module store_unit(
    input  [`DataBusBits-1:0] regval,
    input  [`DataBusBits-1:0] instruction,
    output reg [`DataBusBits-1:0] tostore
    );
    
    wire [2:0] funct3;
    wire [6:0]opcode;
    wire zero24;
    wire zero16;
    
    assign funct3=instruction[14:12];
    assign opcode=instruction[6:0]; 
    assign zero24= 16'b000000000000000000000000; 
    assign zero16= 16'b0000000000000000; 
    
    always @(*) begin
            case({funct3,opcode})
                `SB:
                    tostore={{24{regval[7]}}, regval[7:0]};
                `SH:
                    tostore={{16{regval[15]}}, regval[15:0]};
                `SW:
                    tostore=regval;
                 default:
                    tostore={zero16,zero16};
            endcase
    end
endmodule
