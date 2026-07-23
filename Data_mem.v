module Data_Memory(clk,rst, WE , A, WD,RD);

input [31:0] A,WD;
input rst, clk,WE;

output [31:0] RD;

reg [31:0] data_mem [1023:0];




//write 
always @(posedge clk) 
begin
    if(WE==1'b1)
    begin
        data_mem[A] <= WD;
    end 
    
end


assign RD = (~rst)? 32'd0: data_mem[A];

initial begin

    data_mem[28]=32'h00000020;
    data_mem[40]=32'h00000002;

end


endmodule