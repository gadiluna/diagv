`ifndef _Alu
`define _Alu

//params
`define AluCntrBusBits 4
`define allzero 32'b00000000000000000000000000000000
//arithmetical operations
`define AluNop  4'b0000
`define AluSum	4'b0001
`define AluSub	4'b0010
`define AluLShift	4'b0011
`define AluRLShift	4'b0100
`define AluRRShift	4'b0101
`define AluMul   	4'b0110

// logical operations
`define AluOr	4'b0111
`define AluAnd	4'b1001
`define AluXor	4'b1010


//lt
`define AluLT	4'b1011
`define AluLTU  4'b1100








`endif