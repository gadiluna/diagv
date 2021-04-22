`timescale 1ns / 1ps
`include "DIAGV.vh"

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/19/2021 11:50:21 PM
// Design Name: 
// Module Name: control_unit
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


module control_unit(
        input [`DataBusBits-1:0] current_instruction, 
        input reset, 
        input takenbranch,
        //pc control -- BRANCH UNIT IN DATAPATH 
        output wire pc_stall,
        output wire pc_reset,
        
        //instruction mem control
        output wire imme_we,
        
        //reg control
        output reg reg_we,
        output wire reg_rst,
        
        //alu control
        output [`AluCntrBusBits-1:0] alu_control,
         output reg sel_alu_i1,
         output sel_alu_i2, 
        
        // data mem control
        output reg dmem_we,
        
        //wb control 
       
        output reg sel_wb_input
        
    );
    
    // hardcoded signals
    assign imme_we=1'b0;
    assign pc_stall=1'b0; 
    
    //wiring reset signal
    assign pc_reset=reset;
    assign reg_rst=reset;
    
    
    //sub-unit that controls che ALU
    alu_ctl acut(
        .instruction(current_instruction),
        .alu_op(alu_control),
        .alu_imm(sel_alu_i2)
    );
    
    
    always @(*) begin
            // Actions
            // if writing on reg I have to set WE_REG e unset WE_MEM 
            // If writing on mem I have to unset WE_REG e set WE_MEM 
            // If branching I have to unset WE_REG and unset WE_MEM 
            // Instructions that write on REG
            // Arithmetic, load and jumps
            // Instructions that write on MEM:
            // only stores
         sel_alu_i1=1'b1;
        case(current_instruction[6:0]) //only opcode  
                `ITYPE1,`RTYPE: begin
                        reg_we=1'b1;
                        dmem_we=1'b0;  
                        sel_wb_input=1'b0;
                end
                `ITYPE4, `JAL: begin
                        reg_we=takenbranch;
                        dmem_we=1'b0;  
                        sel_wb_input=1'b0;
                end 
                `ITYPE2: begin
                        reg_we=1'b1;
                        dmem_we=1'b0;  
                        sel_wb_input=1'b1;                 
                 end
                 `STYPE1: begin
                        reg_we=1'b0;
                        dmem_we=1'b1;
                        sel_wb_input=1'b0;  
                 end
                `UTYPE1,`UTYPE2:  begin
                        sel_alu_i1=1'b0;
                        reg_we=1'b1;
                        dmem_we=1'b0;
                        sel_wb_input=1'b0;  
                    end
                 default: begin
                        reg_we=1'b0;
                        dmem_we=1'b0;
                        sel_wb_input=1'b1;  
                 end
        
        endcase
    end
    
    
endmodule
