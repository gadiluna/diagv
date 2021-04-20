`timescale 1ns / 1ps
`include "DIAGV.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/19/2021 02:44:01 PM
// Design Name: 
// Module Name: loadunit
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


module loadunit(
    input [`DataBusBits-1:0] memval,
    input [`DataBusBits-1:0] instruction,
    input [`DataBusBits-1:0]  address,
    output reg [`DataBusBits-1:0] toloadval
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
                `LB:                 
                    case(address[1:0])
                        2'b00: toloadval={{24{memval[7]}}, memval[7:0]};
                        2'b01: toloadval={{24{memval[15]}}, memval[15:8]};
                        2'b10: toloadval={{24{memval[23]}}, memval[23:16]};
                        2'b11: toloadval={{24{memval[31]}}, memval[31:24]};
                    endcase
                `LH:
                    case(address[1:0])
                       2'b00:  toloadval={{16{memval[15]}}, memval[15:0]};
                       2'b01:  toloadval={{16{memval[23]}}, memval[23:8]};
                       2'b10:  toloadval={{16{memval[31]}}, memval[31:16]};
                    endcase
                `LW:
                    toloadval=memval;
                `LBU:
                    case(address[1:0])
                         2'b00: toloadval={zero24,memval[7:0]};
                         2'b01: toloadval={zero24, memval[15:8]};
                        2'b10: toloadval={zero24, memval[23:16]};
                        2'b11: toloadval={zero24, memval[31:24]};
                         
                     endcase
                `LHU:
                   case(address[1:0])
                       2'b00:  toloadval={zero16,memval[15:0]};
                       2'b10:  toloadval={zero16, memval[31:16]};
                       2'b01:  toloadval={zero16, memval[23:8]};
                    endcase
                 default:
                    toloadval={zero16,zero16};
            endcase
       
    end
endmodule
