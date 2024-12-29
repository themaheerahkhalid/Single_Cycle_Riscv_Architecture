module multiplexer_pc(
    input logic [31:0] pc_out,
    input logic [31:0] addr_from_alu,
    input logic br_taken,
    input logic j_en,
    input logic [31:0] epc,
    input logic epc_taken,
    output logic [31:0] next_pc
);

always_comb
begin
    if(br_taken || j_en)
    next_pc=addr_from_alu;
    else if(epc_taken)
    next_pc=epc;
    else
    next_pc=pc_out+32'd4;
end

endmodule