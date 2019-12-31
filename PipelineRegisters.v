`timescale 1ns/ 1ns
module IF_ID_reg(input clk, rst, wen, input[31 : 0] pc_in, inst_in, output reg [31 : 0] pc_out, inst_out, input flush);
  always @(posedge clk, posedge rst)begin
    if(rst | flush) begin
      pc_out <= 0;
      inst_out <= 0;
    end
    else if(wen) begin
      pc_out <= pc_in;
      inst_out <= inst_in;
    end
  end
  //wen write enable
endmodule


module ID_EX_reg(input clk, rst, controller_enable, input [31 : 0] reg1_read_in, reg2_read_in, mem_address_in,
                input [4 : 0] rt_in, rd_in, rs_in, 
                input alusrc_in, regdst_in, mem_read_in, mem_write_in, reg_write_in, mem_to_reg_in,
                input [2 : 0] alu_op_in ,
                output reg [2 : 0] alu_op_out ,
                output reg [31 : 0] reg1_read_out, reg2_read_out, mem_address_out,
                output reg [4 : 0] rt_out, rd_out, rs_out, 
                output reg alusrc_out, regdst_out, mem_read_out,
                output reg mem_write_out, reg_write_out, mem_to_reg_out);
   
   always@(posedge clk,posedge rst)begin
     if (rst)begin
      alu_op_out <= 0;
      reg1_read_out <= 0;
      reg2_read_out <= 0;
      mem_address_out <= 0;
      rt_out <= 0;
      rd_out <= 0;
      rs_out <= 0;
      alusrc_out <= 0;
      regdst_out <= 0;
      mem_read_out <= 0;
      mem_write_out <= 0;
      reg_write_out <= 0 ;
      mem_to_reg_out <= 0;
    end
    
  else begin
      alu_op_out <= alu_op_in;
      reg1_read_out <= reg1_read_in;
      reg2_read_out <= reg2_read_in;
      mem_address_out <= mem_address_in;
      rt_out <= rt_in;
      rd_out <= rd_in;
      rs_out <= rs_in;
      alusrc_out <= controller_enable ? alusrc_in : 0;
      regdst_out <= controller_enable ? regdst_in : 0;
      mem_read_out <= controller_enable ? mem_read_in : 0;
      mem_write_out <= controller_enable ? mem_write_in : 0;
      reg_write_out <= controller_enable ? reg_write_in : 0;
      mem_to_reg_out <=  controller_enable ? mem_to_reg_in : 0;
    end
end
endmodule


module EX_M_reg(input clk, rst, input [31 : 0] result_in, mem_address_in,
                input [4 : 0] reg_dst_in, 
                input mem_read_in, mem_write_in, reg_write_in, mem_to_reg_in,
                output reg [31 : 0] result_out, mem_address_out,
                output reg [4 : 0] reg_dst_out, 
                output reg mem_read_out,
                output reg mem_write_out, reg_write_out, mem_to_reg_out);
   
   always@(posedge clk,posedge rst)begin
     if (rst)begin
      result_out <= 0 ;
      mem_address_out <= 0;
      reg_dst_out <= 0 ;
      mem_read_out <= 0;
      mem_write_out <= 0;
      reg_write_out <= 0 ;
      mem_to_reg_out <= 0;
    end
    
  else begin
      result_out <= result_in;
      mem_address_out <= mem_address_in;
      reg_dst_out <= reg_dst_in;
      mem_read_out <= mem_read_in;
      mem_write_out <= mem_write_in;
      reg_write_out <= reg_write_in  ;
      mem_to_reg_out <=  mem_to_reg_in;
    end
  end
endmodule


module M_WB_reg(input clk, rst,
		input[31 : 0] mem_data_in, result_in, 
		input[4 : 0] reg_dst_in,
  		input reg_write_in, mem_to_reg_in,
  		output reg [4 : 0] reg_dst_out, 
		output reg mem_to_reg_out, reg_write_out, 
		output reg [31 : 0] mem_data_out, result_out);
   always@(posedge clk,posedge rst)begin
     if (rst)begin 
      result_out <= result_in;
      mem_data_out <= 0;
      reg_dst_out <= 0;
      reg_write_out <= 0;
      mem_to_reg_out <= 0;
    end
    
  else begin
      mem_data_out <= mem_data_in;
      result_out <= result_in;
      reg_dst_out <= reg_dst_in;
      reg_write_out <= reg_write_in;
      mem_to_reg_out <=  mem_to_reg_in;
    end
  end
endmodule
