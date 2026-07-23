`include "fetch_cycle.v"
module tb();

    //declare the i/o
    reg clk=1'b1,rst,PCSrcE;
    reg [31:0]PCTargetE;
    wire [31:0] InstrD,PCD,PCPlus4D;


    //declare the dut 
    fetch_cycle dut(
        .clk(clk),
        .rst(rst),
        .PCSrcE(PCSrcE),
        .PCTargetE(PCTargetE),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D)
        );

    //generation of clock
    always begin
        clk=~clk;
        #50;
    end 

    //provide the stimuli
    initial
    begin
        rst<=1'b0;
        #200;
        rst<=1'b1;
        PCSrcE <=1'b0;
        PCTargetE<=32'h00000000;
        #500;
        $finish;
    end 

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0);
    end 


endmodule