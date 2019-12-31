`timescale 1ns/1ns
module datapath(input clk, rst);
    //Instruction Fetch
    wire pc, branch, jump, eq, e, n, eorn, controller_enable, IF_ID_enable, pc_write_mux, pc_write_in;
    wire branch_sel, WB_reg_write_out_M_WB, flush;
    wire [31 : 0] adder_pc, branch_in, jump_in, pc_in, pc_out, inst_in;
    pc_mux pcm(pc, branch_sel, jump, adder_pc, branch_in, jump_in, pc_in);
    PC program_counter(clk, rst, pc_write_in, pc_in, pc_out);
    adder a1(pc_out, 32'd4, adder_pc);
    inst_memory IM(pc_out, inst_in);
    and an1(e, eq, pc_write_cond);
    and an2(n, ~eq, pc_write_cond);
    mux_2_1 m1(n, e, eorn, branch_sel);
    assign pc = 1'b1;


    //IF/ID
    wire [31 : 0] inst_out, adder_pc_out;
    IF_ID_reg if_id_reg(clk, rst, IF_ID_enable, adder_pc, inst_in, adder_pc_out, inst_out, flush);

    //Instruction Decode
    wire [31 : 0] data1_in, data2_in, dst_adr_in, write_data;
    wire [4 : 0] Rs_in, Rt_in, Rd_in, write_reg;
    register_file RF(clk, rst, inst_out[25 : 21], inst_out[20 : 16], write_reg, write_data, WB_reg_write_out_M_WB, data1_in, data2_in);
    is_equal c(data1_in, data2_in, eq);
    adder a2(adder_pc_out, {inst_out[15], inst_out[15], inst_out[15], inst_out[15], inst_out[15], 
        inst_out[15], inst_out[15], inst_out[15], inst_out[15], inst_out[15], inst_out[15], 
        inst_out[15], inst_out[15], inst_out[15], inst_out[15 : 0], 2'b0}, branch_in);
    assign jump_in = {pc_out[31 : 28], inst_out[25 : 0] , 2'b0};
    assign Rs_in = inst_out[25 : 21];
    assign Rt_in = inst_out[20 : 16];
    assign Rd_in = inst_out[15 : 11];
    assign dst_adr_in = {16'b0, inst_out[15 : 0]};
    //controller is not devised


    //ID/EX
    wire [31 : 0] data1_out, data2_out, dst_adr_out;
    wire [4 : 0] Rt_out, Rs_out, Rd_out;
    wire [2 : 0] EX_alu_op_out_ID_EX, EX_alu_op;
    wire EX_alu_src_out_ID_EX, EX_regdst_out_ID_EX, M_mem_read_out_ID_EX, M_mem_write_out_ID_EX;
    wire ID_EX, WB_mem_to_reg_out_ID_EX;



    ID_EX_reg id_ex_reg(.clk(clk),
            .rst(rst),
            .controller_enable(controller_enable),
            .reg1_read_in(data1_in),
            .reg2_read_in(data2_in),
            .mem_address_in(dst_adr_in),
                    .rt_in(Rt_in),
            .rd_in(Rd_in),
            .rs_in(Rs_in), 
                    .alusrc_in(EX_alusrc),
            .regdst_in(EX_regdst),
            .mem_read_in(M_mem_read), 
            .mem_write_in(M_mem_write), 
            .reg_write_in(WB_reg_write), 
            .mem_to_reg_in(WB_mem_to_reg),
                    .alu_op_in(EX_alu_op),
                    .alu_op_out(EX_alu_op_out_ID_EX),
                    .reg1_read_out(data1_out),
            .reg2_read_out(data2_out),
            .mem_address_out(dst_adr_out),
                    .rt_out(Rt_out),
            .rd_out(Rd_out),
            .rs_out(Rs_out), 
                    .alusrc_out(EX_alu_src_out_ID_EX),
            .regdst_out(EX_regdst_out_ID_EX),
            .mem_read_out(M_mem_read_out_ID_EX),
                    .mem_write_out(M_mem_write_out_ID_EX),
            .reg_write_out(WB_reg_write_out_ID_EX),
            .mem_to_reg_out(WB_mem_to_reg_out_ID_EX));


    //Execution
    wire [31 : 0] aluin1, aluin2, result_in, result_out, pre_aluin2;
    wire [4 : 0] dst_in;
    wire [1 : 0] sel1, sel2;
    mux_3 aluin1_mux(data1_out, write_data, result_out, sel1, aluin1);
    mux_3 aluin2_mux1(data2_out, write_data, result_out, sel2, pre_aluin2);
    mux_2 aluin2_mux2(pre_aluin2, dst_adr_out, EX_alu_src_out_ID_EX, aluin2);
    ALU alu(aluin1, aluin2, EX_alu_op_out_ID_EX, result_in);
    mux_2 dst(Rt_out, Rd_out, EX_regdst_out_ID_EX, dst_in);


    //EX/M
    wire [31 : 0] data2_out_2, result_out_2;
    assign result_out = result_out_2;
    wire [4 : 0] dst_out;
    wire M_mem_read_out_EX_M, M_mem_write_out_EX_M, WB_reg_write_out_EX_M, WB_mem_to_reg_out_EX_M;
    EX_M_reg ex_m_reg(clk, rst, result_in, data2_out, dst_in, M_mem_read_out_ID_EX, M_mem_write_out_ID_EX, WB_reg_write_out_ID_EX,
            WB_mem_to_reg_out_ID_EX, result_out_2, data2_out_2, dst_out, M_mem_read_out_EX_M, M_mem_write_out_EX_M,
            WB_reg_write_out_EX_M, WB_mem_to_reg_out_EX_M);


    //Memory
    wire [31 : 0] memory_data_in;
    data_memory DM(clk, M_mem_write_out_EX_M, M_mem_read_out_EX_M, result_out_2, data2_out_2, memory_data_in);


    //M/WB
    wire [31 : 0] result_out_3, memory_data_out;
    //wire [4 : 0] write_reg; //dst_out_2
    wire WB_reg_write_in_M_WB, WB_mem_to_reg_in_M_WB;
    M_WB_reg m_wb_reg(clk, rst, memory_data_in, result_out_2, dst_out, WB_reg_write_out_EX_M, WB_mem_to_reg_out_EX_M, write_reg, 
            WB_mem_to_reg_out_M_WB, WB_reg_write_out_M_WB, memory_data_out, result_out_3);


    //Write Back
    mux_2 mem_reg(result_out_3, memory_data_out, WB_mem_to_reg_out_M_WB, write_data);


    //Hazard Unit
    hazard h(Rs_in, Rt_in, Rt_out, M_mem_read_out_ID_EX, controller_enable, IF_ID_enable, pc_write_mux);

    //PC Write MUX
    mux_2_1 pc_write_m(pc_write_mux, pc_write, pc_write_mux, pc_write_in);

    //Forwarding Unit
    forward f_u(Rs_out, dst_out, Rt_out, write_reg, WB_reg_write_out_ID_EX, WB_reg_write_out_EX_M, WB_reg_write_out_M_WB, sel1, sel2);

    //Control Unit
    controller cu(inst_out, EX_alusrc, EX_regdst, M_mem_read, M_mem_write, WB_reg_write
        , WB_mem_to_reg, pc_write_cond, eorn, jump, pc_write, branch, EX_alu_op, flush, eq);

endmodule