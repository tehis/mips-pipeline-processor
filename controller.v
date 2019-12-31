`timescale 1ns/1ns
module controller(input [31 : 0] inst, output reg branch,EX_regdst, M_mem_read, M_mem_write, WB_reg_write
	, WB_mem_to_reg,pc_write,  eorn, jump ,pc_write_cond, EX_alusrc, output reg [2 : 0] EX_aluop, output reg flush, input eq);
	

	always @(inst, eq) begin
		
		{EX_alusrc, EX_regdst, M_mem_read, M_mem_write, WB_reg_write,
		WB_mem_to_reg, pc_write_cond, eorn, jump, pc_write, branch,EX_aluop,flush} = {12'b0000000000010,3'b000, 1'b0};

		if(inst [31 : 26] == 0)
			{EX_alusrc, EX_regdst, M_mem_read, M_mem_write, WB_reg_write,
			WB_mem_to_reg, pc_write_cond, eorn, jump, pc_write, branch,EX_aluop} = {12'b1110100000000,inst[2 : 0]}; 

		else if(inst[31 : 26] == 6'b100011) //Load Word
			{EX_alusrc, EX_regdst, M_mem_read, M_mem_write, WB_reg_write,
			WB_mem_to_reg, pc_write_cond, eorn, jump, pc_write, branch,EX_aluop} = {12'b1010110000000,3'b010}; 
		else if(inst[31 : 26] == 6'b101011) //Store Word
			{EX_alusrc, EX_regdst, M_mem_read, M_mem_write, WB_reg_write,
			WB_mem_to_reg, pc_write_cond, eorn, jump, pc_write, branch,EX_aluop} = {12'b1001000000000,3'b010}; 

		else if(inst[31 : 26] == 6'b000100) //Branch Equal
			{EX_alusrc, EX_regdst, M_mem_read, M_mem_write, WB_reg_write,
			WB_mem_to_reg, pc_write_cond, eorn, jump, pc_write, branch,EX_aluop,flush} = {12'b0000001100001,3'b000, eq}; 
		else if(inst[31 : 26] == 6'b000101) //Branch not Equal
			{EX_alusrc, EX_regdst, M_mem_read, M_mem_write, WB_reg_write,
			WB_mem_to_reg, pc_write_cond, eorn, jump, pc_write, branch,EX_aluop,flush} = {12'b0000001000001,3'b000, ~eq}; 
		else if(inst[31 : 26] == 6'b000010) //Jump
			{EX_alusrc, EX_regdst, M_mem_read, M_mem_write, WB_reg_write,
			WB_mem_to_reg, pc_write_cond, eorn, jump, pc_write, branch,EX_aluop,flush} = {12'b0000001000101,3'b000, 1'b1};
	end
endmodule
