`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/18/2021 01:28:57 PM
// Design Name: 
// Module Name: singlecycle_regfile
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


module singlecycle_regfile(
            input clk, // clock
            input rst, //synchronous reset 
            input we, // write enable signal - positive active
            input [`RegAddrBits-1:0]addr1, // Address of the first register to be read reg1
            input [`RegAddrBits-1:0]addr2, // Address of the second register to be read reg2
            input [`RegAddrBits-1:0]saddr, // Address of the  register to be stored
            input [`DataBusBits-1:0]wdata, // Data to be stored
            output reg [`DataBusBits-1:0] reg1, // Data from reg1
            output reg [`DataBusBits-1:0] reg2  // Data from reg2
    );
    reg [`DataBusBits-1:0] registers[31:0];
    integer i=0;
    
    always @(*) begin
        reg1 = registers[addr1];
        reg2 = registers[addr2]; // parallel read 
    end
   
    always @(posedge clk) begin
        if(rst) begin
            for(i=0;i<`DataBusBits; i=i+1) begin
                registers[i] <='b0;
            end   
        end 
        else if(we) begin
            if(saddr != 'b00000) begin // 0-reg is 0. 
                registers[saddr] <= wdata;
            end
        end
    end
endmodule
