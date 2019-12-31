`timescale 1ns/1ns
module controller(input [31 : 0] inst, output reg EX_alusrc, EX_regdst, M_mem_read, M_mem_write, WB_reg_write
	, WB_mem_to_reg, pc_write_cond, eorn, jump, pc_write, branch, output reg [2 : 0] EX_aluop, output reg flush, input eq);
	

	always @(inst, eq) begin
		EX_alusrc = 0; EX_regdst = 0; M_mem_read = 0; M_mem_write = 0; WB_reg_write = 0;
		WB_mem_to_reg = 0; pc_write_cond = 0; eorn = 0; jump = 0; pc_write = 1; EX_aluop = 0; branch = 0;
		if(inst [31 : 26] == 0) begin //Register Type
			EX_alusrc = 0;
			EX_aluop = inst[2 : 0];
			EX_regdst = 1;
			M_mem_read = 0;
			M_mem_write = 0;
			WB_reg_write = 1;
			WB_mem_to_reg = 0;
			flush = 0;
		end
		else if(inst[31 : 26] == 6'b100011) begin //Load Word
			EX_alusrc = 1;
			EX_aluop = 3'b010;
			EX_regdst = 0;
			M_mem_read = 1;
			M_mem_write = 0;
			WB_reg_write = 1;
			WB_mem_to_reg = 1;
			flush = 0;
		end
		else if(inst[31 : 26] == 6'b101011) begin //Store Word
			EX_alusrc = 1;
			EX_aluop = 3'b010;
			EX_regdst = 0;
			M_mem_read = 0;
			M_mem_write = 1;
			WB_reg_write = 0;
			WB_mem_to_reg = 0;
			flush = 0;
		end
		else if(inst[31 : 26] == 6'b000100) begin //Branch Equal
			pc_write_cond = 1;
			eorn = 1;
			branch = 1;
			flush = eq;
		end
		else if(inst[31 : 26] == 6'b000101) begin //Branch not Equal
			pc_write_cond = 1;
			eorn = 0;
			branch = 1;
			flush = ~eq;
		end
		else if(inst[31 : 26] == 6'b000010) begin //Jump
			jump = 1;
			flush = 1;
		end
		else begin
			EX_alusrc = 0; EX_regdst = 0; M_mem_read = 0; M_mem_write = 0; WB_reg_write = 0;
			WB_mem_to_reg = 0; pc_write_cond = 0; eorn = 0; jump = 0; pc_write = 1; EX_aluop = 0; branch = 0;
		end
	end
endmodule
