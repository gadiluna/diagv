`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer:  Giuseppe Antonio Di Luna
// 
// Create Date: 01/17/2021 02:06:02 PM
// Design Name: 
// Module Name: memreg
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
//a basic register
module basicregister #(parameter WORDSIZE=32)(
    input clk,
    input we,
    input rst,  //synchronous reset
    input [WORDSIZE-1:0] idata,
    output reg [WORDSIZE-1:0] reg1
    );
    
    always@(posedge clk) begin
        if(rst)
            reg1 <='b0; // reset
        else if(we)
            reg1<=idata; 
        else
            reg1<=reg1;
    end

endmodule 

module memreg #(parameter WORDSIZE=32, parameter REGS=32)(
            input clk, // clock
            input rst, //synchronous reset 
            input we, // write enable signal - positive active
            input [4:0]addr1, // Address of the first register to be read reg1
            input [4:0]addr2, // Address of the secood register to be read reg2
            input [4:0]saddr, // Address of the  register to be stored
            input [WORDSIZE-1:0] wdata, // Data to be stored
            output reg [WORDSIZE-1:0] reg1, // Data from reg1
            output reg [WORDSIZE-1:0] reg2  // Data from reg2
    );
    
    
  
    wire [WORDSIZE-1:0] outs[REGS-1:0];
    wire web[REGS-1:0];
    
    generate
        genvar i;
        for (i=0; i<REGS; i=i+1) begin : regcr
        
        assign web[i]= we & (&(wdata ^ i));
        
        basicregister i_reg(
       .clk(clk),
       .rst(rst),
       .we(web[i]),
       .idata(wdata),
       .reg1(outs[i])
         );
        end
        
        always @(*) begin: naddr1
         if (addr1 == i)
            reg1 = outs[i];
         if(addr2==i)
            reg2 = outs[i];
          end
          
    endgenerate

endmodule


