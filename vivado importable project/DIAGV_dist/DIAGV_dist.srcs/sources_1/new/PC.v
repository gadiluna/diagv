`timescale 1ns / 1ps
`include "DIAGV.vh"

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/17/2021 07:48:11 PM
// Design Name: 
// Module Name: PC
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


module pc( input wire clk,
            input wire [`DataBusBits-1:0] addr_in,
            input  wire stall,
            input wire reset,
           input wire laddr,
           output reg [`DataBusBits-1:0]  addr_out
    );
     reg [`DataBusBits-1:0]  internal; //program counter register
     
    always @(posedge clk) begin
        if(reset)
         internal <='b0;
        else if(laddr & ~stall)
         internal <=addr_in;
        else if (~stall)
         internal <= internal +4;
        else
         internal <=internal;
    end
    
     always @(*) begin
        addr_out = internal;
     end
    
endmodule
