// `include "PC.v"
// `include "PC_Adder.v"
// `include "Mux.v"
// `include "instruction_Memory.v"
// `include "control_unit_top.v"
// `include "register_file.v"
// `include "sign_extent.v"
// `include "ALU.v"
// `include "Data_mem.v"
`include "Writeback_Cycle.v"
`include "fetch_cycle.v"
`include "decode_cycle.v"
`include "execute_cycle.v"
`include "Memory_Cycle.v"


module Pipeline_top(clk,rst);

    input clk,rst;

    // Declaration of Interim Wires
    wire PCSrcE, RegWriteW, RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE, RegWriteM, MemWriteM, ResultSrcM, ResultSrcW;
    wire [2:0] ALUControlE;
    wire [4:0] RD_E, RD_M, RDW;
    wire [31:0] PCTargetE, InstrD, PCD, PCPlus4D, ResultW, RD1_E, RD2_E, Imm_Ext_E, PCE, PCPlus4E, PCPlus4M, WriteDataM, ALU_ResultM;
    wire [31:0] PCPlus4W, ALU_ResultW, ReadDataW;
    wire [1:0] ForwardAE, ForwardBE;


    //declaration of wires

    //module initiation
    fetch_cycle fetch_cycle(
        .clk(clk),
        .rst(rst),
        .PCSrcE(PCSrcE), 
        .PCTargetE(PCTargetE),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D)
        );


    
 decode_cycle decode(
    .clk(clk), 
    .rst(rst), 
    .InstrD(InstrD), 
    .PCD(PCD), 
    .PCPlus4D(PCPlus4D), 
    .RegWriteW(RegWriteW), 
    .RDW(RDW), 
    .ResultW(ResultW), 
    .RegWriteE(RegWriteE), 
    .ALUSrcE(ALUSrcE), 
    .MemWriteE(MemWriteE), 
    .ResultSrcE(ResultSrcE),
    .BranchE(BranchE),  
    .ALUControlE(ALUControlE), 
    .RD1_E(RD1_E), 
    .RD2_E(RD2_E), 
    .Imm_Ext_E(Imm_Ext_E), 
    .RD_E(RD_E), 
    .PCE(PCE), 
    .PCPlus4E(PCPlus4E)
    
);

execute_cycle Execute(
    .clk(clk), 
    .rst(rst), 
    .RegWriteE(RegWriteE), 
    .ALUSrcE(ALUSrcE), 
    .MemWriteE(MemWriteE), 
    .ResultSrcE(ResultSrcE), 
    .BranchE(BranchE), 
    .ALUControlE(ALUControlE), 
    .RD1_E(RD1_E), 
    .RD2_E(RD2_E), 
    .Imm_Ext_E(Imm_Ext_E), 
    .RD_E(RD_E), 
    .PCE(PCE), 
    .PCPlus4E(PCPlus4E), 
    .PCSrcE(PCSrcE), 
    .PCTargetE(PCTargetE), 
    .RegWriteM(RegWriteM), 
    .MemWriteM(MemWriteM), 
    .ResultSrcM(ResultSrcM), 
    .RD_M(RD_M), 
    .PCPlus4M(PCPlus4M), 
    .WriteDataM(WriteDataM), 
    .ALU_ResultM(ALU_ResultM),
    .ResultW(ResultW),
    .ForwardAE(ForwardAE),
    .ForwardBE(ForwardBE)
    );


 // Memory Stage
    memory_cycle Memory (
                        .clk(clk), 
                        .rst(rst), 
                        .RegWriteM(RegWriteM), 
                        .MemWriteM(MemWriteM), 
                        .ResultSrcM(ResultSrcM), 
                        .RD_M(RD_M), 
                        .PCPlus4M(PCPlus4M), 
                        .WriteDataM(WriteDataM), 
                        .ALU_ResultM(ALU_ResultM), 
                        .RegWriteW(RegWriteW), 
                        .ResultSrcW(ResultSrcW), 
                        .RD_W(RDW), 
                        .PCPlus4W(PCPlus4W), 
                        .ALU_ResultW(ALU_ResultW), 
                        .ReadDataW(ReadDataW)
                    );


 // Write Back Stage
    writeback_cycle WriteBack (
                        .clk(clk), 
                        .rst(rst), 
                        .ResultSrcW(ResultSrcW), 
                        .PCPlus4W(PCPlus4W), 
                        .ALU_ResultW(ALU_ResultW), 
                        .ReadDataW(ReadDataW), 
                        .ResultW(ResultW)
                    );


// hazard unit 
hazard_unit Forwarding_block(
    .rst(rst), 
    .RegWriteM(RegWriteM), 
    .RegWriteW(RegWriteW), 
    .RD_M(RD_M), 
    .RDW(RDW), 
    .RS1_E(RS1_E), 
    .RS2_E(RS2_E), 
    .ForwardAE(ForwardAE), 
    .ForwardBE(ForwardBE)
    );
endmodule
