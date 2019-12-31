`timescale 1ns/1ns

module PC(input[31:0] pcInput, input pcWrite, clk, rst, output reg[31:0] pcOut);
    always @(posedge clk, posedge rst) begin
        if(rst)
            pcOut <= 32'b0;
        else if(pcWrite)
            pcOut <= pcInput;
        else
            pcOut <= pcOut;
    end
endmodule



