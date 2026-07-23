`include "main_decoder.v"
`include "alu_decoder.v"


module Control_Unit_Top(op,RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,ALUControl,funct3, funct7 );

    input[6:0] op, funct7;
    input [2:0] funct3;
    
    output Branch,ResultSrc,MemWrite,RegWrite,ALUSrc;
    output [1:0]ImmSrc;
    output [2:0] ALUControl;

    wire [1:0] ALUOp;

    main_decoder Main_Decoder(
        .Op(op),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .Branch(Branch),
        .ALUOp(ALUOp)
    );

    alu_decoder alu_decoder(
        .ALUOp(ALUOp),
        .op(op),
        .ALUControl(ALUControl),
        .funct3(funct3), 
        .funct7(funct7) 
    );



endmodule