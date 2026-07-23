module hazard_unit(rst, RegWriteM, RegWriteW, RD_M, RDW, RS1_E, RS2_E, ForwardAE, ForwardBE)

    //declaration of the I/Os
    input rst, RegWriteM, RegWriteW;
    input [4:0]RD_M,RDW, RS1_E, RS2_E;
    output [1:0] ForwardAE, ForwardBE;

    assign ForwardAE=(rst==1'b0) ?2'b00: 
                                 ((RegWriteM)==1 & (RD_M!= 5'h00) & (RD_M == RS1_E))? 2'b10:
                                 ((RegWriteM)==1 & (RD_W!= 5'h00) & (RD_W == RS1_E))? 2'b01: 2'b00;
    assign ForwardBE=(rst==1'b0) ?2'b00: 
                                 ((RegWriteM)==1 & (RD_M!= 5'h00) & (RD_M == RS2_E))? 2'b10:
                                 ((RegWriteM)==1 & (RD_W!= 5'h00) & (RD_W == RS2_E))? 2'b01: 2'b00;


endmodule