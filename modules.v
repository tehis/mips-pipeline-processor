`timescale 1ns/1ns

module adder(input [31 : 0] x, input[31:0]y, output [31 : 0] z);
  assign z = x+y;
endmodule
