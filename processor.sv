module processor(
     input logic clk,
     input logic rst
);

    logic [31:0] pc_out;
    logic [31:0] inst;
    logic [6:0] opcode;
    logic [2:0] func3;
    logic [6:0] func7;
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [4:0] rd;
    logic [31:0] rdata1;
    logic [31:0] rdata2;
    logic [31:0] wdata;
    logic        rf_en;
    logic [3:0] aluop;
    logic imm_en;
 //   logic shift_en;
    logic [11:0] imm;
   // logic [4:0] shamt;
    logic [31:0] sign_extended_imm;
    logic [31:0] opr_a;
    logic [31:0] opr_b;
    logic [31:0] opr_res;
    logic [31:0] rdata;  //data read from data mem
    logic dm_rd;
    logic dm_wr;
    logic [1:0] wb_sel;
    logic sel_a;

    logic br_taken;
    logic j_en;
    logic [31:0] next_pc;
    logic [31:0] rdata_from_csr_file;
    logic csr_rd;
    logic csr_wr;
    logic is_mret;
    logic trap;
    logic [31:0] epc;
    logic epc_taken;

    //Program Counter instance
    pc pc_inst(
        .clk (clk),
        .rst (rst),
        .pc_in(next_pc),
        .pc_out(pc_out)
    );

    inst_mem imem(
        .addr(pc_out),
        .data(inst)
    );

    inst_dec inst_instance 
    (
        .inst (inst),
        .rs1 (rs1),
        .rs2 (rs2),
        .rd  (rd),
        .opcode (opcode),
        .func3 (func3),
        .func7 (func7)
    );

    reg_file reg_file_inst
    (
        .rs1 (rs1),
        .rs2 (rs2),
        .rd (rd),
        .rf_en (rf_en),
        .clk (clk),
        .rdata1 (rdata1),
        .rdata2 (rdata2),
        .wdata (wdata)

    );

    controller contr_inst
    (
        .opcode (opcode),
        .func3 (func3),
        .func7 (func7),
        .aluop (aluop),
        .rf_en (rf_en),
        .imm_en(imm_en),
        .dm_rd(dm_rd),
        .dm_wr(dm_wr),
        .sel_a(sel_a),
        .wb_sel(wb_sel),
        .j_en(j_en),
        .csr_rd(csr_rd),
        .csr_wr(csr_wr),
        .is_mret(is_mret),
        .trap(trap)
       // .shift_en(shift_en)
    );

    alu alu_inst 
    (
        .opr_a (opr_a),
        .opr_b (opr_b),
        .aluop (aluop),
        .opr_res (opr_res)
    );

    immediate_generator immediate_generator_inst
    (
        .inst(inst),
        .sign_extended_imm(sign_extended_imm),
        .func3(func3),
        .opcode(opcode)
       // .shamt(shamt)
    );

    //not using sign extend anymore, extension done directly in imm generator
    // sign_extend sign_extend_inst(
    //     .imm(imm),
    //     .sign_extended_imm(sign_extended_imm)
    // );

    multiplexer_b multiplexer_b_inst(
        .sign_extended_imm(sign_extended_imm),
        .imm_en(imm_en),
        .rdata2(rdata2),
     //   .shamt(shamt),
     //   .shift_en(shift_en),
        .opr_b(opr_b)
    );

    data_mem data_mem_inst (
        .addr(opr_res),
        .wdata(rdata2),
        .rdata(rdata),
        .clk(clk),
        .func3(func3),
        .dm_rd(dm_rd),
        .dm_wr(dm_wr)
    );

    multiplexer_writeback multiplexer_writeback_inst (
        .rdata_from_datamem(rdata),
        .wdata_from_alu(opr_res),
        .wdata(wdata),
        .wb_sel(wb_sel),
        .pc(pc_out),
        .rdata_from_csr_file(rdata_from_csr_file)
    );

    multiplexer_a multiplexer_a_inst(
        .rdata1(rdata1),
        .pc_out(pc_out),
        .sel_a(sel_a),
        .opr_a(opr_a)
    );

    multiplexer_pc multiplexer_pc_inst(
        .pc_out(pc_out),
        .addr_from_alu(opr_res),
        .br_taken(br_taken),
        .j_en(j_en),
        .next_pc(next_pc),
        .epc(epc),
        .epc_taken(epc_taken)
    );

    branch_cond branch_cond_inst(
        .rdata1(rdata1),
        .rdata2(rdata2),
        .func3(func3),
        .br_taken(br_taken)
    );

    CSR_register CSR_register_file_inst(
        .wdata(rdata1),
        .pc(pc_out),
        .inst(inst),
        .clk(clk),
        .rst(rst),
        .rdata(rdata_from_csr_file),
        .csr_rd(csr_rd),
        .csr_wr(csr_wr),
        .addr(pc_out),
        .is_mret(is_mret),
        .trap(trap),
        .epc(epc),
        .epc_taken(epc_taken)
    );


endmodule