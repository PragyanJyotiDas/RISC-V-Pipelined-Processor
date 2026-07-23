`include "decode_cycle.v" // Make sure to include the decode cycle file here

module tb();

    // 1. Declare Testbench Signals (Inputs to DUT must be 'reg', Outputs must be 'wire')
    reg clk = 1'b0; // Good practice to start at 0
    reg rst;
    reg RegWriteW;
    reg [4:0] RDW;
    reg [31:0] InstrD, PCD, PCPlus4D, ResultW;

    wire [31:0] RD1E, RD2E, PCE, ImmExtE, PCPlus4E;
    wire [4:0] RdE;
    wire RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE;
    wire [1:0] ResultSrcE;
    wire [2:0] ALUControlE;

    // 2. Instantiate the Device Under Test (DUT)
    decode_cycle dut (
        .clk(clk),
        .rst(rst),
        .RegWriteW(RegWriteW),
        .RDW(RDW),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D),
        .ResultW(ResultW),
        
        .RD1E(RD1E),
        .RD2E(RD2E),
        .PCE(PCE),
        .ImmExtE(ImmExtE),
        .PCPlus4E(PCPlus4E),
        .RdE(RdE),
        .RegWriteE(RegWriteE),
        .MemWriteE(MemWriteE),
        .JumpE(JumpE),
        .BranchE(BranchE),
        .ALUSrcE(ALUSrcE),
        .ResultSrcE(ResultSrcE),
        .ALUControlE(ALUControlE)
    );

    // 3. Clock Generation Logic
    always begin
        #50 clk = ~clk; // Standard way to toggle clock every 50 time units
    end 

    // 4. Provide the Stimuli
    initial begin
        // Initialize inputs and apply Reset
        rst        = 1'b0; // Using blocking '=' here for absolute initial state setup
        RegWriteW  = 1'b0;
        RDW        = 5'b0;
        InstrD     = 32'h00000000;
        PCD        = 32'h00000000;
        PCPlus4D   = 32'h00000004;
        ResultW    = 32'h00000000;
        
        #200;
        rst = 1'b1; // Release Reset (Assuming active-low reset based on your previous code)
        
        // --- Stimulus 1: Pass an actual instruction (e.g., RISC-V ADD instruction) ---
        // Let's pretend InstrD is: add x3, x1, x2 -> 32'h002081b3
        // rs1 = x1 (1), rs2 = x2 (2), rd = x3 (3)
        InstrD     = 32'h002081b3; 
        PCD        = 32'h00001000;
        PCPlus4D   = 32'h00001004;
        
        #100; // Wait 1 clock cycle (100 time units total for period)

        // --- Stimulus 2: Simulate Writeback Stage writing to a register ---
        // Let's write the value 32'hABCDEFFF into register x1 (so our next read can grab it)
        RegWriteW  = 1'b1;
        RDW        = 5'd1;          // Target register x1
        ResultW    = 32'hABCDEFFF;  // Data to write
        
        #100;
        RegWriteW  = 1'b0; // Turn off writeback
        
        #300;
        $finish;
    end 

    // 5. Waveform Dump Configuration
    initial begin
        $dumpfile("decodedump.vcd");
        $dumpvars(0, tb); // Explicitly stating 'tb' ensures everything inside the testbench is captured
    end 

endmodule