`timescale 1ns / 1ps
`include "DIAGV.vh"
`include "ALUOPS.vh"

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/18/2021 01:14:29 PM
// Design Name: 
// Module Name: singlecycledatapath
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


module diagv_core(
        input wire clk,
        input wire reset,
        
        input wire [`DataBusBits-1:0] current_instruction,
        
         input wire [`DataBusBits-1:0] data_mem_in,
        
        output wire [`DataBusBits-1:0] pc_out,
        output wire [`DataBusBits-1:0] data_addr,
        output wire [`DataBusBits-1:0] data_out,
        output wire imme_we,
         output wire dmem_we
   
    );
    
         wire pc_stall;
         wire pc_reset;
          
        //imem control wires
        
        //regfile control wires
         wire reg_we;
         wire reg_rst;

        //alu control wires  --- to embedd
         wire [`AluCntrBusBits-1:0] alu_control;     
        
        //dmem control wires
         //wire dmem_we;
        
        //dapaths control wires
        //jmp wire
        //input wire jmp_next,
        
         wire takenbranch;
        
       //control second input of alu 
         wire sel_alu_i2;
         wire sel_alu_i1;
        
        //control wb stage input
         wire sel_wb_input;
         
        
 
    
    control_unit cu(
        .current_instruction(current_instruction),
        .reset(reset),
        .takenbranch(takenbranch),
        .pc_stall(pc_stall),
        .pc_reset(pc_reset),
        .imme_we(imme_we),
        .reg_we(reg_we),
        .reg_rst(reg_rst),
        .alu_control(alu_control),
        .sel_alu_i1(sel_alu_i1),
        .sel_alu_i2(sel_alu_i2),
        .dmem_we(dmem_we),
        .sel_wb_input(sel_wb_input)
    );
    
    reg  [`DataBusBits-1:0] allzero='b0;
    
    //pc wires in/out
   // wire [`DataBusBits-1:0] pc_out;
  
    wire [`DataBusBits-1:0] pc_in;
  
    
    //immediate wire
    wire [`DataBusBits-1:0] imm_out;
    
    //instruction memory out
    //wire [`DataBusBits-1:0] current_instruction;
    
    //reg data in
    wire [`RegAddrBits-1:0] rs1;
    wire [`RegAddrBits-1:0] rs2;
    //adress of the write
     wire [`RegAddrBits-1:0] rd;
    
    //reg data out
    wire [`DataBusBits-1:0] rd1;
    wire [`DataBusBits-1:0] rd2;
    
    //wire out from alu mux to the first/second input of the ALU
     wire [`DataBusBits-1:0] alu1in;
    wire [`DataBusBits-1:0] alu2in;
    
    // alu wire out 
    wire  [`DataBusBits-1:0] alu_out;
    
    //store unit out/datamem in
    wire  [`DataBusBits-1:0] store_out;
    
    //data mem out wire
    wire  [`DataBusBits-1:0] data_mem_out;
    
    //load unit out
    wire  [`DataBusBits-1:0] load_out;

    //wb wire of mux out  alu or (load/mem)
    
     wire  [`DataBusBits-1:0] wb_mux_out;
     
     wire  [`DataBusBits-1:0] pcwb_mux_out;
     
     assign data_addr=alu_out;
     
    //assign to_c_current_instruction=current_instruction;
   
  
   
   pc pct(.clk(clk)
   ,.addr_in(pc_in)
   ,.reset(pc_reset)
   ,.stall(pc_stall)
   ,.laddr(takenbranch)
   ,.addr_out(pc_out)
   );
   
    
  // singlecycle_mem imem(.clk(clk)
  // ,.we(imem_we)
  // ,.addr(pc_out)
 //  ,.idata(allzero)
 //  ,.data(current_instruction)
 //  );
   
   immgenerator  img(
     .inst(current_instruction),
     .imm(imm_out)
    );
    
   //branch adder 
   assign pc_in=pc_out+imm_out;
   
   assign rs1=current_instruction[19:15];
   assign rs2=current_instruction[24:20];
   assign rd=current_instruction[11:7];
   
   
   assign pcwb_mux_out=(takenbranch)?pc_out+4:wb_mux_out;
   
   //REGFILE
   singlecycle_regfile dut(
    
        .clk(clk),
        .rst(reg_rst),
        .addr1(rs1),
        .addr2(rs2),
        .saddr(rd),
        .reg1(rd1),
        .reg2(rd2),
        .we(reg_we),
        .wdata(pcwb_mux_out)
        
    );
    
    assign alu1in=(sel_alu_i1)? rd1 : pc_out;
    assign alu2in=(sel_alu_i2)? imm_out : rd2;
    
    //ALU
    alu dlu(
    .op(alu_control)
    ,.data1(alu1in)
    ,.data2(alu2in)
    ,.out(alu_out)
    );
    
    
    //branch unit 
    
    branchunit but(
        .reg1(rd1),
        .reg2(rd2),
        .instruction(current_instruction),
        .takebranch(takenbranch)
    );
    
    //store unit
    
    store_unit sut(
     .regval(rd2),
    .instruction(current_instruction),
      .tostore(data_out)
    );
    
    
    //memory
    
   //singlecycle_mem dmem(.clk(clk)
  // ,.we(dmem_we)
   //,.addr(alu_out)
   //,.idata(store_out)
  // ,.data(data_mem_out)
   //);
   
   //load unit 
   loadunit lut(
    .memval(data_mem_in),
    .address(alu_out),
    .instruction(current_instruction),
    .toloadval(load_out)
   );
   
    
   // wb mux
   assign wb_mux_out= (sel_wb_input)? load_out: alu_out;
   
    
    
endmodule
