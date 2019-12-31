`timescale 1ns/1ns

module adder(input [31 : 0] x, input[31:0]y, output [31 : 0] z);
  assign z = x+y;
endmodule

module comparator(input [31 : 0] a, input[31:0]b, output out);
  assign out = (a == b);
endmodule
// TODO rename comprator to is_equal

module PC(input clk, rst, pc_write, input [31 : 0] pc_in, output reg [31 : 0] pc_out);
  always @(posedge clk, posedge rst) begin
    if(rst)
      pc_out <= 32'b0;
    else if(pc_write)
      pc_out <= pc_in;
    else
      pc_out <= pc_out;
  end
endmodule

module inst_memory(address, read_data);
  input [31:0] address;
  output[31:0] read_data;
  
  reg [7:0] data_memory [0:1023];
  
  initial begin
    //instructions go here
	// data_memory[0] = 8'b10001100;//lw R2 0(R0)
	// data_memory[1] = 8'b00000010;
	// data_memory[2] = 8'b00000000;
	// data_memory[3] = 8'b00000000;
	// data_memory[4] = 8'b10001100;//lw R3 4(R0)
	// data_memory[5] = 8'b00000011;
	// data_memory[6] = 8'b00000000;
	// data_memory[7] = 8'b00000100;
	// data_memory[8] = 8'b10001100;//lw R6 8(R0)
	// data_memory[9] = 8'b00000110;
	// data_memory[10] = 8'b00000000;
	// data_memory[11] = 8'b00001000;
	// data_memory[12] = 8'b10001100;//lw R7 12(R0)
	// data_memory[13] = 8'b00000111;
	// data_memory[14] = 8'b00000000;
	// data_memory[15] = 8'b00001100;
	// data_memory[16] = 8'b10001100;//lw R4 0(R2)  LABEL
	// data_memory[17] = 8'b01000100;
	// data_memory[18] = 8'b00000000;
	// data_memory[19] = 8'b00000000;
	// data_memory[20] = 8'b00000000;//add R2, R6, R2
	// data_memory[21] = 8'b01000110;
	// data_memory[22] = 8'b00010000;
	// data_memory[23] = 8'b00000010;
	// data_memory[24] = 8'b00000000;//sub R3, R7, R3
	// data_memory[25] = 8'b01100111;
	// data_memory[26] = 8'b00011000;
	// data_memory[27] = 8'b00000110;
	// data_memory[28] = 8'b00000000;//slt R1, R4, R5
	// data_memory[29] = 8'b00100100;
	// data_memory[30] = 8'b00101000;
	// data_memory[31] = 8'b00000111;
	// data_memory[32] = 8'b00000000;//nop
	// data_memory[33] = 8'b00000000;
	// data_memory[34] = 8'b00000000;
	// data_memory[35] = 8'b00000000;
	// data_memory[36] = 8'b00000000;//nop
	// data_memory[37] = 8'b00000000;
	// data_memory[38] = 8'b00000000;
	// data_memory[39] = 8'b00000000;
	// data_memory[40] = 8'b00010000;//beq R0, R5, 1
	// data_memory[41] = 8'b00000101;
	// data_memory[42] = 8'b00000000;
	// data_memory[43] = 8'b00000001;
	// data_memory[44] = 8'b00000000;//add R4, R0, R1
	// data_memory[45] = 8'b10000000;
	// data_memory[46] = 8'b00001000;
	// data_memory[47] = 8'b00000010;
	// data_memory[48] = 8'b00010100;//bne R0, R3, 1
	// data_memory[49] = 8'b00000011;
	// data_memory[50] = 8'b11111111;
	// data_memory[51] = 8'b11110111;
	// data_memory[52] = 8'b10101100;//sw R0, R1, 0
	// data_memory[53] = 8'b00000001;
	// data_memory[54] = 8'b00000000;
	// data_memory[55] = 8'b00000000;
  end
  
  assign read_data = {data_memory[address], data_memory[address + 1], data_memory[address + 2], data_memory[address + 3]};
  
endmodule

module data_memory(clk, mem_write, mem_read, address, write_data, read_data);
  input clk, mem_read, mem_write;
  input [31:0] write_data, address;
  output[31:0] read_data;
  
  integer i;
  reg [7:0] data_memory [0:2067];
  

  always @ (posedge clk) begin
    if (mem_write)begin
      data_memory [address] <= write_data[31 : 24];
      data_memory [address + 1] <= write_data[24 : 16];
      data_memory [address + 2] <= write_data[15 : 8];
      data_memory [address + 3] <= write_data[7 : 0];
    end
  end
  initial begin
	for (i = 0; i < 1024 ; i = i + 1)
        	data_memory [i] = 0;
	data_memory[0] = 8'b0;
	data_memory[1] = 8'b0;
	data_memory[2] = 8'b00000011;
	data_memory[3] = 8'b11101000;
	data_memory[4] = 8'b0;
	data_memory[5] = 8'b0;
	data_memory[6] = 8'b0;
	data_memory[7] = 8'b00000100;
	data_memory[8] = 8'b0;
	data_memory[9] = 8'b0;
	data_memory[10] = 8'b0;
	data_memory[11] = 8'b00000100;
	data_memory[12] = 8'b0;
	data_memory[13] = 8'b0;
	data_memory[14] = 8'b0;
	data_memory[15] = 8'b00000001;


	data_memory[1000] = 8'b0;
	data_memory[1001] = 8'b0;
	data_memory[1002] = 8'b0;
	data_memory[1003] = 8'd110;

	data_memory[1004] = 8'b0;
	data_memory[1005] = 8'b0;
	data_memory[1006] = 8'b0;
	data_memory[1007] = 8'd7;

	data_memory[1008] = 8'b0;
	data_memory[1009] = 8'b0;
	data_memory[1010] = 8'b0;
	data_memory[1011] = 8'd3;

	data_memory[1012] = 8'b0;
	data_memory[1013] = 8'b0;
	data_memory[1014] = 8'b0;
	data_memory[1015] = 8'd4;

	data_memory[1016] = 8'b0;
	data_memory[1017] = 8'b0;
	data_memory[1018] = 8'b0;
	data_memory[1019] = 8'd5;
  end
  
  assign read_data = (mem_read) ? {data_memory[address], data_memory[address + 1], data_memory[address + 2], data_memory[address + 3]} : 32'bz;
  
endmodule

module hazard(input [4 : 0] ID_Rs, ID_Rt, EX_Rt, input EX_mem_read, output reg controller_enable, IF_ID_enable, pc_write);
	always @(ID_Rs, ID_Rt, EX_Rt, EX_mem_read) begin
		if((EX_mem_read == 1) & (ID_Rs == EX_Rt | ID_Rt == EX_Rt)) begin
			controller_enable = 0;
			IF_ID_enable = 0;
			pc_write = 0;
		end
		else begin
			controller_enable = 1;
			IF_ID_enable = 1;
			pc_write = 1;
		end
	end
endmodule