module multiplexer_b(
    input logic [31:0] sign_extended_imm,
    input logic imm_en,
    input logic [31:0] rdata2,
   // input logic [4:0] shamt,       // 5-bit shift amount for shift instructions
   // input logic shift_en,          // Flag to indicate if the operation is a shift
    output logic [31:0] opr_b
);

always_comb
begin
        opr_b = imm_en ? sign_extended_imm : rdata2;
end


endmodule