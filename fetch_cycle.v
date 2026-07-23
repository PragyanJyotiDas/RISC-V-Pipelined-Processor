`include "PC.v"
`include "PC_Adder.v"
`include "Mux.v"
`include "instruction_memory.v"

module fetch_cycle(clk,rst,PCSrcE, PCTargetE,InstrD,PCD,PCPlus4D);

    input clk,rst;
    input PCSrcE;
    input [31:0] PCTargetE;

    output[31:0] InstrD,PCD,PCPlus4D;

    wire[31:0] PC_F,PCF,PCPlus4F  ;
    wire[31:0] InstrF;
    //declare of register 
    reg [31:0]  InstrF_reg,PCF_reg,PCPlus4F_reg;
    //initiation of the module 
    //declaring teh pc mux
    Mux Mux(
        .a(PCPlus4F),
        .b(PCTargetE),
        .s(PCSrcE),
        .c(PC_F)
    );

//declaring the pc counter 
P_C P_C(
    .clk(clk),
    .rst(rst),
    .PC(PCF),
    .PC_Next(PC_F)
);

//declare the instruction mem
Instruction_memory Instruction_memory(
    .rst(rst),
    .A(PCF),
    .RD(InstrF)
);

//declare the pc adder 

PC_Adder PC_Adder(
    .a(PCF),
    .b(32'h00000004),
    .c(PCPlus4F)
);

always@(posedge clk or negedge rst) begin
    if(rst==1'b0)begin
        InstrF_reg<=32'h00000000;
        PCF_reg<=32'h00000000;
        PCPlus4F_reg<=32'h00000000;
    end

    else begin
        InstrF_reg <= InstrF;
        PCF_reg <= PCF;
        PCPlus4F_reg <= PCPlus4F;
    end 
end
    //assigning registers to  the output ports 
    assign InstrD = (rst==1'b0)? 32'h00000000:InstrF_reg;
    assign PCD = (rst==1'b0)?32'h00000000:PCF_reg;
    assign PCPlus4D = (rst==1'b0)?32'h00000000:PCPlus4F_reg;






endmodule