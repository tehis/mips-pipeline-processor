`timescale 1ns/1ns
module Mux2_31bits(input[31:0] input1, input2, input select, output[31:0] result);
    assign result = (selecet == 0) ? input1:inout2;
endmodule

module Mux2_1bits(input input1, input2, select, output result);
    assign result = (select == 0) ? input1 : input2;
endmodule

module Mux3(input[31:0] input1, input2, input3, input[1:0]select, output[31:0] res);
    assign res = (select == 0) ? input1:(select==1)?input1:(select==2)?input2;
endmodule

module Pc_Mux(input pcWrite, isBranch, jump, input[31:0]pcInput, branchInput, jumpInput, output[31:0]res);
    assign res = (isBranch == 1)?branchInput:(jump==1)?jumpInput:(pcWrite==1)?pcInput;
endmodule

