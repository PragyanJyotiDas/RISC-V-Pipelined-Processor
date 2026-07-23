`include "PC.v"
`include "instruction_Memory.v"
`include "register_file.v"
`include "sign_extent.v"
`include "ALU.v"
`include "control_unit_top.v"
`include "Data_mem.v"
`include "PC_Adder.v"
`include "Mux.v"

module Single_Cycle_Top(clk,rst);

input clk,rst;

wire [31:0] PC_Top;
wire [31:0] RD_Instr;
wire [31:0] RD1_Top,Imm_Ext_Top;
wire [2:0] ALUControl_Top;
wire [31:0] ALUResult;
wire RegWrite,MemWrite,ALUSrc;
wire [31:0]ReadData;
wire [31:0]PCPlus4;
wire [31:0]RD2_Top;
wire [1:0]ImmSrc;
wire [31:0] SrcB, Result;
wire ResultSrc;

P_C PC_Module (
    .PC_Next(PCPlus4),
    .PC(PC_Top) ,
    .rst(rst) ,
    .clk(clk)
);
   
PC_Adder PC_Adder(
    .a(PC_Top),
    .b(32'd4),
    .c(PCPlus4)
);


Instruction_memory instruction_Memory(
    .A(PC_Top),
    .RD(RD_Instr),
    .rst(rst)
);

Register_file Reg_file(
    .A1(RD_Instr[19:15]),
    .A2(RD_Instr[24:20]),
    .A3(RD_Instr[11:7]),
    .WE3(RegWrite),
    .WD3(Result),
    .RD1(RD1_Top),
    .RD2(RD2_Top),
    .clk(clk),
    .rst(rst)
);


Mux Mux_Register_to_ALU(
    .a(RD2_Top),
    .b(Imm_Ext_Top),
    .s(ALUSrc),
    .c(SrcB)
);

sign_extent sign_extent(
    .In(RD_Instr),
    .ImmSrc(ImmSrc),
    .Imm_Ext(Imm_Ext_Top)
);

ALU alu (
    .A(RD1_Top),
    .B(SrcB),
    .ALUControl(ALUControl_Top), 
    .Result(ALUResult), 
    .Z(),
    .N(),
    .C(), 
    .V()
);

Control_Unit_Top Control_Unit_Top(
    .op(RD_Instr[6:0]),
    .RegWrite(RegWrite),
    .ImmSrc(ImmSrc),
    .ALUSrc(ALUSrc),
    .MemWrite(MemWrite),
    .ResultSrc(ResultSrc),
    .Branch(),
    .ALUControl(ALUControl_Top),
    .funct3(RD_Instr[14:12]), 
    .funct7() 
);

Data_Memory Data_Memory(
    .clk(clk),
    .rst(rst), 
    .WE(MemWrite) , 
    .A(ALUResult), 
    .WD(RD2_Top),
    .RD(ReadData)
);

Mux Mux_Data_mem_to_Register(
    .a(ALUResult),
    .b(ReadData),
    .s(ResultSrc),
    .c(Result)
);


endmodule