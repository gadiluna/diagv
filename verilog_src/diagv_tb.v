//
// ADAPTED FROM THE test case of the STEELCORE RISC V processor - 
// of   Rafael de Oliveira Calçada 
// Origiinal license below distributed as MIT License as the original
//////////////////////////////////////////////////////////////////////////////////
/*********************************************************************************
MIT License
Copyright (c) 2020 Rafael de Oliveira Calçada
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
********************************************************************************/

`timescale 1ns / 1ps
//`include "../globals.vh"

module tb_diagv_top();

    reg CLK;
    reg RESET;              
    wire [31:0] I_ADDR;
    reg [31:0] INSTR;        
    wire [31:0] D_ADDR;
    wire [31:0] DATA_OUT;
    reg [31:0] DATA_IN;   
    wire IMM_WE;
    wire DATA_WE;     
    
    reg [8*20:0] tests [0:38]={
        "rv32ui-p-add.mem"//,
//        "rv32ui-p-bgeu.mem",
//        "rv32ui-p-lb.mem",
//        "rv32ui-p-or.mem",
//        "rv32ui-p-sltiu.mem",
//        "rv32ui-p-sub.mem",
//        "rv32ui-p-add.mem",
//        "rv32ui-p-blt.mem",
//        "rv32ui-p-lbu.mem",
//        "rv32ui-p-sb.mem",
//        "rv32ui-p-slt.mem",
//        "rv32ui-p-sw.mem",
//        "rv32ui-p-andi.mem",
//        "rv32ui-p-bltu.mem",
//        "rv32ui-p-srai.mem",
//        "rv32ui-p-xor.mem",
//        "rv32ui-p-beq.mem",
//        "rv32ui-p-jal.mem",
//        "rv32ui-p-lw.mem"
        };


    diagv_core dc(
        .clk(CLK),
        .reset(RESET),
        .pc_out(I_ADDR),
        .current_instruction(INSTR),
        .data_addr(D_ADDR),
        .data_out(DATA_OUT),
        .data_mem_in(DATA_IN),
        .imme_we(IMM_WE),
        .dmem_we(DATA_WE)
    );
    
    reg [31:0] ram [0:16383];
    integer i;
    integer j;
    integer k;    
    
    always
    begin
        #10 CLK = !CLK;
    end
    
    initial
    begin
    
        for(k = 0; k < 1; k=k+1)
        begin
    
            // LOADS PROGRAM INTO MEMORY 
            for(i = 0; i < 65535; i=i+1) ram[i] = 8'b0;
            $display("Running %s...", tests[k]);
            $readmemh("C:/fib.mem",ram);            
            
            // INITIAL VALUES
            RESET = 1'b0;        
            CLK = 1'b0;        

            // RESET
            #5;
            RESET = 1'b1;
            #15;
            RESET = 1'b0;
            
            // one second loop
            for(j = 0; j < 50000000; j = j + 1)
            begin
                #20;
                if(DATA_WE == 1'b1 && D_ADDR == 32'h00001000)
                begin
                    $display("Result: %h", DATA_OUT);
                    #20;
                    j = 50000000;
                end
            end
            
        end
       
    end
    
    always @(*) begin
        INSTR = ram[I_ADDR[16:2]];
        DATA_IN = ram[D_ADDR[16:2]];
    end
    
    always @(posedge CLK or posedge RESET)
    begin
        if(~RESET)
        begin
            if(DATA_WE)
            begin
                    ram[D_ADDR[16:2]][7:0] <= DATA_OUT[7:0];
                    ram[D_ADDR[16:2]][15:8] <= DATA_OUT[15:8];
                    ram[D_ADDR[16:2]][23:16] <= DATA_OUT[23:16];
                    ram[D_ADDR[16:2]][31:24] <= DATA_OUT[31:24];
            end
        end
    end

endmodule