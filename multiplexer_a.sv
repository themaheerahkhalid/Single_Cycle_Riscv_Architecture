module multiplexer_a(
    input logic [31:0] pc_out, 
    input logic sel_a,
    input logic [31:0] rdata1,
   // input logic [4:0] shamt,       // 5-bit shift amount for shift instructions
   // input logic shift_en,          // Flag to indicate if the operation is a shift
    output logic [31:0] opr_a
);

always_comb
begin
        opr_a = sel_a ? pc_out : rdata1;
end


endmodule